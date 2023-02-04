line_separator_func <- function(CR, LF, text)
{
  if (!is.na(CR)) {
    if (substr(text, CR + 1, CR + 1) == "\n") {
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
  else if (YEAR_ < 2021 | (YEAR_ == 2021 & QUARTER_ <= 1))
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

process_file_func <- function(text, YEAR_, QUARTER_) {

  CUSIP_start <- NULL
  ISSUER_NAME_start <- NULL
  ISSUER_DESCRIPTION_start <- NULL
  STATUS_start <- NULL
  PDF_STRING <- NULL

  pages <- length(text)

  table_start <- match(1, regexpr("Run Date:", text))

  text2 <- readr::read_lines(text)
  table_start_2 <- match(1, regexpr("Run Date:", text2))
  pages_2 <- length(text2)
  text2 <- text2[table_start_2:pages_2] |>
    as.data.frame(stringsAsFactors = FALSE)
  names(text2) <- "PDF_STRING"

  CUSIP_end <- "CUSIP_end"
  HAS_LISTED_OPTION_start <- "HAS_LISTED_OPTION_start"
  HAS_LISTED_OPTION_end <- "HAS_LISTED_OPTION_end"
  ISSUER_NAME_end <- "ISSUER_NAME_end"
  ISSUER_DESCRIPTION_end <- "ISSUER_DESCRIPTION_end"
  STATUS_end <- "STATUS_end"

  text2$CUSIP_start <- regexpr("CUSIP", text2$PDF_STRING)
  text2$ISSUER_NAME_start <- regexpr("ISSUER NAME", text2$PDF_STRING)
  text2$ISSUER_DESCRIPTION_start  <-  regexpr("ISSUER DESCRIPTION", text2$PDF_STRING)
  text2$STATUS_start <- regexpr("STATUS", text2$PDF_STRING)

  text2$CUSIP_start <- replace(text2$CUSIP_start, which(text2$CUSIP_start == -1), NA)
  text2$ISSUER_NAME_start <- replace(text2$ISSUER_NAME_start, which(text2$ISSUER_NAME_start == -1), NA)
  text2$ISSUER_DESCRIPTION_start  <- replace(text2$ISSUER_DESCRIPTION_start, which(text2$ISSUER_DESCRIPTION_start == -1), NA)
  text2$STATUS_start <- replace(text2$STATUS_start, which(text2$STATUS_start == -1), NA)

  # subset(text2,
  #                 !grepl("Run Date", PDF_STRING) |
  #                   !grepl("Run Time", PDF_STRING) |
  #                   !grepl("Total C", PDF_STRING) |
  #                   PDF_STRING != "" |
  #                   !grepl("\f", PDF_STRING)
  #                 )

  text2 <- text2 |>
    dplyr::filter(!grepl("Run Date", PDF_STRING)) |>
    dplyr::filter(!grepl("Run Time", PDF_STRING)) |>
    dplyr::filter(!grepl("Total C", PDF_STRING)) |>
    dplyr::filter(PDF_STRING != "") |>
    dplyr::filter(!grepl("\f", PDF_STRING)) |>
    tidyr::fill(
      CUSIP_start,
      ISSUER_NAME_start,
      ISSUER_DESCRIPTION_start,
      STATUS_start,
      .direction = "down"
    ) |>
    dplyr::mutate(
      !!CUSIP_end := CUSIP_start + 11 - 1,
      !!HAS_LISTED_OPTION_start := CUSIP_end +
        1,
      !!HAS_LISTED_OPTION_end := ISSUER_NAME_start - 1,
      !!ISSUER_NAME_end := ISSUER_DESCRIPTION_start -
        1,
      !!ISSUER_DESCRIPTION_end := STATUS_start - 1,
      !!STATUS_end := nchar(PDF_STRING),
      STATUS_end = max(STATUS_end)
    )

  CUSIP <- "CUSIP"
  HAS_LISTED_OPTION <- "HAS_LISTED_OPTION"
  ISSUER_NAME <- "ISSUER_NAME"
  ISSUER_DESCRIPTION <- "ISSUER_DESCRIPTION"
  STATUS <- "STATUS"
  CUSIP <- "CUSIP"

  List_13F <- text2 |>
    dplyr::mutate(
      !!CUSIP := substr(PDF_STRING, CUSIP_start, CUSIP_end),
      !!HAS_LISTED_OPTION := trimws(substr(PDF_STRING, HAS_LISTED_OPTION_start, HAS_LISTED_OPTION_end),
        "both"),
      !!ISSUER_NAME := trimws(substr(PDF_STRING, ISSUER_NAME_start, ISSUER_NAME_end),
        "both"),
      !!ISSUER_DESCRIPTION := trimws(
        substr(
          PDF_STRING,
          ISSUER_DESCRIPTION_start,
          ISSUER_DESCRIPTION_end
        ),
        "both"),
      !!STATUS := trimws(substr(PDF_STRING, STATUS_start, STATUS_end), "both"),!!CUSIP := gsub(" ", "", CUSIP),
      #handling of edge cases for cut-offs
      STATUS = ifelse(
        STATUS == "DDED" | STATUS == "ELETED",
        paste0(substr(
          ISSUER_DESCRIPTION,
          nchar(ISSUER_DESCRIPTION),
          nchar(ISSUER_DESCRIPTION)
        ), STATUS),
        STATUS
      ),
      STATUS = ifelse(STATUS == "D",
                      "",
                      STATUS),
      ISSUER_DESCRIPTION = ifelse(
        STATUS == "DDED" | STATUS == "ELETED",
        trimws(substr(
          ISSUER_DESCRIPTION, 1, nchar(ISSUER_DESCRIPTION) - 1
        ),
        "right"),
        ISSUER_DESCRIPTION
      ),
      ISSUER_DESCRIPTION = ifelse(
        STATUS == "D",
        paste0(ISSUER_DESCRIPTION, "D"),
        ISSUER_DESCRIPTION
      ),
      ISSUER_DESCRIPTION = ifelse(
        STATUS == "D   ADDED",
        trimws(paste0(
          ISSUER_DESCRIPTION, substr(STATUS, 1, 4)
        ), "both"),
        ISSUER_DESCRIPTION
      ),
      STATUS = ifelse(STATUS == "D   ADDED",
                      substr(STATUS, 5, 9),
                      STATUS)
    ) |>
    dplyr::filter(!grepl("CUSIP", CUSIP))

  List_13F$YEAR <- YEAR_
  List_13F$QUARTER <- QUARTER_
  List_13F <- List_13F[-c(1:11)]

  return(List_13F)
}
