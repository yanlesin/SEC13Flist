#' @title Official List of Section 13(f) Securities
#'
#' @description This function downloads, specified by Year and Quarter (starting from year 2004, quarter 1), official list of Section 13(f) securities from SEC website <https://www.sec.gov/divisions/investment/13flists.htm>, parses it and returns a data frame. If no parameters provided, function determines year and quarter based on Current List section of SEC website <https://www.sec.gov/divisions/investment/13flists.htm>
#' @param YEAR_ Numeric, Year for the SEC List
#' @param QUARTER_ Numeric, Quarter for the SEC List
#' @param show_progress Logical, Option is not active in this build! Show progress during list parsing, default value show_progress = FALSE
#' @keywords SEC 13F List
#' @return A data frame that contains official list of Section 13(f) securities with the following columns:
#' \itemize{
#' \item \code{CUSIP}: character - CUSIP number of the security included in the official list
#' \item \code{HAS_LISTED_OPTION}: character - An asterisk indicates that security having a listed option and each option is individually listed with its own CUSIP number immediately below the name of the security having the option
#' \item \code{ISSUER_NAME}: character - Issuer name
#' \item \code{ISSUER_DESCRIPTION}: character - Issuer description
#' \item \code{STATUS}: character - "ADDED" (The security has become a Section 13(f) security) or "DELETED" (The security ceases to be a 13(f) security since the date of the last list)
#' \item \code{YEAR}: integer - Year of the official list
#' \item \code{QUARTER}: integer - Quarter of the official list
#' }
#' @export
#' @examples
#' \donttest{library(SEC13Flist)
#' SEC_13F_list_2018_Q3 <- SEC_13F_list(2018,3) #Parse list for Q3 2018 without progress indicator
#' SEC_13F_list_2018_Q3_ <- SEC_13F_list(2018,3,TRUE) #Parse list with progress indicator
#' SEC_13F_list_current <- SEC_13F_list() #Parse current list from SEC.gov
#' }
#' @useDynLib SEC13Flist, .registration = TRUE
#' @importFrom Rcpp sourceCpp
#' @importFrom rlang ':='

