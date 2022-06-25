// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:bo_cyberacy/models/entities/manifestation.dart';
import 'package:bo_cyberacy/models/entities/step.dart';
import 'package:bo_cyberacy/widgets/cards/card_option_manif.dart';
import 'package:bo_cyberacy/widgets/cards/card_step.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../models/dialog/alert_yes_no.dart';
import '../../models/entities/option.dart';
import '../../models/enums/position_input.dart';
import '../../models/notifications/save_notification.dart';
import '../../models/notifications/step_notification.dart';
import '../../models/services/manifestation_service.dart';
import '../../widgets/buttons/button.dart';
import '../../widgets/cards/card_shimmer.dart';
import '../../widgets/input_field/input_text.dart';
import '../../widgets/map_manifestation.dart';
import 'form_aborted_manifestation.dart';
import 'form_add_step.dart';

class ManifestationDetail extends StatefulWidget {
  static const String routeName = "detailsManifPage";

  final Manifestation manifestation;
  late List<StepManif> steps;
  late final List<Option> options;

  ManifestationDetail({
    Key? key,
    required this.manifestation,
  }) : super(key: key);

  @override
  State<ManifestationDetail> createState() => _ManifestationDetailState();
}

class _ManifestationDetailState extends State<ManifestationDetail> {
  bool getStepsFromApi = false;
  final TextEditingController ctrlName = TextEditingController();
  final TextEditingController ctrlDtStart = TextEditingController();
  final TextEditingController ctrlDtEnd = TextEditingController();
  final TextEditingController ctrlObject = TextEditingController();
  final TextEditingController ctrlSecurityDesc = TextEditingController();
  final TextEditingController ctrlNbPerson = TextEditingController();
  final MapController mapController = MapController();

