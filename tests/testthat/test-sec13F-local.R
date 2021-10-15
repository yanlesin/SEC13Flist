test_that("Local processing yields same result as via web-site", {
  if (Sys.info()["sysname"] == "Windows") download.file("https://www.sec.gov/divisions/investment/13f/13flist2020q3.pdf",
                                                        mode = "wb",
                                                        destfile = "13flist2020q3.pdf") else download.file("https://www.sec.gov/divisions/investment/13f/13flist2020q3.pdf",
                                                                                                           destfile = "13flist2020q3.pdf")
aa <- SEC13Flist::SEC_13F_list_local("13flist2020q3.pdf")
bb <- SEC13Flist::SEC_13F_list(2020, 03)
expect_equal(aa,bb)

expect_error(SEC13Flist::SEC_13F_list_local("13flist2020q3.pdf1"))

})
