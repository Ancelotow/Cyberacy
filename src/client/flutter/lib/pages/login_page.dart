import 'package:bo_cyberacy/models/enums/position_input.dart';
import 'package:bo_cyberacy/pages/navigation_page.dart';
import 'package:bo_cyberacy/widgets/buttons/button.dart';
import 'package:bo_cyberacy/widgets/input_field/input_text.dart';
import 'package:flutter/material.dart';
import '../models/dialog/alert_normal.dart';
import '../models/errors/api_service_error.dart';
import '../models/session.dart';
import '../widgets/cards/card_shimmer.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = "login";

  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController loginController = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();
  BuildContext? currentContext;
  bool isConnecting = false;

  @override
  Widget build(BuildContext context) {
    currentContext = context;
    double width = MediaQuery.of(context).size.width / 3;
    if (width < 300) width = 300;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image.asset(
                    'assets/images/logo_white.png',
                    width: 200,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
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
                    controller: loginController,
                    icon: Icons.person,
                    width: width,
                  ),
                  InputText(
                    placeholder: "Mot de passe",
                    icon: Icons.key,
                    obscureText: true,
                    controller: passwordCtrl,
                    width: width,
                  ),
                  const SizedBox(height: 20),
                  Button(
                    label: "Se connecter",
                    isLoad: isConnecting,
                    width: width,
                    pressedColor: Colors.lightBlue,
                    click: _getConnection,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _getConnection() async {
    if (passwordCtrl.text.isNotEmpty && loginController.text.isNotEmpty) {
      try {
        setState(() => isConnecting = true);
        await Session.initToken(loginController.text, passwordCtrl.text);
        Navigator.of(currentContext!).pushNamed(NavigationPage.routeName);
      } on ApiServiceError catch (e) {
        if (e.responseHttp.statusCode == 401 && currentContext != null) {
          AlertNormal(
            title: "Echec de la connexion",
            message: "Vérifiez votre identifiant et votre mot de passe.",
            labelButton: "Réssayer",
            context: currentContext!,
          ).show();
        }
      }
    } else {
      AlertNormal(
        title: "Formulaire incomplet",
        message:
            "Veuillez renseignez votre identifiant et votre mot de passe.",
        labelButton: "Réssayer",
        context: currentContext!,
      ).show();
    }
    setState(() => isConnecting = false);
  }
}
