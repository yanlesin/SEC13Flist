#include <Rcpp.h>
using namespace Rcpp;

//' @title Check validity of CUSIP code
//'
//' @description This function check validity of CUSIP code by comparing calculated check digit based on first 8 characters of CUSIP code with 9th character of CUSIP code - control digit
//' @param s nine-character string with CUSIP code to validate
//' @keywords CUSIP Control Digit
//' @export
// [[Rcpp::export]]
bool isCusip(const std::string& s) {
  if (s.size() != 9) return false;

  int sum = 0;
  for (int i = 0; i <= 7; ++i) {
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
  return s[8] - '0' == (10 - (sum % 10)) % 10;
}


// You can include R code blocks in C++ files processed with sourceCpp
// (useful for testing and development). The R code will be automatically
// run after the compilation.
//

/*** R
isCusip("B38564109")
isCusip("B38564108")
*/
