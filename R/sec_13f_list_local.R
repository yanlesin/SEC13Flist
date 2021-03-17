#' @title Official List of Section 13(f) Securities from local file
#'
#' @description This function parses file with official list of Section 13(f) securities downloaded from SEC website <https://www.sec.gov/divisions/investment/13flists.htm>, and returns a data frame. Year and quarter of the list determined based on name of the file.
#' @param path_to_13f_file character string, path to local file
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
#' SEC_13F_list_2018_Q3 <- SEC_13F_list_local("/Users/user_name/Downloads/13flist2020q4.pdf")
#' #Parse list from "Downloads" folder
#' }
#' @useDynLib SEC13Flist, .registration = TRUE
#' @importFrom Rcpp sourceCpp
#' @importFrom rlang ':='

SEC_13F_list_local <- function(path_to_13f_file){

  if(!file.exists(path_to_13f_file)) stop("Error: supplied path to SEC 13F files is invalid")

  YEAR_ <- stringr::str_sub(path_to_13f_file,stringr::str_length(path_to_13f_file)-9,stringr::str_length(path_to_13f_file)-6) %>%
    as.integer()

  QUARTER_ <- stringr::str_sub(path_to_13f_file,stringr::str_length(path_to_13f_file)-4,stringr::str_length(path_to_13f_file)-4) %>%
    as.integer()

  text <- pdftools::pdf_text(path_to_13f_file)

  return(process_file_func(text, YEAR_, QUARTER_))

}
