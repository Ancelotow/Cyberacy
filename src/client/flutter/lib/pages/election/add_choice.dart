import 'package:bo_cyberacy/pages/election/vote_details.dart';
import 'package:flutter/material.dart';
import '../../models/dialog/alert_normal.dart';
import '../../models/entities/choice.dart';
import '../../models/entities/vote.dart';
import '../../models/errors/api_service_error.dart';
import '../../models/notifications/navigation_notification.dart';
import '../../models/services/vote_service.dart';
import '../../widgets/buttons/button.dart';
import '../../widgets/input_field/input_text.dart';

class AddChoice extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final Vote vote;

  AddChoice({
    Key? key,
    required this.vote,
  }) : super(key: key);

  final TextEditingController ctrlName = TextEditingController();
  final TextEditingController ctrlDesc = TextEditingController();
  final TextEditingController ctrlNIR = TextEditingController();

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
                  "Nouveau choix pour le vote\n${vote.name}",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline1,
                ),
                const SizedBox(height: 50),
                InputText(
                  placeholder: "Nom*",
                  icon: Icons.abc,
                  width: width,
                  controller: ctrlName,
                  validator: _validatorFieldNullOrEmpty,
                ),
                InputText(
                  placeholder: "Description*",
                  icon: Icons.abc,
                  width: width,
                  controller: ctrlDesc,
                  validator: _validatorFieldNullOrEmpty,
                ),
                InputText(
                  placeholder: "NIR du candidat",
                  icon: Icons.abc,
                  width: width,
                  controller: ctrlNIR,
                ),
                const SizedBox(height: 10),
                Button(
                  label: "Sauvegarder",
                  width: width,
                  pressedColor: Colors.lightBlue,
                  click: () => _saveChoice(context),
                ),
                const SizedBox(height: 10),
                Button(
                  label: "Annuler",
                  width: width,
                  color: Colors.red,
                  pressedColor: Colors.redAccent,
                  click: () =>
                      NavigationNotification(VoteDetailsPage(idVote: vote.id))
                          .dispatch(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _saveChoice(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        Choice choice = Choice(
          id: -1,
          name: ctrlName.text,
          description: ctrlDesc.text,
          candidateNIR: ctrlNIR.text.isEmpty ? null : ctrlNIR.text,
          idVote: vote.id,
        );
        await VoteService().addChoice(choice, vote.id);
        NavigationNotification(VoteDetailsPage(idVote: vote.id))
            .dispatch(context);
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
}
