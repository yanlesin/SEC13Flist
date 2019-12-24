test_that("Valid CUSIP", {
  expect_equal(SEC13Flist::isCusip("B38564108"), TRUE)
  expect_equal(SEC13Flist::isCusip("B38564109"), FALSE)
  expect_equal(SEC13Flist::isCusip("123456#13"), TRUE)
  expect_equal(SEC13Flist::isCusip("123456#14"), FALSE)
  expect_equal(SEC13Flist::isCusip("123456*15"), TRUE)
  expect_equal(SEC13Flist::isCusip("123456*16"), FALSE)
  expect_equal(SEC13Flist::isCusip("123456(16"), FALSE)
})
