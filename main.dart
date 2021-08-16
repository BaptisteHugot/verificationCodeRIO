import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'verificationRIO.dart';

// Fonction servant à connaître la couleur à afficher en fonction du résultat
Color getColor(bool isValid){
  if(isValid == false){
    return Colors.red;
  }else return Colors.green;
}

// Fonction servant à afficher le bon texte en fonction du résultat
String validite(bool isValid){
  if(isValid == false){
    return "Invalide";
  }else return "Valide";
}

// Fonction principale du programme
void main() => runApp(MyApp());

// Classe de départ pour afficher l'application
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = "Validité d'un IMEI ou d'une carte bancaire";

    return MaterialApp(
      title: appTitle,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: appTitle),
    );
  }
}

// Classe Stateful pour gérer la récupération et le parsing du fichier Json
class MyHomePage extends StatefulWidget{
  final String title;

  MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

// Classe d'état pour gérer la récupération et le parsing du fichier Json
class _MyHomePageState extends State<MyHomePage> {

  /// On définit les contrôleurs de texte et de formulaire
  final inputPhoneController = TextEditingController();
  final inputRIOController = TextEditingController();
  final _formKey = GlobalKey<FormState>();


  bool showResult = false; /// Booléen pour afficher le résultat ou non
  String inputNumber = ""; /// Numéro entré
  String inputRIO = ""; /// RIO entré
  bool isValid = false; /// Booléen pour savoir si le numéro entré est valide ou non

  /// Variables d'affichage de l'application
  int? _radioValue = 0;

  String _displayStartPhoneText = "";
  String _displayInputPhoneText = "";
  String _displayErrorPhoneText = "";

  String _displayStartRIOText = "";
  String _displayInputRIOText = "";
  String _displayErrorRIOText = "";

  /// On initialise l'état de l'application
  void initState(){
    _handleRadioValueChange(_radioValue);
    super.initState();
  }

  /// Lorsqu'on clique sur le bouton effacer
  void _erase(){
    setState((){
      showResult = false;
      inputPhoneController.text = "";
      inputRIOController.text = "";
    });
  }

  /// Lorsqu'on clique sur le bouton valider
  void _validate(){
    if(_formKey.currentState!.validate()){
      setState(() {
        inputNumber = inputPhoneController.text;
        inputRIO = inputRIOController.text;
        if(_radioValue == 0){
          isValid = verificationCleControle(inputNumber, inputRIO);
        }else if(_radioValue == 1){
          isValid = verificationContratRIO(inputRIO, inputNumber);
        }
        showResult = true;
      });
    }else{
      setState((){
        showResult = false;
      });
    }
  }

  /// Lorsqu'un bouton radio est modifié
  void _handleRadioValueChange(int? value){
    setState((){
      _radioValue = value;
      showResult = false;

      switch(_radioValue){
        case 0:
          _displayStartPhoneText = "Entrez un numéro de téléphone";
          _displayInputPhoneText = "Numéro de téléphone";
          _displayErrorPhoneText = "Entrez un numéro de téléphone au format valide";

          _displayStartRIOText = "Entrez un code RIO";
          _displayInputRIOText = "Code RIO";
          _displayErrorRIOText = "Entrez un code RIO au format valide";
          break;
        case 1:
          _displayStartPhoneText = "Entrez un numéro VIA";
          _displayInputPhoneText = "Numéro VIA";
          _displayErrorPhoneText = "Entrez un numéro VIA au format valide";

          _displayStartRIOText = "Entrez un code RIO";
          _displayInputRIOText = "Code RIO";
          _displayErrorRIOText = "Entrez un code RIO au format valide";
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Radio(
                      value: 0,
                      groupValue: _radioValue,
                      activeColor: Colors.blue,
                      onChanged: (int? value) {
                        _handleRadioValueChange(value);
                      }
                  ),
                  Text("Vérification du RIO pour un numéro de téléphone"),
                  Radio(
                      value: 1,
                      groupValue: _radioValue,
                      activeColor: Colors.blue,
                      onChanged: (int? value) {
                        _handleRadioValueChange(value);
                      }
                  ),
                  Text("Vérification du RIO pour une ligne VGAST"),
                ]),
            Text(_displayStartPhoneText),
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: inputPhoneController,
                    inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
                    decoration: InputDecoration(
                        labelText: _displayInputPhoneText
                    ),
                    validator: (value){
                      if(value != null) {
                        if (value.isEmpty) {
                          return _displayStartPhoneText;
                        } else if (_radioValue == 0 && !verificationFormatNumeroTelephone(value)) {
                          return _displayErrorPhoneText;
                        } else
                        if (_radioValue == 1 && !verificationFormatNumeroTelephone(value)) {
                          return _displayErrorPhoneText;
                        }
                        return null;
                      }
                    },
                  ),
                  SizedBox(height: 5), /// On ajoute un espacement en hauteur
                  Text(_displayStartRIOText),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: inputRIOController,
                    inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
                    decoration: InputDecoration(
                        labelText: _displayInputRIOText
                    ),
                    validator: (value){
                      if(value != null) {
                        if (value.isEmpty) {
                          return _displayStartRIOText;
                        } else if (_radioValue == 0 && !verificationFormatCodeRIO(value)) {
                          return _displayErrorRIOText;
                        } else
                        if (_radioValue == 1 && !verificationFormatCodeRIO(value)) {
                          return _displayErrorRIOText;
                        }
                        return null;
                      }
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: (){
                          _validate();
                        },
                        child: Text("Valider"),
                      ),
                      SizedBox(width: 5), /// On ajoute un espacement entre les 2 boutons
                      ElevatedButton(
                        onPressed: (){
                          _erase();
                        },
                        child: Text("Effacer"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            showResult ? DataTable( /// Si un résultat doit être affiché
              columns: <DataColumn>[
                DataColumn(
                  label: Text(
                      _displayInputPhoneText
                  ),
                ),
                DataColumn(
                  label: Text(
                      _displayInputPhoneText
                  ),
                ),
                DataColumn(
                  label: Text(
                    "Validité"
                  ),
                ),
              ],
              rows: <DataRow>[
                DataRow(
                  cells: <DataCell>[
                    DataCell(Text(inputNumber, style: TextStyle(color: getColor(isValid)))),
                    DataCell(Text(inputRIO, style: TextStyle(color: getColor(isValid)))),
                    DataCell(Text(validite(isValid), style: TextStyle(color: getColor(isValid)))),
                  ],
                ),
              ],
            ) : SizedBox(), /// Si aucun résultat ne doit être affiché
          ],
        ),// This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}