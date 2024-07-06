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
#' \dontrun{library(SEC13Flist)
#' SEC_13F_list_2018_Q3 <- SEC_13F_list(2018,3) #Parse list for Q3 2018 without progress indicator
#' SEC_13F_list_2018_Q3_ <- SEC_13F_list(2018,3,TRUE) #Parse list with progress indicator
#' SEC_13F_list_current <- SEC_13F_list() #Parse current list from SEC.gov
#' }
#' @useDynLib SEC13Flist, .registration = TRUE
#' @importFrom Rcpp sourceCpp

SEC_13F_list <- function(YEAR_,QUARTER_, show_progress = FALSE){

  url_SEC <- "https://www.sec.gov/divisions/investment/13flists.htm"

  html_page <- readLines(url_SEC)
  html_line <- html_page[grep("Current List", html_page)]
  url <- sub("<a href=\"(.*)\">.*", "\\1", html_line)
  current_list_url <- sub("^.*https", "https", url)

  current_year <- substr(current_list_url,nchar(current_list_url)-9,nchar(current_list_url)-6) |>
    as.integer()

  current_quarter <- substr(current_list_url,nchar(current_list_url)-4,nchar(current_list_url)-4) |>
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

  return(process_file_func(text, YEAR_, QUARTER_))

}