  @override
  void initState() {
    if (widget.manifestation.name != null) {
      ctrlName.text = widget.manifestation.name!;
    }
    if (widget.manifestation.dateStart != null) {
      ctrlDtStart.text = widget.manifestation.dateStart!.toString();
    }
    if (widget.manifestation.dateEnd != null) {
      ctrlDtEnd.text = widget.manifestation.dateEnd!.toString();
    }
    if (widget.manifestation.object != null) {
      ctrlObject.text = widget.manifestation.object!;
    }
    if (widget.manifestation.securityDescription != null) {
      ctrlSecurityDesc.text = widget.manifestation.securityDescription!;
    }
    if (widget.manifestation.nbPersonEstimate != null) {
      ctrlNbPerson.text = widget.manifestation.nbPersonEstimate!.toString();
    }
    if (widget.manifestation.steps != null) {
      widget.steps = widget.manifestation.steps!;
    }
    if (widget.manifestation.options != null) {
      widget.options = widget.manifestation.options!;
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width / 3;
    if (width < 300) width = 300;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                children: [
                  getForm(context, width),
                  SizedBox(
                    height: 50,
                  ),
                  //getOptions(context, width)
                ],
              ),
            ),
            getSteps(context, width)
          ],
        ),
      ),
    );
  }

  Widget getForm(BuildContext context, double width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            "Manifestation n°${widget.manifestation.id}",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline1,
          ),
        ),
        InputText(
          placeholder: "Nom",
          isReadOnly: true,
          width: width,
          controller: ctrlName,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InputText(
              placeholder: "Date de début",
              isReadOnly: true,
              width: width / 2,
              controller: ctrlDtStart,
              type: TextInputType.datetime,
            ),
            InputText(
              placeholder: "Date de fin",
              isReadOnly: true,
              width: width / 2,
              controller: ctrlDtEnd,
              type: TextInputType.datetime,
            ),
          ],
        ),
        InputText(
          placeholder: "Objet",
          isReadOnly: true,
          width: width,
          controller: ctrlObject,
        ),
        InputText(
          placeholder: "Description de la sécurité",
          isReadOnly: true,
          width: width,
          controller: ctrlSecurityDesc,
        ),
        InputText(
          type: TextInputType.number,
          placeholder: "Estimation du nombre de participant",
          isReadOnly: true,
          width: width,
          controller: ctrlNbPerson,
        ),
        SizedBox(height: 10),
        Button(
          label: "Annuler la manifestation",
          width: width,
          color: Colors.red,
          pressedColor: Colors.redAccent,
          click: () => _abortedManifestation(context),
        ),
      ],
    );
  }

  Widget getSteps(BuildContext context, double width) {
    return Container(
      color: Theme.of(context).cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Etapes",
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
          Expanded(
            child: Container(
              width: 500,
              color: Theme.of(context).cardColor,
              child: Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      child: MapManifestation(
                        steps: widget.steps,
                        controller: mapController,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: SingleChildScrollView(
                      child: _getListSteps(context, getStepsFromApi),
                    ),
                  ),
                  Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Button(
                          label: "Ajouter",
                          width: 100,
                          pressedColor: Theme.of(context).focusColor,
                          color: Theme.of(context).highlightColor,
                          textStyle: TextStyle(color: Colors.white),
                          click: () => showDialog(
                            builder: (_) {
                              return NotificationListener<
                                  SaveNotification<StepManif>>(
                                onNotification: (value) {
                                  setState(() => getStepsFromApi = true);
                                  return true;
                                },
                                child: AlertDialog(
                                  title: Text(
                                    "Ajout d'une étape",
                                    style:
                                        Theme.of(context).textTheme.headline1,
                                  ),
                                  backgroundColor:
                                      Theme.of(context).backgroundColor,
                                  content: SizedBox(
                                    width: 700,
                                    height: 600,
                                    child: FormAddStep(
                                      idManifesation: widget.manifestation.id!,
                                    ),
                                  ),
                                ),
                              );
                            },
                            context: context,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
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
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Wrap(
                  direction: Axis.horizontal,
                  spacing: 5.00,
                  runSpacing: 2.00,
                  children: widget.options
                      .map((e) => CardOptionManif(option: e))
                      .toList(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _getListSteps(BuildContext context, bool getFromApi) {
    if (getFromApi) {
      return FutureBuilder(
        future: ManifService().getSteps(widget.manifestation.id!),
        builder:
            (BuildContext context, AsyncSnapshot<List<StepManif>> snapshot) {
          if (snapshot.hasData) {
            widget.steps = snapshot.data!;
            return _getCardSteps(context);
          } else {
            return _getStepsLoader(context);
          }
        },
      );
    } else {
      return _getCardSteps(context);
    }
  }

  Widget _getStepsLoader(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: List.filled(
        30,
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CardShimmer(height: 60),
        ),
      ),
    );
  }

  Widget _getCardSteps(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: widget.steps
          .map(
            (e) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: NotificationListener<Notification>(
                onNotification: (value) {
                  if (value is StepNotification) {
                    double latStart = (value.step.latitude != null)
                        ? value.step.latitude!
                        : 0.00;
                    double lngStart = (value.step.longitude != null)
                        ? value.step.longitude!
                        : 0.00;
                    double zoom = (latStart == 0.0 || lngStart == 0.0) ? 0 : 17;
                    mapController.move(LatLng(latStart, lngStart), zoom);
                  } else if (value is SaveNotification) {
                    setState(() => getStepsFromApi = true);
                  }
                  return true;
                },
                child: CardStep(
                  step: e,
                  index: (widget.steps.indexOf(e) + 1),
                ),
              ),
            ),
          ).toList(),
    );
  }

  void _abortedManifestation(BuildContext context) {
    showDialog(
      builder: (_) {
        return NotificationListener<SaveNotification<String>>(
          onNotification: (value) {
            Navigator.of(context).pop();
            return true;
          },
          child: AlertDialog(
            title: Text(
              "Annuler la manifestation",
              style: Theme.of(context).textTheme.headline1,
            ),
            backgroundColor: Theme.of(context).backgroundColor,
            content: SizedBox(
              width: 700,
              height: 250,
              child: FormAbortedManifestation(
                idManifestation: widget.manifestation.id!,
              ),
            ),
          ),
        );
      },
      context: context,
    );
  }
}
