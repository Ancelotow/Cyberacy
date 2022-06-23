import 'package:bo_cyberacy/models/entities/political_edge.dart';
import 'package:bo_cyberacy/models/entities/political_party.dart';
import 'package:bo_cyberacy/models/errors/invalid_form_error.dart';
import 'package:bo_cyberacy/models/services/party_service.dart';
import 'package:bo_cyberacy/models/services/ref_service.dart';
import 'package:bo_cyberacy/widgets/input_field/input_selected.dart';
import 'package:flutter/material.dart';
import '../../models/entities/town.dart';
import '../../models/enums/position_input.dart';
import '../../models/errors/api_service_error.dart';
import '../../widgets/buttons/button.dart';
import '../../widgets/input_field/input_text.dart';

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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Nouveau parti politique",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline1,
              ),
              SizedBox(height: 50),
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
              _getSelectEdge(context, width),
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
                  click: () => Navigator.of(context).pop()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getSelectEdge(BuildContext context, double width) {
    return FutureBuilder(
      future: RefService().getAllPoliticalEdge(),
      builder:
          (BuildContext context, AsyncSnapshot<List<PoliticalEdge>> snapshot) {
        if (snapshot.hasData) {
          return InputSelected(
            items: snapshot.data!,
            value: currentEdge,
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
