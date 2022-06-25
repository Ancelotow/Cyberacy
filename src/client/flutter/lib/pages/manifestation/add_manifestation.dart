// ignore_for_file: prefer_const_constructors

import 'package:bo_cyberacy/models/entities/manifestation.dart';
import 'package:bo_cyberacy/models/services/manifestation_service.dart';
import 'package:flutter/material.dart';
import '../../models/dialog/alert_normal.dart';
import '../../models/errors/api_service_error.dart';
import '../../models/errors/invalid_form_error.dart';
import '../../models/notifications/navigation_notification.dart';
import '../../widgets/buttons/button.dart';
import '../../widgets/input_field/input_date.dart';
import '../../widgets/input_field/input_text.dart';
import 'package:intl/intl.dart';

import '../manifestion_page.dart';

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
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline1,
              ),
              SizedBox(height: 50),
              InputText(
                placeholder: "Nom",
                icon: Icons.abc,
                width: width,
                controller: ctrlName,
              ),
              SizedBox(
                width: width,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: InputDate(
                        placeholder: "Date de début",
                        icon: Icons.calendar_today,
                        controller: ctrlDtStart,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: InputDate(
                        placeholder: "Date de fin",
                        icon: Icons.calendar_today,
                        controller: ctrlDtEnd,
                      ),
                    ),
                  ],
                ),
              ),
              InputText(
                placeholder: "Objet",
                icon: Icons.abc,
                width: width,
                controller: ctrlObject,
              ),
              InputText(
                placeholder: "Description de la sécurité",
                icon: Icons.shield,
                width: width,
                controller: ctrlSecurityDesc,
              ),
              InputText(
                type: TextInputType.number,
                icon: Icons.group,
                placeholder: "Estimation du nombre de participant",
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
                click: () => NavigationNotification(ManifestationPage()).dispatch(context),
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
        dateStart: DateFormat("dd/MM/yyyy HH:mm").parse(ctrlDtStart.text),
        dateEnd: DateFormat("dd/MM/yyyy HH:mm").parse(ctrlDtEnd.text),
        object: ctrlObject.text,
        securityDescription: ctrlSecurityDesc.text,
        nbPersonEstimate: int.parse(ctrlNbPerson.text),
      );
      await ManifService().addManifestation(manif);
      Navigator.of(context).pop();
    } on InvalidFormError catch (e) {
      AlertNormal(
        context: context,
        title: "Formulaire incomplet",
        message: e.message,
        labelButton: "Continuer",
      ).show();
    } on ApiServiceError catch (e) {
      AlertNormal(
        title: "Erreur ajout",
        message: e.responseHttp.body,
        labelButton: "Continuer",
        context: context,
      ).show();
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
      throw InvalidFormError(
          "Le champ \"Description de la sécurité\" est obligatoire");
    } else if (ctrlNbPerson.text.isEmpty) {
      throw InvalidFormError(
          "Le champ \"Estimation du nombre de participant\" est obligatoire");
    }
  }

}
