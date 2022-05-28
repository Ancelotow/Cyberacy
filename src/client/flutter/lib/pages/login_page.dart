import 'package:bo_cyberacy/models/enums/position_input.dart';
import 'package:bo_cyberacy/widgets/button.dart';
import 'package:bo_cyberacy/widgets/input_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../models/errors/api_service_error.dart';
import '../models/session.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  TextEditingController loginController = new TextEditingController();
  TextEditingController passwordCtrl = new TextEditingController();
  BuildContext? currentContext;

  @override
  Widget build(BuildContext context) {
    currentContext = context;
    double width = (kIsWeb) ? MediaQuery.of(context).size.width / 3 : 300;
    return Column(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Image.asset(
              'assets/images/logo_white.png',
              width: 300,
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "CYBERACY",
                style: Theme.of(context).textTheme.headline1,
              ),
            )
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            InputText(
              placeholder: "Numéro de sécurité social",
              position: PositionInput.start,
              controller: loginController,
              width: width,
            ),
            InputText(
              placeholder: "Mot de passe",
              position: PositionInput.end,
              obscureText: true,
              controller: passwordCtrl,
              width: width,
            ),
            SizedBox(height: 20),
            Button(
              label: "Se connecter",
              width: width,
              pressedColor: Colors.lightBlue,
              click: _getConnection,
            ),
          ],
        ),
      ],
    );
  }

  void _getConnection() async {
    if (passwordCtrl.text.isNotEmpty && loginController.text.isNotEmpty) {
      try {
        await Session.openSession(loginController.text, passwordCtrl.text);
      } on ApiServiceError catch (e) {
        if (e.responseHttp.statusCode == 401 && currentContext != null) {
          _showAlertError(
            title: "Echec de la connexion",
            message: "Vérifiez votre identifiant et votre mot de passe.",
            labelButton: "Réssayer"
          );
        }
      }
    }
  }

  void _showAlertError(
      {required String title,
      required String message,
      required String labelButton}) {
    showDialog(
      context: currentContext!,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          Button(
            width: 100,
            label: labelButton,
            click: () {
              Navigator.pop(_);
            },
          )
        ],
        elevation: 30.00,
      ),
    );
  }
}
