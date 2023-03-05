
<!-- README.md is generated from README.Rmd. Please edit that file -->
<!-- badges: start -->

[![R build
status](https://github.com/yanlesin/SEC13Flist/workflows/R-CMD-check/badge.svg)](https://github.com/yanlesin/SEC13Flist/actions)
[![codecov](https://codecov.io/github/yanlesin/SEC13Flist/branch/master/graphs/badge.svg)](https://codecov.io/gh/yanlesin/SEC13Flist/branch/master)
<!-- badges: end -->

# SEC13Flist

The goal of SEC13Flist package is to provide routines to work with
official list of Section 13(f) Securities.

Functions `SEC_13F_list` and `SEC_13F_list_local` parses PDF list from
[SEC.gov](https://www.sec.gov/divisions/investment/13flists.htm) based
on supplied year and quarter and returns data frame with list of
securities, maintaining the same structure as official list. Functions
appends YEAR and QUARTER columns to the list. Returned dataframe could
be customized and filtered according to your needs.

`SEC_13F_list` function reaches to
[SEC.gov](https://www.sec.gov/divisions/investment/13flists.htm) website
and requires tweaks if landing page changes. In case of a breaking
change on landing page, you can use `SEC_13F_list_local` function to
parse file downloaded to local folder manually.

Functions `isCusip`, `isSedol`, and `isIsin` verify checksum digit of
security identifiers based on leading characters of the identifier
(except last checksum digit). Functions returns `TRUE`/`FALSE` for
correct/incorrect identifier.

CUSIP, ISIN, and SEDOL checksum calculation pseudo code located at
[Wikipedia - CUSIP](https://en.wikipedia.org/wiki/CUSIP), [Wikipedia -
SEDOL](https://en.wikipedia.org/wiki/SEDOL), [Wikipedia -
ISIN](https://en.wikipedia.org/wiki/International_Securities_Identification_Number)
and R/C/C++ implementation is at [Rosettacode -
CUSIP](https://rosettacode.org/wiki/CUSIP#C.2B.2B), [Rosettacode -
SEDOL](https://rosettacode.org/wiki/SEDOLs#R), and [Rosettacode -
ISIN](https://rosettacode.org/wiki/Validate_International_Securities_Identification_Number#C)

## Installation

You can install current development version from
[GitHub](https://github.com/yanlesin/SEC13Flist) with:

``` r
remotes::install_github("yanlesin/SEC13Flist")
```

## Description of returned data for `SEC_13F_list`

`CUSIP`: chr - CUSIP number of the security  
`HAS_LISTED_OPTION`: chr - An asterisk idicates that security having a
listed option and each option is individually listed with its own CUSIP
number immediately below the name of the security having the option  
`ISSUER_NAME`: chr - Issuer Name  
`ISSUER_DESCRIPTION`: chr - Issuer Description  
`STATUS`: chr - “ADDED” (The security has become a Section 13(f)
security) or “DELETED” (The security ceases to be a 13(f) security since
the date of the last list)  
`YEAR`: int - Year of the list  
`QUARTER`: int - Quarter of the list

## Examples

These are basic examples of usage:

``` r
library(SEC13Flist)
library(tidyverse)

## Return list for Q3 2018
SEC13Flist_2018_Q3 <- SEC_13F_list(2018,3)

## Current list form SEC website
SEC13Flist_current <- SEC_13F_list() #Current list form SEC website

## Customizing
SEC13Flist_current <- SEC_13F_list() |> 
  filter(STATUS!="DELETED") |>  #Filter out records with STATUS "DELETED"
  select(-YEAR,-QUARTER) #Remove YEAR and QUARTER columns

## Verifying CUSIP
verify_CUSIP <- SEC_13F_list() |> 
  rowwise() |>  ##CUSIPs are not unique, isCusip function is not vectorized and requires single nine character CUSIP as input
  mutate(VALID_CUSIP=isCusip(CUSIP)) ##validating CUSIP
```

## Use of CUSIP Codes

According to FAQ section of [CUSIP Global
Services](https://www.cusip.com/cusip/cgs-license-fees.htm):

> Can firms take CGS Data from public sources and create their own
> database without signing a license agreement with CGS?

> CGS Data is publicly available in some offering documents and from
> other sources. Firms can elect to collect this information and store
> it in their internal databases for non-commercial use, provided that
> the source of such information permitted the reproduction and use of
> such information. However, CGS’s experience has been that the CGS data
> generally has not come from publicly available sources but rather from
> other sources such as a CGS Authorized Distributor or through
> improperly scraping websites of CGS customers with valid CGS’
> licenses. Most end-user customers of CGS Data prefer to enter into a
> license agreement with CGS for authorized use and to enjoy the
> benefits of the integrity and functionality of downloadable, timely
> and accurate data (either from CGS directly or from an Authorized
> Distributor).

## Known issues with CUSIP codes supplied in SEC’s Official List of 13(f) securities

[This discussion at
stackexchange](https://quant.stackexchange.com/questions/16392/sec-13f-security-list-has-incorrect-cusip-numbers)
describes problem with CUSIP codes for CALL and PUT options that is
still present at current list (Q3 2019 at the moment of updating this).

[This discussion at FundApps support
article](https://fundapps.zendesk.com/hc/en-us/articles/204837769-13F-list-Option-CUSIP-matching)
describes how FundApps (software provider for regulatory compliance)
addresses quality issue for CUSIP codes including all option securities
with the same first six-character subset of CUSIP code as main issue (\*
for HAS_LISTED_OPTION field in the list).

Based on analysis of the most recent file (Q3 2019) I can confirm that:

- not only CALL and PUT options supplied with invalid CUSIP, but also
  some main issues as well

- some CUSIP codes are used more than once (up to eight securities with
  the same CUSIP in the list)
