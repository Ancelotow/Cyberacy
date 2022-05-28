import 'package:bo_cyberacy/models/position_input.dart';
import 'package:bo_cyberacy/widgets/button.dart';
import 'package:bo_cyberacy/widgets/input_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  TextEditingController loginController = new TextEditingController();
  TextEditingController passwordCtrl = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = (kIsWeb) ? MediaQuery.of(context).size.width / 3 : 300;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
              print("ok");
            },
          ),
        ],
      ),
    );
  }
}
