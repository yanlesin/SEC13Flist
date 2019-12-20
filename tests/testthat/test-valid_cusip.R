test_that("Valid CUSIP", {
  expect_equal(SEC13Flist::isCusip("B38564108"), TRUE)
  expect_equal(SEC13Flist::isCusip("B38564109"), FALSE)
})
