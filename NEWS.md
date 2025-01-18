# SEC13Flist 

## 1.1.1

* tested 2024-Q4 file

## 1.1.0

* significant change: `SEC_13F_list` function no longer attempts to determine current year and quarter for the official list - it will produce an error when no year and quarter supplied to the function call

## 1.0.1

* fixed issue related to change in landing page of sec.gov for Official List of securities
* removed dependency on `rvest`

## 1.0.0

* significant change: `SEC_13F_list` function requires user agent setup for reading data from sec.gov website. See [https://www.sec.gov/os/accessing-edgar-data](https://www.sec.gov/os/accessing-edgar-data)
* fixed issue with 2023 Q4 list parsing
* modified tests to include user agent information for sec.gov access

## 0.3.6

* fixed issue with isCusip function incorrectly returned FALSE for certain CUSIPs (issue #75)
* fixes parsing for ISSUER_DESCRIPTION field where letter from STATUS left in it

## 0.3.5.6

* fixed issue with 2023 Q3 list parsing

## 0.3.5.5

* added `isSedol` function to check validity of SEDOL
* added `isIsin` function to check validity of ISIN

## 0.3.5.4

* removed dependency on `dplyr` and `rlang`

## 0.3.5.3

* removed dependency on `readr`

## 0.3.5.2

* removed dependencies on `magrittr`, `stringr` packages by using native R pipe operator. Now requires R > 4.1.0
* replaced `dplyr::na_if` call with base r functionality to handle changes in dplyr 1.1.0

## 0.3.5.0

* fixed error with `str_detect` empty string matching 
* fixed status "D" for single `ISSUE_DESCRIPTION` outside of bounds for column

## 0.3.4.3

* Fixed issue with 2022 Q2 list related to incorrect parsing for one security 

## 0.3.4.2

* Fixed rollover bug in url_file_func() to work properly in Q1 2022

## 0.3.4.1

* Removed imports of xml2 and purrr
* RStudio cloud build

## 0.3.4

* Fixed change on SEC.GOV landing page for list
* Adjusted tests to pass changed landing page

## 0.3.3

* Changes to accommodate rvest 1.0.0
* Added `usethis::use_github_action("check-standard")`
* Removed Travis CI

## 0.3.2

* Improve test coverage for `SEC_13F_list_local`
* Added github actions for test coverage

## 0.3.1

* Added `SEC_13F_list_local` function that processes local file
* Added `fullCUSIP` function that appends checksum digit to 8-character CUSIP

* Internal changes: main processing of the file moved to function in `utils.R`

## 0.2.5

* Added a `NEWS.md` file to track changes to the package.