SEC_13F_list <- function(YEAR_,QUARTER_, show_progress = FALSE){

  url_SEC <- "https://www.sec.gov/divisions/investment/13flists.htm"

  current_list_url <- xml2::xml_attrs(
    xml2::xml_child(
      rvest::html_nodes(
        xml2::read_html(url_SEC),'#block-secgov-content :nth-child(1)'
      )[[23]],1
    ))

  current_year <- stringr::str_sub(current_list_url,stringr::str_length(current_list_url)-9,stringr::str_length(current_list_url)-6) %>%
    as.integer()

  current_quarter <- stringr::str_sub(current_list_url,stringr::str_length(current_list_url)-4,stringr::str_length(current_list_url)-4) %>%
    as.integer()

  if (missing(YEAR_)) {
    YEAR_ <- current_year
    warning("Default year: ", YEAR_)
  }

  if (missing(QUARTER_)) {
    QUARTER_ <- current_quarter
    warning("Default quarter: ", QUARTER_)
  }

  url_file <- url_file_func(YEAR_,QUARTER_,current_year,current_quarter)

  text <- pdftools::pdf_text(url_file)

  pages <- length(text)

  CR <- stringr::str_locate(text[1],"\r")[1]
  LF <- stringr::str_locate(text[1],"\n")[1]
  table_start <- which(!is.na(stringr::str_locate(text,"Run Date:")[,1]))[1]

  line_separator <- line_separator_func(CR, LF, text[1])

  PDF_STRING <- "PDF_STRING"

  text2 <- readr::read_lines(text)
  table_start_2 <- which(!is.na(stringr::str_locate(text2,"Run Date:")[,1]))[1]
  pages_2 <- length(text2)
  text2 <- text2[table_start_2:pages_2] %>%
    as.data.frame(stringsAsFactors=FALSE)
  names(text2) <- PDF_STRING

  CUSIP_start <- "CUSIP_start"
  ISSUER_NAME_start <- "ISSUER_NAME_start"
  ISSUER_DESCRIPTION_start <- "ISSUER_DESCRIPTION_start"
  STATUS_start <- "STATUS_start"
  CUSIP_end <- "CUSIP_end"
  HAS_LISTED_OPTION_start <- "HAS_LISTED_OPTION_start"
  HAS_LISTED_OPTION_end <- "HAS_LISTED_OPTION_end"
  ISSUER_NAME_end <- "ISSUER_NAME_end"
  ISSUER_DESCRIPTION_end <- "ISSUER_DESCRIPTION_end"
  STATUS_end <- "STATUS_end"

  text2 <- text2 %>%
    dplyr::mutate(!!CUSIP_start:=regexpr("CUSIP", text2$PDF_STRING),
                  !!ISSUER_NAME_start:=regexpr("ISSUER NAME", text2$PDF_STRING),
                  !!ISSUER_DESCRIPTION_start:=regexpr("ISSUER DESCRIPTION", text2$PDF_STRING),
                  !!STATUS_start:=regexpr("STATUS", text2$PDF_STRING)) %>%
    dplyr::na_if(-1) %>%
    dplyr::filter(!stringr::str_detect(PDF_STRING, "Run Date")) %>%
    dplyr::filter(!stringr::str_detect(PDF_STRING, "Run Time")) %>%
    dplyr::filter(!stringr::str_detect(PDF_STRING, "Total C")) %>%
    dplyr::filter(stringr::str_detect(PDF_STRING, "")) %>%
    dplyr::filter(!stringr::str_detect(PDF_STRING, "\f")) %>%
    tidyr::fill(CUSIP_start, ISSUER_NAME_start, ISSUER_DESCRIPTION_start, STATUS_start, .direction = "down") %>%
    dplyr::mutate(!!CUSIP_end:=CUSIP_start+11-1,
                  !!HAS_LISTED_OPTION_start:=CUSIP_end+1,
                  !!HAS_LISTED_OPTION_end:=ISSUER_NAME_start-1,
                  !!ISSUER_NAME_end:=ISSUER_DESCRIPTION_start-1,
                  !!ISSUER_DESCRIPTION_end:=STATUS_start-1,
                  !!STATUS_end:=stringr::str_length(PDF_STRING),
                  STATUS_end=max(STATUS_end))

  CUSIP <- "CUSIP"
  HAS_LISTED_OPTION <- "HAS_LISTED_OPTION"
  ISSUER_NAME <- "ISSUER_NAME"
  ISSUER_DESCRIPTION <- "ISSUER_DESCRIPTION"
  STATUS <- "STATUS"
  CUSIP <- "CUSIP"

  List_13F <- text2 %>%
    dplyr::mutate(
      !!CUSIP := substring(PDF_STRING, CUSIP_start, CUSIP_end),
      !!HAS_LISTED_OPTION := stringr::str_trim(
        substring(PDF_STRING, HAS_LISTED_OPTION_start, HAS_LISTED_OPTION_end),
        side = "both"
      ),
      !!ISSUER_NAME := stringr::str_trim(
        substring(PDF_STRING, ISSUER_NAME_start, ISSUER_NAME_end),
        side = "both"
      ),
      !!ISSUER_DESCRIPTION := stringr::str_trim(
        substring(PDF_STRING, ISSUER_DESCRIPTION_start, ISSUER_DESCRIPTION_end),
        side = "both"
      ),
      !!STATUS := stringr::str_trim(substr(PDF_STRING, STATUS_start, STATUS_end), side =
                          "both"),
      !!CUSIP := stringr::str_replace_all(CUSIP, " ", ""),
      STATUS=ifelse(STATUS=="DDED"|STATUS=="ELETED",
                    paste0(stringr::str_sub(ISSUER_DESCRIPTION,-1),STATUS),
                    STATUS),
      ISSUER_DESCRIPTION=ifelse(STATUS=="DDED"|STATUS=="ELETED",
                                stringr::str_trim(stringr::str_sub(ISSUER_DESCRIPTION, 1, stringr::str_length(ISSUER_DESCRIPTION)-1),
                                         side="right"),
                                ISSUER_DESCRIPTION)

    ) %>%
    dplyr::filter(!stringr::str_detect(CUSIP, "CUSIP")) %>%
    dplyr::select(-1:-11) %>%
    dplyr::mutate(YEAR = YEAR_, QUARTER = QUARTER_)
  return(List_13F)
}
