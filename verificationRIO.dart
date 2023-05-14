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
  if(!verificationFormatCodeRIOTelephone(codeRIO, typeNumeroTelephone(numeroTelephone))){
    return false;
  }else{
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
    } else return false;
  }
}

/**
 * Vérifie que le numéro de téléphone est dans le bon format
 * @param numeroTelephone Numéro de téléphone
 * @return vrai si le numéro de téléphone est dans le bon format, faux sinon
 */
bool verificationFormatNumeroTelephone(String numeroTelephone) {
  Pattern pattern = r"^(0[1-9][0-9]{8}|0[7][0][0][0-9]{9-10}|0[9][0][1][0-9]{9-10})";
  RegExp exp = new RegExp(pattern.toString());

  return exp.hasMatch(numeroTelephone);
}

/**
 * Vérifie que le code RIO est dans le bon format
 * @param codeRIO Code RIO
 * @return vrai si le code RIO est dans le bon format, faux sinon
 */
bool verificationFormatCodeRIO(String codeRIO){
  Pattern pattern = r"[0-9A-Z][A|E|F|G|M|N|P|R|S|T|U|V|W|X|Y|Z][A-Z0-9]{6}[A-Z0-9\+]{3}";
  RegExp exp = new RegExp(pattern.toString());

  return exp.hasMatch(codeRIO);
}

/**
 * Vérifie si le code RIO est dans le bon format
 * @param codeRIO Code RIO
 * @param typeNumeroTelephone Le type de numéro de téléphone (fixe, mobile ou SVA)
 * @return vrai si le code RIO est dans le bon format, faux sinon
 */
bool verificationFormatCodeRIOTelephone(String codeRIO, String typeNumeroTelephone) {
  if (typeNumeroTelephone == "mobile") {
    Pattern pattern = r"[0-9A-E][0-9A-Z][E|P][A-Z0-9]{6}[A-Z0-9\+]{3}";
    RegExp exp = new RegExp(pattern.toString());

    return exp.hasMatch(codeRIO);
  } else if (typeNumeroTelephone == "fixe") {
    Pattern pattern = r"[F-Z][A-Z0-9][F|G|M|N|R|S|T|U|V|W|X|Y|Z][A-Z0-9]{6}[A-Z0-9\+]{3}";
    RegExp exp = new RegExp(pattern.toString());

    return exp.hasMatch(codeRIO);
  } else if(typeNumeroTelephone == "SVA"){
    Pattern pattern = r"[F-Z][A-Z0-9][A][A-Z0-9]{6}[A-Z0-9\+]{3}";
    RegExp exp = new RegExp(pattern.toString());

    return exp.hasMatch(codeRIO);
  }else return false;
}

/**
 * Donne le type de numéro de téléphone
 * @param numeroTelephone Numéro de téléphone
 * @return le type de numéro de téléphone (fixe, mobile ou SVA)
 */
String typeNumeroTelephone(String numeroTelephone) {
  if (numeroTelephone.substring(0, 2) == "06" ||
      numeroTelephone.substring(0, 2) == "07") {
    return "mobile";
  } else if(numeroTelephone.substring(0, 2) == "08") {
    return "SVA";
  } else {
    return "fixe";
  }
}

/**
 * Vérifie si le code VIA, utilisé pour l'offre de gros VGAST, est dans le bon format
 * @param codeVIA Code VIA
 * @return vrai si le code VIA est dans le bon format, faux sinon
 */
bool verificationFormatVIA(String codeVIA){
  Pattern pattern = r"[V][I][A][0-9]{17}";
  RegExp exp = new RegExp(pattern.toString());

  return exp.hasMatch(codeVIA);
}

/**
 * Vérifie que le champ RRRRRR du RIO correspond bien au code VIA
 * @param codeRIO Le code RIO
 * @param codeVIA Code VIA
 * @return vrai si le champ RRRRRR correspond au code VIA, faux sinon
 */
bool verificationContratRIO(String codeRIO, String codeVIA) {
  String chronoVIA = codeVIA.substring(5);
  String ordre = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789+";
  int a = 0, b = 0, c = 0, d = 0, e = 0, f = 0;

  for (int i = 0; i < chronoVIA.length; i++) {
    String caractere = chronoVIA[i];
    int position = ordre.indexOf(caractere);
    a = (a + position) % 37;
    b = (2*b + position) % 37;
    c = (4*c + position) % 37;
    d = (8*d + position) % 37;
    e = (16*e + position) % 37;
    f = (32*f + position) % 37;
  }

  String cleControle = ordre[a] + ordre[b] + ordre[c] + ordre[d] + ordre[e] + ordre[f];

  if (cleControle == codeRIO.substring(3, 9)) {
    return true;
  } else return false;
}