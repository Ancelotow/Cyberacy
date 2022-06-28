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
              InputSelected<TypeVote>(
                future: RefService().getAllTypeVote(),
                items: [],
                value: currentType,
                placeholder: "Type d'élection",
                icon: Icons.how_to_vote_sharp,
                width: width,
                onChanged: (value) {
                  currentType = value;
                },
              ),
              SizedBox(height: 10),
              Button(
                label: "Sauvegarder",
                width: width,
                pressedColor: Colors.lightBlue,
                click: () => _saveElection(context),
              ),
              SizedBox(height: 10),
              Button(
                label: "Annuler",
                width: width,
                color: Colors.red,
                pressedColor: Colors.redAccent,
                click: () => NavigationNotification(VotePage()).dispatch(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveElection(BuildContext context) async {
    try {
      _formIsValid();
      Election election = Election(
        id: -1,
        name: ctrlName.text,
        dateStart: DateFormat("dd/MM/yyyy HH:mm").parse(ctrlDtStart.text),
        dateEnd: DateFormat("dd/MM/yyyy HH:mm").parse(ctrlDtEnd.text),
        idTypeVote: currentType!.id,
      );
      await VoteService().addElection(election);
      NavigationNotification(VotePage()).dispatch(context);
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
    } else if (currentType == null) {
      throw InvalidFormError("Le champ \"Type d'élection\" est obligatoire");
    }
  }

}
