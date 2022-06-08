// ignore_for_file: prefer_const_constructors

import 'package:bo_cyberacy/models/entities/manifestation.dart';
import 'package:bo_cyberacy/models/services/manifestation_service.dart';
import 'package:flutter/material.dart';
import '../../models/enums/position_input.dart';
import '../../models/errors/api_service_error.dart';
import '../../models/errors/invalid_form_error.dart';
import '../../widgets/buttons/button.dart';
import '../../widgets/input_field/input_text.dart';

class AddManifestationPage extends StatelessWidget {
  static const String routeName = "addManifPage";

  AddManifestationPage({Key? key}) : super(key: key);

  final TextEditingController ctrlName = TextEditingController();
  final TextEditingController ctrlDtStart = TextEditingController();
  final TextEditingController ctrlDtEnd = TextEditingController();
  final TextEditingController ctrlObject = TextEditingController();
  final TextEditingController ctrlSecurityDesc = TextEditingController();
  final TextEditingController ctrlNbPerson = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width / 3;
    if (width < 300) width = 300;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Nouvelle manifestation",
                style: Theme.of(context).textTheme.headline1,
              ),
              SizedBox(height: 50),
              InputText(
                placeholder: "Nom",
                position: PositionInput.start,
                width: width,
                controller: ctrlName,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InputText(
                      placeholder: "Date de début",
                      position: PositionInput.middle,
                      width: width / 2,
                      controller: ctrlDtStart,
                      type: TextInputType.datetime),
                  InputText(
                      placeholder: "Date de fin",
                      position: PositionInput.middle,
                      width: width / 2,
                      controller: ctrlDtEnd,
                      type: TextInputType.datetime),
                ],
              ),
              InputText(
                placeholder: "Objet",
                position: PositionInput.middle,
                width: width,
                controller: ctrlObject,
              ),
              InputText(
                placeholder: "Description de la sécurité",
                position: PositionInput.middle,
                width: width,
                controller: ctrlSecurityDesc,
              ),
              InputText(
                type: TextInputType.number,
                placeholder: "Estimation du nombre de participant",
                position: PositionInput.end,
                width: width,
                controller: ctrlNbPerson,
              ),
              SizedBox(height: 10),
              Button(
                label: "Sauvegarder",
                width: width,
                pressedColor: Colors.lightBlue,
                click: () => _saveParty(context),
              ),
              SizedBox(height: 10),
              Button(
                label: "Annuler",
                width: width,
                color: Colors.red,
                pressedColor: Colors.redAccent,
                click: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveParty(BuildContext context) async {
    try {
      _formIsValid();
      Manifestation manif = Manifestation(
        name: ctrlName.text,
        dateStart: DateTime.parse(ctrlDtStart.text),
        dateEnd:  DateTime.parse(ctrlDtEnd.text),
        object: ctrlObject.text,
        securityDescription: ctrlSecurityDesc.text,
        nbPersonEstimate: int.parse(ctrlNbPerson.text),
      );
      await ManifService().addManifestation(manif);
      Navigator.of(context).pop();
    } on InvalidFormError catch (e) {
      _showAlertError(
        context,
        title: "Formulaire incomplet",
        message: e.message,
        labelButton: "Continuer",
      );
    } on ApiServiceError catch (e) {
      _showAlertError(
        context,
        title: "Erreur ajout",
        message: e.responseHttp.body,
        labelButton: "Continuer",
      );
    }
  }

  void _formIsValid() {
    if (ctrlName.text.isEmpty) {
      throw InvalidFormError("Le champ \"Nom\" est obligatoire");
    } else if (ctrlDtStart.text.isEmpty) {
      throw InvalidFormError("Le champ \"Date de début\" est obligatoire");
    } else if (ctrlDtEnd.text.isEmpty) {
      throw InvalidFormError("Le champ \"Date de fin\" est obligatoire");
    } else if (ctrlObject.text.isEmpty) {
      throw InvalidFormError("Le champ \"Objet\" est obligatoire");
    } else if (ctrlSecurityDesc.text.isEmpty) {
      throw InvalidFormError("Le champ \"Description de la sécurité\" est obligatoire");
    } else if (ctrlNbPerson.text.isEmpty) {
      throw InvalidFormError("Le champ \"Estimation du nombre de participant\" est obligatoire");
    }
  }

  void _showAlertError(BuildContext context,
      {required String title,
        required String message,
        required String labelButton}) {
    showDialog(
      context: context,
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
