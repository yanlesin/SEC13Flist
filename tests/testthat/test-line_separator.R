test_that("line separator", {
  test_text_1 <- "This is a test1.\r"
  CR <- stringr::str_locate(test_text_1,"\r")[1]
  LF <- stringr::str_locate(test_text_1,"\n")[1]
  expect_equal(SEC13Flist:::line_separator_func(CR,LF,text = test_text_1),"\r")
  test_text_2 <- "This is a test2.\r\n This is line 2"
  CR <- stringr::str_locate(test_text_2,"\r")[1]
  LF <- stringr::str_locate(test_text_2,"\n")[1]
  expect_equal(SEC13Flist:::line_separator_func(CR,LF,text = test_text_2),"\r\n")
  test_text_3 <- "This is a test3.\n This is line 2"
  CR <- stringr::str_locate(test_text_3,"\r")[1]
  LF <- stringr::str_locate(test_text_3,"\n")[1]
  expect_equal(SEC13Flist:::line_separator_func(CR,LF,text = test_text_3),"\n")
  test_text_4 <- "This is a test4"
  CR <- stringr::str_locate(test_text_4,"\r")[1]
  LF <- stringr::str_locate(test_text_4,"\n")[1]
  expect_error(SEC13Flist:::line_separator_func(CR,LF,text = test_text_4))
})
