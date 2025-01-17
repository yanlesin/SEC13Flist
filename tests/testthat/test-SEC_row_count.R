test_that("Parsed row count equal to total row count per PDF list", {
  options(HTTPUserAgent="Yan Lyesin, SEC13Flist Package for R, yan.lyesin@gmail.com ")
  YEAR_ <- 2024
  QUARTER_ <- 4

    file_name <- paste0('13flist', YEAR_, 'q', QUARTER_, '.pdf')
    url_file <-
      paste0("https://www.sec.gov/files/investment/",
             file_name)
  text <- pdftools::pdf_text(url_file)
  page_total_count <- min(which(!(regexpr("Total Count:", text)) == -1))
  total_count <- as.integer(gsub("[^0-9.-]", "", substr(text[page_total_count],
                                                        regexpr("Total Count: ", text[page_total_count])[1]+1, nchar(text[page_total_count]))))

  total_count_parse <- nrow(SEC13Flist::SEC_13F_list(YEAR_, QUARTER_))

  expect_equal(total_count, total_count_parse)
})
