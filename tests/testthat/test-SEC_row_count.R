test_that("Parsed row count equal to total row count per PDF list", {
  options(HTTPUserAgent="Yan Lyesin, SEC13Flist Package for R, yan.lyesin@gmail.com ")
  url_SEC <- "https://www.sec.gov/divisions/investment/13flists.htm"

  html_page <- readLines(url_SEC)
  html_line <- html_page[grep("Current List", html_page)]
  url <- sub("<a href=\"(.*)\">.*", "\\1", html_line)
  current_list_url <- sub("^.*https", "https", url)

  current_year <- substr(current_list_url,nchar(current_list_url)-9,nchar(current_list_url)-6) |>
    as.integer()

  current_quarter <- substr(current_list_url,nchar(current_list_url)-4,nchar(current_list_url)-4) |>
    as.integer()

  #if (missing(YEAR_)&current_year==0|missing(QUARTER_)&current_quarter==0) stop("Error: Unable to determine current year or quarter. Please supply YEAR and QUARTER in function call and report this error")


  YEAR_ <- current_year
#  warning("Default year: ", YEAR_)

  QUARTER_ <- current_quarter
#  warning("Default quarter: ", QUARTER_)

  #0,0 supplied in function call
  if (YEAR_==0|QUARTER_==0) stop("Error: Please supply integer values for YEAR_ and QUARTER_ starting in 2004 Q1. Example: SEC_13F_list(2004, 1)")

  #Validating inputs to the function
  YEAR_ <- as.integer(YEAR_)
  QUARTER_ <- as.integer(QUARTER_)

  if (is.na(YEAR_)|is.na(QUARTER_)) stop("Error: Please supply integer values for YEAR_ and QUARTER_ starting in 2004 Q1. Example: SEC_13F_list(2004, 1)")

  if (YEAR_<2004) stop("Error: SEC_13F_list function only works with SEC list files starting at Q1 2004. Example: SEC_13F_list(2004, 1)")
  if (QUARTER_>4) stop("Error: Please, supply integer number for QUARTER_ in range between 1 and 4")

  if(current_year!=0) (if (YEAR_>current_year) stop (paste0("Error: no list available for year ",
                                                            YEAR_, ". Please, use integer number in range 2004..", current_year))
  )

  if(current_quarter!=0) (if (YEAR_==current_year&QUARTER_>current_quarter) stop (paste0("Error: no list available for year ",
                                                                                         YEAR_, " and quarter ", QUARTER_, ". Last available quarter for current year - ", current_quarter, "."))
  )

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
  text <- pdftools::pdf_text(url_file)
  page_total_count <- min(which(!(regexpr("Total Count:", text)) == -1))
  total_count <- as.integer(gsub("[^0-9.-]", "", substr(text[page_total_count],
                                                        regexpr("Total Count: ", text[page_total_count])[1]+1, nchar(text[page_total_count]))))

  total_count_parse <- nrow(SEC13Flist::SEC_13F_list())

  expect_equal(total_count, total_count_parse)
})
