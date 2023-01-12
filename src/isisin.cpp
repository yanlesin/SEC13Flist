#include <Rcpp.h>
using namespace Rcpp;

//' @title Check validity of ISIN code
//'
//' @description This function check validity of ISIN code by comparing calculated checksum digit based on first 11 characters of CUSIP code with 12th character of CUSIP code - checksum digit
//' @param s twelve-character string with ISIN code to validate
//' @keywords ISIN checksum digit
//' @return Logical value indicating validity of ISIN number: \code{TRUE} if ISIN number is valid, \code{FALSE} if ISIN number is invalid
//' @examples
//' library(SEC13Flist)
//' isIsin("US0378331009") #invalid ISIN example
//' isIsin("US0378331005") #valid ISIN example
//' @export
// [[Rcpp::export]]
bool isIsin(const std::string& s) {
  if (s.size() != 12) return false;

  int sum = 0;
  for (int i = 0; i <= 10; ++i) {
    char c = s[i];

    int v;
    if ('0' <= c && c <= '9') {
      v = c - '0';
    } else if ('A' <= c && c <= 'Z') {
      v = c - '@';
    } else if (c == '*') {
      v = 36;
    } else if (c == '#') {
      v = 38;
    } else {
      return false;
    }
    if (i % 2 == 1) {
      v *= 2;
    }
    sum += v / 10 + v % 10;
  }
  return s[11] - '0' == (10 - (sum % 10)) % 10;
}


// You can include R code blocks in C++ files processed with sourceCpp
// (useful for testing and development). The R code will be automatically
// run after the compilation.
//

/*** R
isIsin("US0378331005")
isIsin("US0378331009")
*/
