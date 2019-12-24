#' @title Line separator
#'
#' @description internal function that determines line separator for text
#' @param CR CR position (integer)
#' @param LF LF position (integer)
#' @param text character

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
