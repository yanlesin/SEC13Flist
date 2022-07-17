line_separator_func <- function(CR, LF, text)
{
  if (!is.na(CR)) {
    if (stringr::str_sub(text, CR + 1, CR + 1) == "\n") {
      line_separator <- "\r\n"
    } else {
      line_separator <- "\r"
    }
  } else {
    if (!is.na(LF)) {
      line_separator <- "\n"
    } else {
      stop("Undefined line separator")
    }
  }
}

url_file_func <- function(YEAR_,
                          QUARTER_,
                          current_year,
                          current_quarter)
{
  if (missing(YEAR_) &
      current_year == 0 |
      missing(QUARTER_) &
      current_quarter == 0)
    stop(
      "Error: Unable to determine current year or quarter. Please supply YEAR and QUARTER in function call and report this error"
    )

  if (missing(YEAR_)) {
    YEAR_ <- current_year
    warning("Default year: ", YEAR_)
  }

  if (missing(QUARTER_)) {
    QUARTER_ <- current_quarter
    warning("Default quarter: ", QUARTER_)
  }

  #0,0 supplied in function call
  if (YEAR_ == 0 |
      QUARTER_ == 0)
    stop(
      "Error: Please supply integer values for YEAR_ and QUARTER_ starting in 2004 Q1. Example: SEC_13F_list(2004, 1)"
    )

  #Validating inputs to the function
  YEAR_ <- as.integer(YEAR_)
  QUARTER_ <- as.integer(QUARTER_)

  if (is.na(YEAR_) |
      is.na(QUARTER_))
    stop(
      "Error: Please supply integer values for YEAR_ and QUARTER_ starting in 2004 Q1. Example: SEC_13F_list(2004, 1)"
    )

  if (YEAR_ < 2004)
    stop(
      "Error: SEC_13F_list function only works with SEC list files starting at Q1 2004. Example: SEC_13F_list(2004, 1)"
    )
  if (QUARTER_ > 4)
    stop("Error: Please, supply integer number for QUARTER_ in range between 1 and 4")

  if (current_year != 0)
    (if (YEAR_ > current_year)
      stop (
        paste0(
          "Error: no list available for year ",
          YEAR_,
          ". Please, use integer number in range 2004..",
          current_year
        )
      ))

  if (current_quarter != 0)
    (if (YEAR_ == current_year &
         QUARTER_ > current_quarter)
      stop (
        paste0(
          "Error: no list available for year ",
          YEAR_,
          " and quarter ",
          QUARTER_,
          ". Last available quarter for current year - ",
          current_quarter,
          "."
        )
      ))

  if (YEAR_ == 2004 & QUARTER_ == 1)
  {
    file_name <- "13f-list.pdf"
    url_file <-
      paste0("https://www.sec.gov/divisions/investment/", file_name)
  }
  else if(YEAR_ < 2021 | (YEAR_ == 2021 & QUARTER_ <= 1))
  {
    file_name <- paste0('13flist', YEAR_, 'q', QUARTER_, '.pdf')
    url_file <-
      paste0("https://www.sec.gov/divisions/investment/13f/",
             file_name)
  } else {
    file_name <- paste0('13flist', YEAR_, 'q', QUARTER_, '.pdf')
    url_file <-
      paste0("https://www.sec.gov/files/investment/",
             file_name)
  }
  return(url_file)
}

process_file_func <- function(text, YEAR_, QUARTER_){
  pages <- length(text)

  table_start <- which(!is.na(stringr::str_locate(text,"Run Date:")[,1]))[1]

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
      #handling of edge cases for cut-offs
      STATUS=ifelse(STATUS=="DDED"|STATUS=="ELETED",
                    paste0(stringr::str_sub(ISSUER_DESCRIPTION,-1),STATUS),
                    STATUS),
      ISSUER_DESCRIPTION=ifelse(STATUS=="DDED"|STATUS=="ELETED",
                                stringr::str_trim(stringr::str_sub(ISSUER_DESCRIPTION, 1, stringr::str_length(ISSUER_DESCRIPTION)-1),
                                                  side="right"),
                                ISSUER_DESCRIPTION),

      ISSUER_DESCRIPTION=ifelse(STATUS=="D   ADDED",
                                stringr::str_trim(
                                  paste0(ISSUER_DESCRIPTION, stringr::str_sub(STATUS, 1, 4))),
                                ISSUER_DESCRIPTION),
      STATUS=ifelse(STATUS=="D   ADDED",
                    stringr::str_sub(STATUS, 5, 9),
                    STATUS)

    ) %>%
    dplyr::filter(!stringr::str_detect(CUSIP, "CUSIP")) %>%
    dplyr::select(-1:-11) %>%
    dplyr::mutate(YEAR = YEAR_, QUARTER = QUARTER_)
  return(List_13F)
}
