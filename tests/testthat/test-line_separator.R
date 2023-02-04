test_that("line separator", {
  test_text_1 <- "This is a test1.\r"
  CR <- ifelse(regexpr("\r", test_text_1)[1] == -1, NA, regexpr("\r", test_text_1)[1])
  LF <- ifelse(regexpr("\n", test_text_1)[1] == -1, NA, regexpr("\n", test_text_1)[1])
  expect_equal(SEC13Flist:::line_separator_func(CR,LF,text = test_text_1),"\r")
  test_text_2 <- "This is a test2.\r\n This is line 2"
  CR <- ifelse(regexpr("\r", test_text_2)[1] == -1, NA, regexpr("\r", test_text_2)[1])
  LF <- ifelse(regexpr("\n", test_text_2)[1] == -1, NA, regexpr("\n", test_text_2)[1])
  expect_equal(SEC13Flist:::line_separator_func(CR,LF,text = test_text_2),"\r\n")
  test_text_3 <- "This is a test3.\n This is line 2"
  CR <- ifelse(regexpr("\r", test_text_3)[1] == -1, NA, regexpr("\r", test_text_3)[1])
  LF <- ifelse(regexpr("\n", test_text_3)[1] == -1, NA, regexpr("\n", test_text_3)[1])
  expect_equal(SEC13Flist:::line_separator_func(CR,LF,text = test_text_3),"\n")
  test_text_4 <- "This is a test4"
  CR <- ifelse(regexpr("\r", test_text_4)[1] == -1, NA, regexpr("\r", test_text_4)[1])
  LF <- ifelse(regexpr("\n", test_text_4)[1] == -1, NA, regexpr("\n", test_text_4)[1])
  expect_error(SEC13Flist:::line_separator_func(CR,LF,text = test_text_4))
})
