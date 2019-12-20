test_that("list of possible values for HAS_LISTED_OPTION column", {
  list_HAS_LISTED_OPTION <- dplyr::count(dplyr::filter(dplyr::distinct(dplyr::select(SEC13Flist::SEC_13F_list(), HAS_LISTED_OPTION)),!HAS_LISTED_OPTION %in% c("","*")))$n
  expect_equal(list_HAS_LISTED_OPTION, 0)
})
