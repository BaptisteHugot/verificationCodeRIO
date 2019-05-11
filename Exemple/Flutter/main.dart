/**
 * @file main.dart
 * @brief Exemple d'application utilisant Flutter
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'verificationRIO.dart';

/**
 * Fonction principale du programme
 */
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Home()
    );
  }
}

class Home extends StatelessWidget {
  TextEditingController controleurNumeroTelephone = TextEditingController();
  TextEditingController controleurCodeRIO = TextEditingController();

  /**
   * Fonction servant à afficher une fenêtre d'alerte
   * @param context Contexte
   * @param message Le message qui sera affiché dans la fenêtre d'alerte
   */
  Future showAlert(BuildContext context, String message) async {
    return showDialog(
        context: context,
        builder: (_) => new AlertDialog(
          title: new Text(message),
          actions: <Widget>[
            new FlatButton(onPressed: () => Navigator.pop(context), child: new Text('OK'))
          ],
        )

    );
  }

  /**
   * Fonction exécutée lorsque l'utilisateur clique sur le bouton "Vérifiez"
   * @return la phrase qui sera affichée à l'utilisateur dans la fenêtre d'alerte
   */
  String actionVerification() {
    String numeroTelephone = controleurNumeroTelephone.text;
    String codeRIO = controleurCodeRIO.text.toUpperCase();

    if(codeRIO.isEmpty || numeroTelephone.isEmpty){
      return "Au moins un des deux champs est vide.";
    } else {
      String typeNumero = typeNumeroTelephone(numeroTelephone);
      if (!verificationFormatNumeroTelephone(numeroTelephone)) {
        return "Le numéro de téléphone n'est pas dans le bon format.";
      } else if (!verificationFormatCodeRIO(codeRIO, typeNumero)) {
        return "Le code RIO n'est pas au bon format.";
      } else if (!verificationCleControle(numeroTelephone, codeRIO)) {
        return "Le code RIO et le numéro de téléphone ne correspondent pas.";
      } else
        return "Le code RIO et le numéro de téléphone correspondent.";
    }
  }

  /**
   * Fonction exécutée lorsque l'utilisateur clique sur le bouton "Effacez"
   */
  void actionEffacement() {
    controleurNumeroTelephone.text = '';
    controleurCodeRIO.text = '';
  }

  /**
   * Définit le widget qui sera affiché
   * @param context Contexte
   */
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Verification du code RIO',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Verification du code RIO'),
        ),
        body: Center(
          child: Column(

            children: [
              Text('Entrez votre numéro de téléphone :'),
              TextField(controller: controleurNumeroTelephone,
                maxLength: 10,
                inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Numéro de téléphone'
                  ),
                onChanged: (v) => controleurNumeroTelephone.text = v,),
              Text('Entrez votre code RIO :'),
              TextField(controller: controleurCodeRIO,
                maxLength: 12,
                inputFormatters: [new WhitelistingTextInputFormatter(new RegExp(r'[0-9A-Z\+]', caseSensitive:false))],
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Code RIO'
                  ),
                onChanged: (v) => controleurCodeRIO.text = v,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RaisedButton(
                    onPressed: () => showAlert(context, actionVerification()),
                    child: const Text('Vérifiez'),
                  ),
                  RaisedButton(
                    onPressed: () => actionEffacement(),
                    child: const Text('Effacez'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}