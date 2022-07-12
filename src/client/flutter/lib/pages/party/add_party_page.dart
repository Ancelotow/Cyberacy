import 'package:bo_cyberacy/models/entities/political_edge.dart';
import 'package:bo_cyberacy/models/entities/political_party.dart';
import 'package:bo_cyberacy/models/services/party_service.dart';
import 'package:bo_cyberacy/models/services/ref_service.dart';
import 'package:bo_cyberacy/widgets/input_field/input_selected.dart';
import 'package:flutter/material.dart';
import '../../models/dialog/alert_normal.dart';
import '../../models/entities/town.dart';
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
  final _formKey = GlobalKey<FormState>();

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
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Nouveau parti politique",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline1,
              ),
              Text(
                "(Le nom et l'adresse du parti seront rempli automatiquement grâce au SIREN)",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyText1,
              ),
              const SizedBox(height: 50),
              InputText(
                placeholder: "SIREN*",
                icon: Icons.person,
                width: width,
                validator: _validatorFieldNullOrEmpty,
                controller: ctrlSiren,
              ),
              InputText(
                placeholder: "Objet*",
                icon: Icons.abc,
                width: width,
                validator: _validatorFieldNullOrEmpty,
                controller: ctrlObject,
              ),
              InputText(
                placeholder: "Description*",
                icon: Icons.abc,
                width: width,
                validator: _validatorFieldNullOrEmpty,
                controller: ctrlDescription,
              ),
              InputText(
                placeholder: "IBAN*",
                icon: Icons.credit_card,
                width: width,
                validator: _validatorFieldNullOrEmpty,
                controller: ctrlIban,
              ),
              InputText(
                placeholder: "NIR du fondateur*",
                icon: Icons.person,
                width: width,
                validator: _validatorFieldNullOrEmpty,
                controller: ctrlNir,
              ),
              InputText(
                placeholder: "URL Logo*",
                icon: Icons.image,
                validator: _validatorFieldNullOrEmpty,
                width: width,
                controller: ctrlUrlLogo,
              ),
              InputSelected<PoliticalEdge>(
                future: RefService().getAllPoliticalEdge(),
                items: [],
                value: currentEdge,
                placeholder: "Bord politique*",
                icon: Icons.event_seat,
                validator: _validatorInputFieldNullOrEmpty,
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
      ),
    );
  }

  String? _validatorFieldNullOrEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return "Champ obligatoire";
    } else {
      return null;
    }
  }

  String? _validatorInputFieldNullOrEmpty(dynamic value) {
    if (value == null) {
      return "Champ obligatoire";
    } else {
      return null;
    }
  }

  Future<void> _saveParty(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() => isSaving = true);
      try {
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
  }

}
