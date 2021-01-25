test_that("Full CUSIP", {
  expect_equal(SEC13Flist::fullCusip("B3856410"), "B38564108")
  expect_equal(SEC13Flist::fullCusip("B38564109"), "0")
  expect_equal(SEC13Flist::fullCusip("123456#1"), "123456#13")
  expect_equal(SEC13Flist::fullCusip("123456#14"), "0")
  expect_equal(SEC13Flist::fullCusip("123456*1"), "123456*15")
  expect_equal(SEC13Flist::fullCusip("123456*16"), "0")
  expect_equal(SEC13Flist::fullCusip("123456(1"), "0")
})
