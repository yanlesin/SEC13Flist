
<!-- README.md is generated from README.Rmd. Please edit that file -->

# SEC13Flist

The goal of SEC13Flist is to provide routine to work with official list
of Section 13F Securities.

Function SEC\_13F\_list downloads PDF list from
[SEC.gov](https://www.sec.gov/divisions/investment/13flists.htm) based
on supplied year and quarter and returns data frame with list of
securities from PDF file, mainitaining the same structure as official
list. Function appends YEAR and QUARTER columns to each record. Returned
dataframe/tibble could be customized and filtered according to your
needs.

## Installation

You can install current development version from
[GitHub](https://github.com/yanlesin/SEC13Flist) with:

``` r
devtools::install_github("yanlesin/SEC13Flist")
```

## Example

These are basic examples of usage:

``` r
## Return list for Q3 2018
SEC13Flist_2018_Q3 <- SEC_13F_list(2018,3)

## Current list form SEC website
SEC13Flist_current <- SEC_13F_list() #Current list form SEC website

## Customizing
SEC13Flist_current <- SEC_13F_list() %>% 
  filter(STATUS!="DELETED") %>% #Filter records with STATUS "DELETED"
  select(-YEAR,-QUARTER) #Remove YEAR and QUARTER columns
```
