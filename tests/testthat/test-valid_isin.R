test_that("Valid ISIN", {
  expect_equal(SEC13Flist::isIsin("US0378331005"), TRUE)
  expect_equal(SEC13Flist::isIsin("US0373831005"), FALSE)
  expect_equal(SEC13Flist::isIsin("FR0000988040"), TRUE)
})
