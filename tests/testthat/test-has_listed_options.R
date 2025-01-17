test_that("list of possible values for HAS_LISTED_OPTION column", {
  options(HTTPUserAgent="Yan Lyesin, SEC13Flist Package for R, yan.lyesin@gmail.com ")
  list_all <- SEC13Flist::SEC_13F_list(2024, 4)
  list_all <- unique(list_all["HAS_LISTED_OPTION"])
  list_HAS_LISTED_OPTION <- nrow(subset(list_all, !HAS_LISTED_OPTION %in% c("","*")))
  expect_equal(list_HAS_LISTED_OPTION, 0)
})
