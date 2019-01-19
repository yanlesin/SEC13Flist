library(pdftools)
library(stringr)
library(dplyr)
library(purrr)
library(tidyr)
library(naniar)
library(rvest)

#' @title Official List of Section 13(f) Securities
#'
#' @description This function downloads, specified by Year and Quarter, Official List of Section 13(f) Securities from SEC website, parses it and returns dataframe. If no parameters provided, function determines year and quarter based on Current List section of SEC website
#' @param YEAR_ Year for the SEC List
#' @param QUARTER_ Quarter for the SEC List
#' @keywords SEC 13F List
#' @export
#' @examples
#' SEC_13F_list_2018_Q3 <- SEC_13F_list(2018,3) #Download list for Q3 2018
#' SEC_13F_list_current <- SEC_13F_list() #Current list from SEC.gov will be processed

SEC_13F_list <- function(YEAR_,QUARTER_){

  str_split_wrap <- function(text){
    str_split(text,line_separator, simplify = FALSE)
  }

  url_SEC <- "https://www.sec.gov/divisions/investment/13flists.htm"

  current_list_url <- xml_attrs(
    html_nodes(
      read_html(url_SEC),'#block-secgov-content :nth-child(1)'
    )[[23]]
  )

  if (missing(YEAR_)) {
    YEAR_ <- str_sub(current_list_url,str_length(current_list_url)-9,str_length(current_list_url)-6) %>%
      as.integer()
    warning("Defaul year: ",YEAR_)
  }

  if (missing(QUARTER_)) {
    QUARTER_ <- str_sub(current_list_url,str_length(current_list_url)-4,str_length(current_list_url)-4) %>%
      as.integer()
    warning("Defaul quarter: ",QUARTER_)
  }

  file_name <- paste0('13flist',YEAR_, 'q', QUARTER_,'.pdf')
  download.file(paste0("https://www.sec.gov/divisions/investment/13f/",file_name),file_name,mode='wb')
  #file <- file_name
  text <- pdf_text(file_name)
  pages <- length(text)

  CR <- str_locate(text[1],"\r")[1]
  LF <- str_locate(text[1],"\n")[1]

  if (!is.na(CR)) {
    if (str_sub(text[1], CR + 1, CR + 1) == "\n") {
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



  text2 <- map(text,str_split_wrap)
  text2 <- text2[3:pages] %>%
    unlist()
  text2 <- as.data.frame(text2,stringsAsFactors=FALSE) %>%
    rename(PDF_STRING=text2)

  text2 <- text2 %>%
    mutate(CUSIP_start=regexpr("CUSIP", text2$PDF_STRING)) %>%
    mutate(ISSUER_NAME_start=regexpr("ISSUER NAME", text2$PDF_STRING)) %>%
    mutate(ISSUER_DESCRIPTION_start=regexpr("ISSUER DESCRIPTION", text2$PDF_STRING)) %>%
    mutate(STATUS_start=regexpr("STATUS", text2$PDF_STRING)) %>%
    replace_with_na_all(condition=~.x==-1) %>%
    filter(!str_detect(PDF_STRING, "Run Date")) %>%
    filter(!str_detect(PDF_STRING, "Run Time")) %>%
    filter(!str_detect(PDF_STRING, "Total C")) %>%
    filter(str_detect(PDF_STRING, "")) %>%
    fill(CUSIP_start, ISSUER_NAME_start, ISSUER_DESCRIPTION_start, STATUS_start, .direction = "down") %>%
    mutate(CUSIP_end=CUSIP_start+11-1) %>%
    mutate(MAIN_ISSUE_start=CUSIP_end+1) %>%
    mutate(MAIN_ISSUE_end=ISSUER_NAME_start-1) %>%
    mutate(ISSUER_NAME_end=ISSUER_DESCRIPTION_start-1) %>%
    mutate(ISSUER_DESCRIPTION_end=STATUS_start-1) %>%
    mutate(STATUS_end=str_length(PDF_STRING)) %>%
    mutate(STATUS_end=max(STATUS_end))



  List_13F <- text2 %>%
    mutate(CUSIP=substring(PDF_STRING,CUSIP_start,CUSIP_end)) %>%
    mutate(MAIN_ISSUE=str_trim(substring(PDF_STRING,MAIN_ISSUE_start,MAIN_ISSUE_end),side="both")) %>%
    mutate(ISSUER_NAME=str_trim(substring(PDF_STRING,ISSUER_NAME_start,ISSUER_NAME_end),side="both")) %>%
    mutate(ISSUER_DESCRIPTION=str_trim(substring(PDF_STRING,ISSUER_DESCRIPTION_start,ISSUER_DESCRIPTION_end),side="both")) %>%
    mutate(STATUS=str_trim(substr(PDF_STRING,STATUS_start,STATUS_end),side="both")) %>%
    mutate(CUSIP=str_replace_all(CUSIP," ", "")) %>%
    filter(!str_detect(CUSIP, "CUSIP")) %>%
    select(-1:-11) %>%
    mutate(YEAR=YEAR_, QUARTER=QUARTER_)
  return(List_13F)
}
