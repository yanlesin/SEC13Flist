test_that("Valid SEDOL", {
  expect_equal(SEC13Flist::isSedol("B38564108"), FALSE)
  expect_equal(SEC13Flist::isSedol("2046251"), TRUE)
  expect_equal(SEC13Flist::isSedol("2046252"), FALSE)
  expect_equal(SEC13Flist::isSedol("20462512"), FALSE)
  expect_equal(SEC13Flist::isSedol("a046251"), FALSE)
  expect_equal(SEC13Flist::isSedol("*046251"), FALSE)
  expect_equal(SEC13Flist::isSedol("204625"), FALSE)
})
