import 'package:bo_cyberacy/models/entities/political_edge.dart';
import 'package:bo_cyberacy/models/entities/political_party.dart';
import 'package:bo_cyberacy/models/errors/invalid_form_error.dart';
import 'package:bo_cyberacy/models/services/party_service.dart';
import 'package:bo_cyberacy/models/services/ref_service.dart';
import 'package:bo_cyberacy/widgets/input_field/input_selected.dart';
import 'package:flutter/material.dart';
import '../../models/dialog/alert_normal.dart';
import '../../models/entities/town.dart';
import '../../models/enums/position_input.dart';
import '../../models/errors/api_service_error.dart';
import '../../models/notifications/navigation_notification.dart';
import '../../widgets/buttons/button.dart';
import '../../widgets/input_field/input_text.dart';
import '../party_page.dart';

class AddPartyPage extends StatefulWidget {
  static const String routeName = "infoPartyPage";

  AddPartyPage({Key? key}) : super(key: key);

  @override
  State<AddPartyPage> createState() => _AddPartyPageState();
}

class _AddPartyPageState extends State<AddPartyPage> {
  final TextEditingController ctrlName = TextEditingController();
  final TextEditingController ctrlSiren = TextEditingController();
  final TextEditingController ctrlDate = TextEditingController();
  final TextEditingController ctrlObject = TextEditingController();
  final TextEditingController ctrlDescription = TextEditingController();
  final TextEditingController ctrlUrlLogo = TextEditingController();
  final TextEditingController ctrlIban = TextEditingController();
  final TextEditingController ctrlAddress = TextEditingController();
  final TextEditingController ctrlNir = TextEditingController();
  Town? currentTown;
  PoliticalEdge? currentEdge;
  bool isSaving = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width / 3;
    if (width < 300) width = 300;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Nouveau parti politique",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline1,
            ),
            const SizedBox(height: 50),
            InputText(
              placeholder: "SIREN",
              icon: Icons.person,
              width: width,
              controller: ctrlSiren,
            ),
            InputText(
              placeholder: "Objet",
              icon: Icons.abc,
              width: width,
              controller: ctrlObject,
            ),
            InputText(
              placeholder: "Description",
              icon: Icons.abc,
              width: width,
              controller: ctrlDescription,
            ),
            InputText(
              placeholder: "IBAN",
              icon: Icons.credit_card,
              width: width,
              controller: ctrlIban,
            ),
            InputText(
              placeholder: "NIR du fondateur",
              icon: Icons.person,
              width: width,
              controller: ctrlNir,
            ),
            InputText(
              placeholder: "URL Logo",
              icon: Icons.image,
              width: width,
              controller: ctrlUrlLogo,
            ),
            InputSelected<PoliticalEdge>(
              future: RefService().getAllPoliticalEdge(),
              items: [],
              value: currentEdge,
              placeholder: "Bord politique",
              icon: Icons.event_seat,
              width: width,
              onChanged: (value) {
                currentEdge = value;
              },
            ),
            SizedBox(height: 10),
            Button(
              label: "Sauvegarder",
              width: width,
              isLoad: isSaving,
              pressedColor: Colors.lightBlue,
              click: () => _saveParty(context),
            ),
            SizedBox(height: 10),
            Button(
                label: "Annuler",
                width: width,
                color: Colors.red,
                pressedColor: Colors.redAccent,
                click: () => NavigationNotification(PartyPage()).dispatch(context),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveParty(BuildContext context) async {
    setState(() => isSaving = true);
    try {
      _formIsValid();
      PoliticalParty party = PoliticalParty(
        object: ctrlObject.text,
        siren: ctrlSiren.text,
        nirFondator: ctrlNir.text,
        iban: ctrlIban.text,
        urlLogo: ctrlUrlLogo.text,
        idPoliticalEdge: currentEdge!.id,
      );
      await PartyService().addParty(party);
      NavigationNotification(PartyPage()).dispatch(context);
    } on InvalidFormError catch (e) {
      AlertNormal(
        context: context,
        title: "Formulaire incomplet",
        message: e.message,
        labelButton: "Continuer",
      ).show();
    } on ApiServiceError catch (e) {
      AlertNormal(
        context: context,
        title: "Erreur ajout",
        message: e.responseHttp.body,
        labelButton: "Continuer",
      ).show();
    } finally {
      setState(() => isSaving = false);
    }
  }

  void _formIsValid() {
    if (ctrlObject.text.isEmpty) {
      throw InvalidFormError("Le champ \"Objet\" est obligatoire");
    } else if (ctrlSiren.text.isEmpty) {
      throw InvalidFormError("Le champ \"SIREN\" est obligatoire");
    } else if (ctrlNir.text.isEmpty) {
      throw InvalidFormError("Le champ \"NIR du fondateur\" est obligatoire");
    } else if (ctrlUrlLogo.text.isEmpty) {
      throw InvalidFormError("Le champ \"URL Logo\" est obligatoire");
    } else if (currentEdge == null) {
      throw InvalidFormError("Le champ \"Bord politique\" est obligatoire");
    }
  }
}
