# Generated by using Rcpp::compileAttributes() -> do not edit by hand
# Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

#' @title Return valid 9-character CUSIP identifier (with checksum digit) from 8-character CUSIP identifier (without checksum digit)
#'
#' @description This function returns full CUSIP code by adding calculated checksum digit to 8-character CUSIP identifier. If supplied CUSIP identifier is not 8 characters, function returns "0"
#' @param s eight-character string with CUSIP identifier
#' @keywords CUSIP checksum digit
#' @return String value with full 9-character CUSIP identifier, or "0" if supplied input is not 8-character CUSIP string
#' @examples
#' library(SEC13Flist)
#' fullCusip("B38564109") #returns zero - supplied code is not 8-character CUSIP identifier
#' fullCusip("B3856410") #valid CUSIP returned example
#' @export
fullCusip <- function(s) {
    .Call(`_SEC13Flist_fullCusip`, s)
}

#' @title Check validity of CUSIP identifier
#'
#' @description This function check validity of CUSIP code by comparing calculated checksum digit based on first 8 characters of CUSIP code with 9th character of CUSIP code - checksum digit
#' @param s nine-character string with CUSIP code to validate
#' @keywords CUSIP checksum digit
#' @return Logical value indicating validity of CUSIP number: \code{TRUE} if CUSIP number is valid, \code{FALSE} if CUSIP number is invalid
#' @examples
#' library(SEC13Flist)
#' isCusip("B38564109") #invalid CUSIP example
#' isCusip("B38564108") #valid CUSIP example
#' @export
isCusip <- function(s) {
    .Call(`_SEC13Flist_isCusip`, s)
}

#' @title Check validity of ISIN identifier
#'
#' @description This function check validity of ISIN code by comparing calculated checksum digit based on first 11 characters of CUSIP code with 12th character of CUSIP code - checksum digit
#' @param isin twelve-character string with ISIN code to validate
#' @keywords ISIN checksum digit
#' @return Logical value indicating validity of ISIN number: \code{TRUE} if ISIN number is valid, \code{FALSE} if ISIN number is invalid
#' @examples
#' library(SEC13Flist)
#' isIsin("US0378331009") #invalid ISIN example
#' isIsin("US0378331005") #valid ISIN example
#' @export
isIsin <- function(isin) {
    .Call(`_SEC13Flist_isIsin`, isin)
}

