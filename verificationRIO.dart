import 'dart:html';

/**
 * Application which checks if the RIO code matched the phone number
 * @author Baptiste Hugot
 * @version 1.0.0 
 */

/**
* Checks if the RIO code matches the phone number
* @param phoneNumber Phone number
* @param RIOCode RIO Code
* @return true if the RIO code matches the phone number, false otherwise
*/
bool verificationKeyControl(String phoneNumber, String RIOCode) {
  String concatenation = RIOCode.substring(0, 9) + phoneNumber;
  String order = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789+";
  int a = 0, b = 0, c = 0;

  for (int i = 0; i < concatenation.length; i++) {
    String character = concatenation[i];
    int position = order.indexOf(character);
    a = (1 * a + position) % 37;
    b = (2 * b + position) % 37;
    c = (4 * c + position) % 37;
  }
  String controlKey = order[a] + order[b] + order[c];
  if (controlKey == RIOCode.substring(9, 12)) {
    return true;
  } else
    return false;
}

/**
* Checks if the phone number is in the correct pattern
* @param phoneNumber Phone number
* @return true if the phone number is in the correct pattern, false otherwise
*/
bool verificationPhoneNumber(String phoneNumber) {
  RegExp exp = new RegExp("^0[1-79][0-9]{8}");
  return exp.hasMatch(phoneNumber);
}

/**
* Checks if the RIO code is in the correct pattern
* @param RIOCode RIO code 
* @param typeOfPhoneNumber The type of the phone number (fix or mobile)
* @return true if the RIO code is in the correct pattern, false otherwise
*/
bool verificationRIOCode(String RIOCode, String typeOfPhoneNumber) {
  if (typeOfPhoneNumber == "mobile") {
    RegExp exp = new RegExp("[0-9]{2}[E|P][A-Z0-9]{6}[A-Z0-9\+]");
    return exp.hasMatch(RIOCode);
  } else if (typeOfPhoneNumber == "fix") {
    RegExp exp = new RegExp("[A-Z0-9]{9}[A-Z0-9\+]{3}");
    return exp.hasMatch(RIOCode);
  }
}

/**
* Gives the type of phone number
* @param phoneNumber Phone number
* @return The type of the phone number (fix or mobile)
*/
String typeOfPhoneNumber(String phoneNumber) {
  if (phoneNumber.substring(0, 1) == "06" ||
      phoneNumber.substring(0, 1) == "07") {
    return "mobile";
  } else
    return "fix";
}

/**
* Function executed when a click is made on the button "Verify"
* @param event Click on the button
*/
void actionVerification(MouseEvent event) {
  querySelector('#display').text = '';
  String phoneNumber = (querySelector('#phoneNumber') as InputElement).value;
  String typeOfNumber = typeOfPhoneNumber(phoneNumber);
  String RIOCode =
      (querySelector('#RIOCode') as InputElement).value.toUpperCase();

  if (!verificationPhoneNumber(phoneNumber)) {
    querySelector('#display').text =
        "The phone number is not in the good format.";
  } else if (!verificationRIOCode(RIOCode, typeOfNumber)) {
    querySelector('#display').text = "The RIO code is not in the good format.";
  } else if (!verificationKeyControl(phoneNumber, RIOCode)) {
    querySelector('#display').text =
        "The RIO code and the phone number do not match.";
  } else
    querySelector('#display').text = "The RIO code and the phone number match.";
}

/**
* Function executed when a click is made on the button "Erase"
* @param event Click on the button
*/
void actionDeletion(MouseEvent event) {
   querySelector('#display').text = '';
  (querySelector('#phoneNumber') as InputElement).value = '';
  (querySelector('#RIOCode') as InputElement).value = '';
}

/**
* Main function of the application
*/
void main() {
  querySelector('#verify').onClick.listen(actionVerification);
  querySelector('#erase').onClick.listen(actionDeletion);
}
