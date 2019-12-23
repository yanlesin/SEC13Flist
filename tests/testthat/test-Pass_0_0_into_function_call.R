test_that("0,0 and other into function call", {
  expect_error(SEC13Flist::SEC_13F_list(0,0))
  expect_error(SEC13Flist::SEC_13F_list(2003,1))
  expect_error(SEC13Flist::SEC_13F_list(2005,5))
  expect_error(SEC13Flist::SEC_13F_list(2004,0))
  expect_error(SEC13Flist::SEC_13F_list(0,1))
})
