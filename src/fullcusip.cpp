#include <Rcpp.h>
using namespace Rcpp;

//' @title Return valid 9-character CUSIP identifier (with checksum digit) from 8-character CUSIP identifier (without checksum digit)
//'
//' @description This function returns full CUSIP code by adding calculated checksum digit to 8-character CUSIP identifier. If supplied CUSIP identifier is not 8 characters, function returns "0"
//' @param s eight-character string with CUSIP identifier
//' @keywords CUSIP checksum digit
//' @return String value with full 9-character CUSIP identifier, or "0" if supplied input is not 8-character CUSIP string
//' @examples
//' library(SEC13Flist)
//' fullCusip("B38564109") #returns zero - supplied code is not 8-character CUSIP identifier
//' fullCusip("B3856410") #valid CUSIP returned example
//' @export
// [[Rcpp::export]]
std::string fullCusip(const std::string& s) {
  std::string result;
  if (s.size() != 8) return result='0';

  int sum = 0;
  for (int i = 0; i <= 7; ++i) {
    char c = s[i];

    int v;
    if ('0' <= c && c <= '9') {
      v = c - '0';
    } else if ('A' <= c && c <= 'Z') {
      v = c - 'A' + 10;
    } else if (c == '*') {
      v = 36;
    } else if (c == '#') {
      v = 38;
    } else {
      return result='0';
    }
    if (i % 2 == 1) {
      v *= 2;
    }
    sum += v / 10 + v % 10;
  }
  int checksum = (10 - (sum % 10)) % 10;
  return result = s + std::to_string(checksum);
}


// You can include R code blocks in C++ files processed with sourceCpp
// (useful for testing and development). The R code will be automatically
// run after the compilation.
//

/*** R
fullCusip("B3856410")
fullCusip("B38564109")
*/
