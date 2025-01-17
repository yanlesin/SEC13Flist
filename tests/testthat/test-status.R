test_that("list of possible values for STATUS column", {
  options(HTTPUserAgent="Yan Lyesin, SEC13Flist Package for R, yan.lyesin@gmail.com ")
  STATUS_1 <- ""
  STATUS_2 <- "ADDED"
  STATUS_3 <- "DELETED"
  list_all <- SEC13Flist::SEC_13F_list(2024, 4)
  list_all <- unique(list_all["STATUS"])
  list_STATUS <- nrow(subset(list_all, !STATUS %in% c(STATUS_1,STATUS_2,STATUS_3)))
  expect_equal(list_STATUS, 0)
})
