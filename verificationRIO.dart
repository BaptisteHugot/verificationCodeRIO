/**
 * @file verificationRIO.dart
 * @brief Vérifie que le code RIO utilisé pour la portabilité des numéros en France correspond bien à un numéro de téléphone donné
 */

/**
 * Vérifie que le code RIO correspond bien au numéro de téléphone
 * @param numeroTelephone Numéro de téléphone
 * @param codeRIO Code RIO
 * @return vrai si le code RIO correspond au numéro de téléphone, faux sinon
 */
bool verificationCleControle(String numeroTelephone, String codeRIO) {
  String concatenation = codeRIO.substring(0, 9) + numeroTelephone;
  String ordre = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789+";
  int a = 0, b = 0, c = 0;

  for (int i = 0; i < concatenation.length; i++) {
    String caractere = concatenation[i];
    int position = ordre.indexOf(caractere);
    a = (1 * a + position) % 37;
    b = (2 * b + position) % 37;
    c = (4 * c + position) % 37;
  }
  String cleControle = ordre[a] + ordre[b] + ordre[c];
  if (cleControle == codeRIO.substring(9, 12)) {
    return true;
  } else
    return false;
}

/**
 * Vérifie que le numéro de téléphone est dans le bon format
 * @param numeroTelephone Numéro de téléphone
 * @return vrai si le numéro de téléphone est dans le bon format, faux sinon
 */
bool verificationFormatNumeroTelephone(String numeroTelephone) {
  RegExp exp = new RegExp("^0[1-79][0-9]{8}");
  return exp.hasMatch(numeroTelephone);
}

/**
 * Vérifie si le code RIO est dans le bon format
 * @param codeRIO Code RIO
 * @param typeNumeroTelephone Le type de numéro de téléphone (fixe ou mobile)
 * @return vrai si le code RIO est dans le bon format, faux sinon
 */
bool verificationFormatCodeRIORIO(String codeRIO, String typeNumeroTelephone) {
  if (typeNumeroTelephone == "mobile") {
    RegExp exp = new RegExp("[0-9A-E]{1}{[0-9A-Z]}[E|P][A-Z0-9]{6}[A-Z0-9\+]");
    return exp.hasMatch(codeRIO);
  } else if (typeNumeroTelephone == "fixe") {
    RegExp exp = new RegExp("[F-Z][A-Z0-9]{8}[A-Z0-9\+]{3}");
    return exp.hasMatch(codeRIO);
  }
}

/**
 * Donne le type de numéro de téléphone
 * @param numeroTelephone Numéro de téléphone
 * @return le type de numéro de téléphone (fixe ou mobile)
 */
String typeNumeroTelephone(String numeroTelephone) {
  if (numeroTelephone.substring(0, 1) == "06" ||
      numeroTelephone.substring(0, 1) == "07") {
    return "mobile";
  } else
    return "fixe";
}