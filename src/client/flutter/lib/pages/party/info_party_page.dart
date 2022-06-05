import 'package:bo_cyberacy/models/entities/department.dart';
import 'package:bo_cyberacy/models/entities/political_edge.dart';
import 'package:bo_cyberacy/models/entities/political_party.dart';
import 'package:bo_cyberacy/models/services/geo_service.dart';
import 'package:bo_cyberacy/models/services/party_service.dart';
import 'package:bo_cyberacy/models/services/ref_service.dart';
import 'package:bo_cyberacy/widgets/input_field/input_selected.dart';
import 'package:flutter/material.dart';
import '../../models/entities/town.dart';
import '../../models/enums/position_input.dart';
import '../../models/errors/api_service_error.dart';
import '../../widgets/buttons/button.dart';
import '../../widgets/input_field/input_text.dart';

class InfoPartyPage extends StatelessWidget {
  static const String routeName = "infoPartyPage";

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

  InfoPartyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width / 3;
    if (width < 300) width = 300;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Center(
        child: Column(
          children: [
            InputText(
              placeholder: "SIREN",
              position: PositionInput.start,
              width: width,
              controller: ctrlSiren,
            ),
            InputText(
              placeholder: "Objet",
              position: PositionInput.middle,
              width: width,
              controller: ctrlObject,
            ),
            InputText(
              placeholder: "Description",
              position: PositionInput.middle,
              width: width,
              controller: ctrlDescription,
            ),
            InputText(
              placeholder: "IBAN",
              position: PositionInput.middle,
              width: width,
              controller: ctrlIban,
            ),
            InputText(
              placeholder: "NIR du fondateur",
              position: PositionInput.middle,
              width: width,
              controller: ctrlNir,
            ),
            InputText(
              placeholder: "URL Logo",
              position: PositionInput.middle,
              width: width,
              controller: ctrlUrlLogo,
            ),
            getSelectEdge(context, width),
            SizedBox(
              height: 10,
            ),
            Button(
              label: "Sauvegarder",
              width: width,
              pressedColor: Colors.lightBlue,
              click: () => saveParty(context),
            ),
            SizedBox(
              height: 10,
            ),
            Button(
                label: "Annuler",
                width: width,
                color: Colors.red,
                pressedColor: Colors.redAccent,
                click: () => Navigator.of(context).pop()),
          ],
        ),
      ),
    );
  }

  Widget getSelectTown(BuildContext context, double width) {
    return FutureBuilder(
      future: GeoService().getTownsFromDept("94"),
      builder: (BuildContext context, AsyncSnapshot<List<Town>> snapshot) {
        if (snapshot.hasData) {
          return InputSelected<Town>(
            items: snapshot.data!,
            placeholder: "Ville",
            position: PositionInput.middle,
            width: width,
            onChanged: (value) {
              currentTown = value;
            },
          );
        } else {
          return InputText(
            placeholder: "Ville",
            isReadOnly: true,
            position: PositionInput.middle,
            width: width,
          );
        }
      },
    );
  }

  Widget getSelectDept(BuildContext context, double width) {
    return FutureBuilder(
      future: GeoService().getDepartments(),
      builder:
          (BuildContext context, AsyncSnapshot<List<Department>> snapshot) {
        if (snapshot.hasData) {
          return InputSelected(
            items: snapshot.data!,
            placeholder: "Département",
            position: PositionInput.middle,
            width: width,
          );
        } else {
          return InputText(
            placeholder: "Département",
            isReadOnly: true,
            position: PositionInput.middle,
            width: width,
          );
        }
      },
    );
  }

  Widget getSelectEdge(BuildContext context, double width) {
    return FutureBuilder(
      future: RefService().getAllPoliticalEdge(),
      builder:
          (BuildContext context, AsyncSnapshot<List<PoliticalEdge>> snapshot) {
        if (snapshot.hasData) {
          return InputSelected(
            items: snapshot.data!,
            placeholder: "Bord politique",
            position: PositionInput.end,
            width: width,
            onChanged: (value) {
              currentEdge = value;
            },
          );
        } else {
          return InputText(
            placeholder: "Bord politique",
            isReadOnly: true,
            position: PositionInput.end,
            width: width,
          );
        }
      },
    );
  }

  Future<void> saveParty(BuildContext context) async {
    try {
      PoliticalParty party = PoliticalParty(
        id: -1,
        name: "",
        dateCreate: DateTime.now(),
        object: ctrlObject.text,
        addressStreet: "",
        siren: ctrlSiren.text,
        codeInseeTown: "",
        nirFondator: ctrlNir.text,
        iban: ctrlIban.text,
        urlLogo: ctrlUrlLogo.text,
        idPoliticalEdge: currentEdge!.id,
      );
      await PartyService().addParty(party);
      Navigator.of(context).pop();
    } on NullThrownError {
      _showAlertError(
        context,
        title: "Formulaire incomplet",
        message: "Tout les champs sont obligatoire",
        labelButton: "Continuer",
      );
    } on ApiServiceError catch (e) {
      _showAlertError(
        context,
        title: "Erreur sauvegarde",
        message: e.responseHttp.body,
        labelButton: "Continuer",
      );
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
