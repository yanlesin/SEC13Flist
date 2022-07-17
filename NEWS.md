# SEC13Flist 

## 0.3.4.3

* Fixed issue with 2022 Q2 list related to incorrect parsing for one security 

## 0.3.4.2

* Fixed rollover bug in url_file_func() to work properly in Q1 2022

## 0.3.4.1

* removed imports of xml2 and purrr
* rstudio cloud build

## 0.3.4

* fixed change on SEC.GOV landing page for list
* adjusted tests to pass changed landing page

## 0.3.3

* changes to accommodate rvest 1.0.0
* added `usethis::use_github_action("check-standard")`
* removed Travis CI

## 0.3.2

* improve test coverage for `SEC_13F_list_local`
* added github actions for test coverage

## 0.3.1

* added `SEC_13F_list_local` function that processes local file
* added `fullCUSIP` function that appends checksum digit to 8-character CUSIP

* internal changes: main processing of the file moved to function in `utils.R`

## 0.2.5

* Added a `NEWS.md` file to track changes to the package.
