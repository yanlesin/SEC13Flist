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
  CUSIP_end <- NULL
  HAS_LISTED_OPTION_start <- NULL
  HAS_LISTED_OPTION_end <- NULL
  ISSUER_NAME_end <- NULL
  ISSUER_DESCRIPTION_end <- NULL
  STATUS_end <- NULL
  CUSIP <- NULL
  HAS_LISTED_OPTION <- NULL
  ISSUER_NAME <- NULL
  ISSUER_DESCRIPTION <- NULL
  STATUS <- NULL

  pages <- length(text)

  table_start <- match(1, regexpr("Run Date:", text))

  text2 <- readLines(con = textConnection(text))
  table_start_2 <- match(1, regexpr("Run Date:", text2))
  pages_2 <- length(text2)
  text2 <- text2[table_start_2:pages_2] |>
    as.data.frame(stringsAsFactors = FALSE)
  names(text2) <- "PDF_STRING"

  text2$CUSIP_start <- regexpr("CUSIP", text2$PDF_STRING)
  text2$ISSUER_NAME_start <- regexpr("ISSUER NAME", text2$PDF_STRING)
  text2$ISSUER_DESCRIPTION_start  <-  regexpr("ISSUER DESCRIPTION", text2$PDF_STRING)
  text2$STATUS_start <- regexpr("STATUS", text2$PDF_STRING)

  text2$CUSIP_start <- replace(text2$CUSIP_start, which(text2$CUSIP_start == -1), NA)
  text2$ISSUER_NAME_start <- replace(text2$ISSUER_NAME_start, which(text2$ISSUER_NAME_start == -1), NA)
  text2$ISSUER_DESCRIPTION_start  <- replace(text2$ISSUER_DESCRIPTION_start, which(text2$ISSUER_DESCRIPTION_start == -1), NA)
  text2$STATUS_start <- replace(text2$STATUS_start, which(text2$STATUS_start == -1), NA)

  text2 <- subset(text2,
                  !grepl("Run Date", PDF_STRING) &
                    !grepl("Run Time", PDF_STRING) &
                    !grepl("Total C", PDF_STRING) &
                    PDF_STRING != "" &
                    !grepl("\f", PDF_STRING)
                  )

  text2 <- text2 |>
    tidyr::fill(
      CUSIP_start,
      ISSUER_NAME_start,
      ISSUER_DESCRIPTION_start,
      STATUS_start,
      .direction = "down"
    )

  text2$CUSIP_end <- text2$CUSIP_start + 11 - 1
  text2$HAS_LISTED_OPTION_start <-  text2$CUSIP_end + 1
  text2$HAS_LISTED_OPTION_end <-  text2$ISSUER_NAME_start - 1
  text2$ISSUER_NAME_end <- text2$ISSUER_DESCRIPTION_start -1
  text2$ISSUER_DESCRIPTION_end  <- text2$STATUS_start - 1
  text2$STATUS_end <- nchar(text2$PDF_STRING)
  text2$STATUS_end <- max(text2$STATUS_end)

  text2$CUSIP<- substr(text2$PDF_STRING, text2$CUSIP_start, text2$CUSIP_end)
  text2$HAS_LISTED_OPTION <- trimws(substr(text2$PDF_STRING, text2$HAS_LISTED_OPTION_start, text2$HAS_LISTED_OPTION_end), "both")
  text2$ISSUER_NAME <- trimws(substr(text2$PDF_STRING, text2$ISSUER_NAME_start, text2$ISSUER_NAME_end),
        "both")
  text2$ISSUER_DESCRIPTION <- trimws(
        substr(
          text2$PDF_STRING,
          text2$ISSUER_DESCRIPTION_start,
          text2$ISSUER_DESCRIPTION_end
        ),
        "both")
  text2$STATUS <- trimws(substr(text2$PDF_STRING, text2$STATUS_start, text2$STATUS_end), "both")
  text2$CUSIP <- gsub(" ", "", text2$CUSIP)
      #handling of edge cases for cut-offs
  text2$STATUS = ifelse(
    text2$STATUS == "DDED" | text2$STATUS == "ELETED",
        paste0(substr(
          text2$ISSUER_DESCRIPTION,
          nchar(text2$ISSUER_DESCRIPTION),
          nchar(text2$ISSUER_DESCRIPTION)
        ), text2$STATUS),
    text2$STATUS
      )
  text2$STATUS = ifelse(text2$STATUS == "D", "", text2$STATUS)
  text2$ISSUER_DESCRIPTION = ifelse(
    text2$STATUS == "DDED" | text2$STATUS == "ELETED",
    trimws(substr(
      text2$ISSUER_DESCRIPTION,
      1,
      nchar(text2$ISSUER_DESCRIPTION) - 1
    ),
    "right"),
    text2$ISSUER_DESCRIPTION
  )
  text2$ISSUER_DESCRIPTION = ifelse(
    text2$STATUS == "D",
        paste0(text2$ISSUER_DESCRIPTION, "D"),
    text2$ISSUER_DESCRIPTION
      )
  text2$ISSUER_DESCRIPTION = ifelse(
    text2$STATUS == "D   ADDED",
        trimws(paste0(
          text2$ISSUER_DESCRIPTION, substr(text2$STATUS, 1, 4)
        ), "both"),
    text2$ISSUER_DESCRIPTION
      )
  text2$STATUS = ifelse(text2$STATUS == "D   ADDED",
                      substr(text2$STATUS, 5, 9),
                      text2$STATUS)
#2023 Q3 report
  text2$ISSUER_DESCRIPTION = ifelse(
    text2$STATUS == "RG   ADDED",
    trimws(paste0(
      text2$ISSUER_DESCRIPTION, substr(text2$STATUS, 1, 5)
    ), "both"),
    text2$ISSUER_DESCRIPTION
  )
  text2$STATUS = ifelse(text2$STATUS == "RG   ADDED",
                        substr(text2$STATUS, 6, 10),
                        text2$STATUS)

  text2 <- subset(text2, !grepl("CUSIP", text2$CUSIP))

  text2$YEAR <- YEAR_
  text2$QUARTER <- QUARTER_
  text2 <- text2[-c(1:11)]

  return(text2)
}
