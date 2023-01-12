#' @title Check validity of SEDOL identifier
#'
#' @description This function check validity of SEDOL code by comparing calculated checksum digit based on first 6 characters of SEDOL code with 7th character of SEDOL code - checksum digit
#' @param s seven-character string with SEDOL code to validate
#' @keywords SEDOL checksum digit
#' @return Logical value indicating validity of SEDOL number: \code{TRUE} if SEDOL number is valid, \code{FALSE} if SEDOL number is invalid
#' @export
#' @examples
#' library(SEC13Flist)
#' isSedol("2046252") #invalid SEDOL example
#' isSedol("2046251") #valid SEDOL example
#' @useDynLib SEC13Flist, .registration = TRUE
#' @importFrom Rcpp sourceCpp
#' @importFrom rlang ':='

isSedol <- function(s){
  if (nchar(s) != 7) return(FALSE)

  if (!grepl("^[[:digit:][:upper:]]{6}$", substr(s, 1, 6))) return(FALSE)

  ascii <- as.integer(charToRaw(substr(s, 1, 6)))
  scores <- ifelse(ascii < 65, ascii - 48, ascii - 55)
  weights <- c(1, 3, 1, 7, 3, 9)
  chkdig <- (10 - sum(scores * weights) %% 10) %% 10

  return(chkdig == substr(s, 7, 7))
}
