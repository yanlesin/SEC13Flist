
<!-- README.md is generated from README.Rmd. Please edit that file -->

# SEC13Flist

The goal of SEC13Flist is to return offcial list of Section 13F
Securities for use in other places.

Function SEC\_13F\_list downloads PDF list from
[SEC.gov](https://www.sec.gov/divisions/investment/13flists.htm) based
on supplied year and quarter and returns data frame with list of
securities from PDF file.

## Installation

You can install current development version from
[GitHub](https://github.com/yanlesin/SEC13Flist) with:

``` r
devtools::install_github("yanlesin/SEC13Flist")
```

## Example

This is example that returns SEC 13F Securities list for Q3 2018.

``` r
## basic example code
SEC13Flist_2018_Q3 <- SEC_13F_list(2018,3)
```
