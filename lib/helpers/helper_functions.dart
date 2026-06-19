/*
These are some helpful functions used across the app
*/

//function for convert string to double
double convertStringToDouble(String amountString) {
  return double.tryParse(amountString) ?? 0.0;
}