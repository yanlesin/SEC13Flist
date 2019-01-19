library(rvest)
library(stringr)
url_SEC <- "https://www.sec.gov/divisions/investment/13flists.htm"

current_list_url <- xml_attrs(
  html_nodes(
    read_html(url_SEC),'#block-secgov-content :nth-child(1)'
    )[[23]]
  )

QUARTER_ <- str_sub(current_list_url,str_length(current_list_url)-4,str_length(current_list_url)-4) %>%
  as.integer()
YEAR_ <- str_sub(current_list_url,str_length(current_list_url)-9,str_length(current_list_url)-6) %>%
  as.integer()
