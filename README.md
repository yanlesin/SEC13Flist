
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

## Description of returned data

CUSIP: chr - CUSIP number of the security  
HAS\_LISTED\_OPTION: chr - An asterisk idicates that security having a
listed option and each option is individually listed with its own CUSIP
number immediately below the name of the security having the option  
ISSUER\_NAME: chr - Issuer Name  
ISSUER\_DESCRIPTION: chr - Issuer Description  
STATUS: chr - “ADDED” (The security has become a Section 13(f) security)
or “DELETED” (The security ceases to be a 13(f) security since the date
of the last list) YEAR: int - Year of the list  
QUARTER: int - Quarter of the list

## Example

These are basic examples of usage:

``` r
## Return list for Q3 2018
SEC13Flist_2018_Q3 <- SEC_13F_list(2018,3)

## Current list form SEC website
SEC13Flist_current <- SEC_13F_list() #Current list form SEC website

## Customizing
SEC13Flist_current <- SEC_13F_list() %>% 
  filter(STATUS!="DELETED") %>% #Filter out records with STATUS "DELETED"
  select(-YEAR,-QUARTER) #Remove YEAR and QUARTER columns
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
