test_that("list of possible values for STATUS column", {
  STATUS_1 <- ""
  STATUS_2 <- "ADDED"
  STATUS_3 <- "DELETED"
  list_all <- SEC13Flist::SEC_13F_list()
  list_all <- unique(list_all["STATUS"])
  list_STATUS <- nrow(subset(list_all, !STATUS %in% c(STATUS_1,STATUS_2,STATUS_3)))
  expect_equal(list_STATUS, 0)
})
