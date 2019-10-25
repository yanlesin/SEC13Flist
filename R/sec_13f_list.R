#' @title Official List of Section 13(f) Securities
#'
#' @description This function downloads, specified by Year and Quarter, Official List of Section 13(f) Securities from SEC website, parses it and returns dataframe. If no parameters provided, function determines year and quarter based on Current List section of SEC website
#' @param YEAR_ Numeric, Year for the SEC List
#' @param QUARTER_ Numeric, Quarter for the SEC List
#' @param show_progress Logical, Show progress during list parsing, default value show_progress = FALSE
#' @keywords SEC 13F List
#' @export
#' @examples
#' library(SEC13Flist)
#' SEC_13F_list_2018_Q3 <- SEC_13F_list(2018,3) #Parse list for Q3 2018 without progress indicator
#' SEC_13F_list_2018_Q3_ <- SEC_13F_list(2018,3,TRUE) #Parse list with progress indicator
#' SEC_13F_list_current <- SEC_13F_list() #Parse current list from SEC.gov
#' @useDynLib SEC13Flist, .registration = TRUE
#' @importFrom Rcpp sourceCpp

SEC_13F_list <- function(YEAR_,QUARTER_, show_progress = FALSE){

  str_split_wrap <- function(text){
    stringr::str_split(text,line_separator, simplify = FALSE)
  }

  url_SEC <- "https://www.sec.gov/divisions/investment/13flists.htm"

  current_list_url <- xml2::xml_attrs(
    rvest::html_nodes(
      xml2::read_html(url_SEC),'#block-secgov-content :nth-child(1)'
    )[[23]]
  )

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

  #Validating inputs to the function
  YEAR_ <- as.integer(YEAR_)
  QUARTER_ <- as.integer(QUARTER_)

  if (is.na(YEAR_)|is.na(QUARTER_)) stop("Error: Please supply integer values for QUARTER_ and YEAR_ starting in Q1 2004")

  if (YEAR_<2004) stop("Error: SEC_13F_list function only works with SEC list files starting at Q1 2004")
  if (QUARTER_>4) stop("Error: Please, supply integer number for QUARTER_ in range between 1 and 4")

  if (YEAR_>current_year) stop (paste0("Error: no list available for year ",
                                       YEAR_, ". Please, use integer number in range 2004..", current_year))

  if (YEAR_==2004&QUARTER_==1)
  {
    file_name <- "13f-list.pdf"
    url_file <- paste0("https://www.sec.gov/divisions/investment/",file_name)
  }
  else
  {
    file_name <- paste0('13flist',YEAR_, 'q', QUARTER_,'.pdf')
    url_file <- paste0("https://www.sec.gov/divisions/investment/13f/",file_name)
  }

  text <- pdftools::pdf_text(url_file)
  pages <- length(text)

  CR <- stringr::str_locate(text[1],"\r")[1]
  LF <- stringr::str_locate(text[1],"\n")[1]

  if (!is.na(CR)) {
    if (stringr::str_sub(text[1], CR + 1, CR + 1) == "\n") {
      line_separator <-"\r\n"
    } else {
      line_separator <-"\r"
    }
  } else {
    if (!is.na(LF)) {
      line_separator <- "\n"
    } else {
      stop("Undefined line separator")
    }
  }

  text2 <- if(show_progress) purrr::map(.x = text,.f = purrrogress::with_progress(fun=str_split_wrap, type="txt")) else purrr::map(.x = text, .f = str_split_wrap)
  text2 <- text2[3:pages] %>%
    unlist()
  text2 <- as.data.frame(text2,stringsAsFactors=FALSE) %>%
    dplyr::rename(PDF_STRING=text2)

  text2 <- text2 %>%
    dplyr::mutate(CUSIP_start=regexpr("CUSIP", text2$PDF_STRING),
                  ISSUER_NAME_start=regexpr("ISSUER NAME", text2$PDF_STRING),
                  ISSUER_DESCRIPTION_start=regexpr("ISSUER DESCRIPTION", text2$PDF_STRING),
                  STATUS_start=regexpr("STATUS", text2$PDF_STRING)) %>%
    dplyr::na_if(-1) %>%
    dplyr::filter(!stringr::str_detect(PDF_STRING, "Run Date")) %>%
    dplyr::filter(!stringr::str_detect(PDF_STRING, "Run Time")) %>%
    dplyr::filter(!stringr::str_detect(PDF_STRING, "Total C")) %>%
    dplyr::filter(stringr::str_detect(PDF_STRING, "")) %>%
    tidyr::fill(CUSIP_start, ISSUER_NAME_start, ISSUER_DESCRIPTION_start, STATUS_start, .direction = "down") %>%
    dplyr::mutate(CUSIP_end=CUSIP_start+11-1,
                  HAS_LISTED_OPTION_start=CUSIP_end+1,
                  HAS_LISTED_OPTION_end=ISSUER_NAME_start-1,
                  ISSUER_NAME_end=ISSUER_DESCRIPTION_start-1,
                  ISSUER_DESCRIPTION_end=STATUS_start-1,
                  STATUS_end=stringr::str_length(PDF_STRING),
                  STATUS_end=max(STATUS_end))


  List_13F <- text2 %>%
    dplyr::mutate(
      CUSIP = substring(PDF_STRING, CUSIP_start, CUSIP_end),
      HAS_LISTED_OPTION = stringr::str_trim(
        substring(PDF_STRING, HAS_LISTED_OPTION_start, HAS_LISTED_OPTION_end),
        side = "both"
      ),
      ISSUER_NAME = stringr::str_trim(
        substring(PDF_STRING, ISSUER_NAME_start, ISSUER_NAME_end),
        side = "both"
      ),
      ISSUER_DESCRIPTION = stringr::str_trim(
        substring(PDF_STRING, ISSUER_DESCRIPTION_start, ISSUER_DESCRIPTION_end),
        side = "both"
      ),
      STATUS = stringr::str_trim(substr(PDF_STRING, STATUS_start, STATUS_end), side =
                          "both"),
      CUSIP = stringr::str_replace_all(CUSIP, " ", "")
    ) %>%
    dplyr::filter(!stringr::str_detect(CUSIP, "CUSIP")) %>%
    dplyr::select(-1:-11) %>%
    dplyr::mutate(YEAR = YEAR_, QUARTER = QUARTER_)
  return(List_13F)
}
