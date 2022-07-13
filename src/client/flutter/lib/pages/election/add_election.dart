import 'package:bo_cyberacy/models/entities/election.dart';
import 'package:bo_cyberacy/models/entities/type_vote.dart';
import 'package:bo_cyberacy/models/services/vote_service.dart';
import 'package:bo_cyberacy/pages/vote_page.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import '../../models/dialog/alert_normal.dart';
import '../../models/errors/api_service_error.dart';
import '../../models/errors/invalid_form_error.dart';
import '../../models/notifications/navigation_notification.dart';
import '../../models/services/ref_service.dart';
import '../../widgets/buttons/button.dart';
import '../../widgets/input_field/input_date.dart';
import '../../widgets/input_field/input_selected.dart';
import '../../widgets/input_field/input_text.dart';

class AddElectionPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  AddElectionPage({Key? key}) : super(key: key);

  final TextEditingController ctrlName = TextEditingController();
  final TextEditingController ctrlDtStart = TextEditingController();
  final TextEditingController ctrlDtEnd = TextEditingController();
  TypeVote? currentType;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width / 3;
    if (width < 300) width = 300;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Nouvelle élection",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline1,
                ),
                SizedBox(height: 50),
                InputText(
                  placeholder: "Nom*",
                  icon: Icons.abc,
                  width: width,
                  controller: ctrlName,
                  validator: _validatorFieldNullOrEmpty,
                ),
                SizedBox(
                  width: width,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: InputDate(
                          placeholder: "Date de début*",
                          icon: Icons.calendar_today,
                          controller: ctrlDtStart,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Champs obligatoire";
                            }
                            DateTime date =
                                DateFormat("dd/MM/yyyy HH:mm").parse(value);
                            if (date.isBefore(DateTime.now())) {
                              return "La date doit être supérieure à celle d'aujourd'hui";
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: InputDate(
                          placeholder: "Date de fin*",
                          icon: Icons.calendar_today,
                          controller: ctrlDtEnd,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Champs obligatoire";
                            }
                            if (ctrlDtStart.text.isNotEmpty) {
                              DateTime date =
                                  DateFormat("dd/MM/yyyy HH:mm").parse(value);
                              DateTime dateStart =
                                  DateFormat("dd/MM/yyyy HH:mm")
                                      .parse(ctrlDtStart.text);
                              if (date.isBefore(dateStart)) {
                                return "La date de fin doit être supérieure à la date de début";
                              } else {
                                return null;
                              }
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                InputSelected<TypeVote>(
                  future: RefService().getAllTypeVote(),
                  items: [],
                  value: currentType,
                  placeholder: "Type d'élection*",
                  icon: Icons.how_to_vote_sharp,
                  validator: _validatorInputFieldNullOrEmpty,
                  width: width,
                  onChanged: (value) {
                    currentType = value;
                  },
                ),
                const SizedBox(height: 10),
                Button(
                  label: "Sauvegarder",
                  width: width,
                  pressedColor: Colors.lightBlue,
                  click: () => _saveElection(context),
                ),
                const SizedBox(height: 10),
                Button(
                  label: "Annuler",
                  width: width,
                  color: Colors.red,
                  pressedColor: Colors.redAccent,
                  click: () =>
                      NavigationNotification(VotePage()).dispatch(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _saveElection(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        Election election = Election(
          id: -1,
          name: ctrlName.text,
          dateStart: DateFormat("dd/MM/yyyy HH:mm").parse(ctrlDtStart.text),
          dateEnd: DateFormat("dd/MM/yyyy HH:mm").parse(ctrlDtEnd.text),
          idTypeVote: currentType!.id,
        );
        await VoteService().addElection(election);
        NavigationNotification(VotePage()).dispatch(context);
      } on ApiServiceError catch (e) {
        AlertNormal(
          title: "Erreur ajout",
          message: e.responseHttp.body,
          labelButton: "Continuer",
          context: context,
        ).show();
      }
    }
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
}
