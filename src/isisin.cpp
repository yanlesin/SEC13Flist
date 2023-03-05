#include <Rcpp.h>
using namespace Rcpp;

//' @title Check validity of ISIN identifier
//'
//' @description This function check validity of ISIN code by comparing calculated checksum digit based on first 11 characters of CUSIP code with 12th character of CUSIP code - checksum digit
//' @param isin twelve-character string with ISIN code to validate
//' @keywords ISIN checksum digit
//' @return Logical value indicating validity of ISIN number: \code{TRUE} if ISIN number is valid, \code{FALSE} if ISIN number is invalid
//' @examples
//' library(SEC13Flist)
//' isIsin("US0378331009") #invalid ISIN example
//' isIsin("US0378331005") #valid ISIN example
//' @export
// [[Rcpp::export]]
bool isIsin(const std::string& isin) {
  int i, j, k, v, s[24];

  j = 0;
  for(i = 0; i < 12; i++) {
    k = isin[i];
    if(k >= '0' && k <= '9') {
      if(i < 2) return false;
      s[j++] = k - '0';
    } else if(k >= 'A' && k <= 'Z') {
      if(i == 11) return false;
      k -= 'A' - 10;
      s[j++] = k / 10;
      s[j++] = k % 10;
    } else {
      return false;
    }
  }

  if(isin[i]) return false;

  v = 0;
  for(i = j - 2; i >= 0; i -= 2) {
    k = 2 * s[i];
    v += k > 9 ? k - 9 : k;
  }

  for(i = j - 1; i >= 0; i -= 2) {
    v += s[i];
  }

  return v % 10 == 0;
}

/*** R
isIsin("US0378331005")
isIsin("US0378331009")
*/
