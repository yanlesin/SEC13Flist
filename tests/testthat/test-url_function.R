test_that("testing url_file_func", {
  expect_equal(SEC13Flist:::url_file_func(YEAR_=2004, QUARTER_ = 1),"https://www.sec.gov/divisions/investment/13f-list.pdf")
  expect_equal(SEC13Flist:::url_file_func(YEAR_=2019, QUARTER_ = 3),"https://www.sec.gov/divisions/investment/13f/13flist2019q3.pdf")
  expect_equal(SEC13Flist:::url_file_func(YEAR_=2005, QUARTER_ = 4),"https://www.sec.gov/divisions/investment/13f/13flist2005q4.pdf")
  expect_error(SEC13Flist:::url_file_func(YEAR_=2019, QUARTER_ = 5))
  expect_error(SEC13Flist:::url_file_func(YEAR_=2003, QUARTER_ = 2))
  expect_error(SEC13Flist:::url_file_func(YEAR_=0, QUARTER_ = 2))
  expect_error(SEC13Flist:::url_file_func(YEAR_="2003a", QUARTER_ = 2))
  expect_error(SEC13Flist:::url_file_func(YEAR_=2006, QUARTER_ = "2a"))
  expect_error(SEC13Flist:::url_file_func(YEAR_="2003a", QUARTER_ = "2b"))
  expect_error(SEC13Flist:::url_file_func(YEAR_=2007, QUARTER_ = 0))

})
