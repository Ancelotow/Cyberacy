import 'package:bo_cyberacy/models/enums/position_input.dart';
import 'package:bo_cyberacy/widgets/button.dart';
import 'package:bo_cyberacy/widgets/input_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../models/session.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  TextEditingController loginController = new TextEditingController();
  TextEditingController passwordCtrl = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = (kIsWeb) ? MediaQuery.of(context).size.width / 3 : 300;
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: Column(
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
        ),
        Expanded(
          flex: 1,
          child: Column(
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
                click: () {
                  if(passwordCtrl.text != null && loginController.text != null) {
                    Session.openSession(loginController.text, passwordCtrl.text, context);
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

}
