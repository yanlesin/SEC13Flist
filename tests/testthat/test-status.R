test_that("list of possible values for STATUS column", {
  STATUS_1 <- ""
  STATUS_2 <- "ADDED"
  STATUS_3 <- "DELETED"
  list_STATUS <- dplyr::count(dplyr::filter(dplyr::distinct(dplyr::select(SEC13Flist::SEC_13F_list(), STATUS)),!STATUS %in% c(STATUS_1,STATUS_2,STATUS_3)))$n
  expect_equal(list_STATUS, 0)
})
