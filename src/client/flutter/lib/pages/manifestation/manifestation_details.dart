import 'package:bo_cyberacy/models/entities/manifestation.dart';
import 'package:bo_cyberacy/models/entities/step.dart';
import 'package:bo_cyberacy/widgets/cards/card_option_manif.dart';
import 'package:bo_cyberacy/widgets/cards/card_step.dart';
import 'package:flutter/material.dart';

import '../../models/entities/option.dart';
import '../../models/enums/position_input.dart';
import '../../widgets/buttons/button.dart';
import '../../widgets/input_field/input_text.dart';
import '../../widgets/map_manifestation.dart';

class ManifestationDetail extends StatelessWidget {
  static const String routeName = "detailsManifPage";

  final Manifestation manifestation;
  late final List<StepManif> steps;
  late final List<Option> options;

  final TextEditingController ctrlName = TextEditingController();
  final TextEditingController ctrlDtStart = TextEditingController();
  final TextEditingController ctrlDtEnd = TextEditingController();
  final TextEditingController ctrlObject = TextEditingController();
  final TextEditingController ctrlSecurityDesc = TextEditingController();
  final TextEditingController ctrlNbPerson = TextEditingController();

  ManifestationDetail({
    Key? key,
    required this.manifestation,
  }) : super(key: key) {
    if (manifestation.name != null) ctrlName.text = manifestation.name!;
    if (manifestation.dateStart != null) {
      ctrlDtStart.text = manifestation.dateStart!.toString();
    }
    if (manifestation.dateEnd != null) {
      ctrlDtEnd.text = manifestation.dateEnd!.toString();
    }
    if (manifestation.object != null) ctrlObject.text = manifestation.object!;
    if (manifestation.securityDescription != null) {
      ctrlSecurityDesc.text = manifestation.securityDescription!;
    }
    if (manifestation.nbPersonEstimate != null) {
      ctrlNbPerson.text = manifestation.nbPersonEstimate!.toString();
    }
    if (manifestation.steps != null) {
      steps = manifestation.steps!;
    }
    if (manifestation.options != null) {
      options = manifestation.options!;
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width / 3;
    if (width < 300) width = 300;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Wrap(
              direction: Axis.horizontal,
              spacing: 150.00,
              runSpacing: 10.00,
              children: [
                Container(
                  width: width,
                  child: Column(
                    children: [
                      getForm(context, width),
                      SizedBox(height: 50,),
                      getOptions(context, width)
                    ],
                  ),
                ),
                getSteps(context, width)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getForm(BuildContext context, double width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Manifestation n°${manifestation.id}",
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
              isReadOnly: true,
              width: width / 2,
              controller: ctrlDtStart,
              type: TextInputType.datetime,
            ),
            InputText(
              placeholder: "Date de fin",
              position: PositionInput.middle,
              isReadOnly: true,
              width: width / 2,
              controller: ctrlDtEnd,
              type: TextInputType.datetime,
            ),
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
          click: () => {},
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
    );
  }

  Widget getSteps(BuildContext context, double width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Etapes",
          style: Theme.of(context).textTheme.headline4,
        ),
        ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          child: Container(
            width: width,
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  height: 200,
                  child: MapManifestation(steps: steps),
                ),
                SingleChildScrollView(
                  child: Wrap(
                    direction: Axis.vertical,
                    spacing: 1.00,
                    children: steps
                        .map((e) => CardStep(
                              step: e,
                              width: width,
                              index: (steps.indexOf(e) + 1),
                            ))
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget getOptions(BuildContext context, double width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Options",
          style: Theme.of(context).textTheme.headline4,
        ),
        ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          child: Container(
            width: width,
            height: 300,
            color: Color.fromARGB(255, 16, 58, 101),
            child: SingleChildScrollView(
              child: Wrap(
                direction: Axis.horizontal,
                spacing: 5.00,
                runSpacing: 2.00,
                children:
                    options.map((e) => CardOptionManif(option: e)).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
