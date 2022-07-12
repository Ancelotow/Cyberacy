import 'package:bo_cyberacy/models/entities/meeting.dart';
import 'package:bo_cyberacy/models/entities/political_party.dart';
import 'package:bo_cyberacy/models/services/meeting_service.dart';
import 'package:bo_cyberacy/models/services/party_service.dart';
import 'package:bo_cyberacy/pages/meetings_page.dart';
import 'package:bo_cyberacy/widgets/input_field/input_date.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/dialog/alert_normal.dart';
import '../../models/entities/department.dart';
import '../../models/entities/town.dart';
import '../../models/errors/api_service_error.dart';
import '../../models/notifications/navigation_notification.dart';
import '../../models/services/geo_service.dart';
import '../../widgets/buttons/button.dart';
import '../../widgets/input_field/input_selected.dart';
import '../../widgets/input_field/input_text.dart';

class AddMeeting extends StatefulWidget {
  AddMeeting({Key? key}) : super(key: key);

  @override
  State<AddMeeting> createState() => _AddMeetingState();
}

class _AddMeetingState extends State<AddMeeting> {
  final TextEditingController ctrlName = TextEditingController();
  final TextEditingController ctrlObject = TextEditingController();
  final TextEditingController ctrlDesc = TextEditingController();
  final TextEditingController ctrlDtStart = TextEditingController();
  final TextEditingController ctrlTime = TextEditingController();
  final TextEditingController ctrlAddress = TextEditingController();
  final TextEditingController ctrlNbPlace = TextEditingController();
  final TextEditingController ctrlPriceExcl = TextEditingController();
  final TextEditingController ctrlVAT = TextEditingController();
  final TextEditingController ctrlLinkTwitch = TextEditingController();
  final TextEditingController ctrlLinkYoutube = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Town? currentTown;
  Department? currentDepartment;
  PoliticalParty? currentParty;

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
                  "Nouveau meeting",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline1,
                ),
                const SizedBox(height: 50),
                InputText(
                  placeholder: "Nom*",
                  validator: _validatorFieldNullOrEmpty,
                  icon: Icons.abc,
                  controller: ctrlName,
                  width: width,
                ),
                InputText(
                  placeholder: "Objet*",
                  validator: _validatorFieldNullOrEmpty,
                  icon: Icons.abc,
                  controller: ctrlObject,
                  width: width,
                ),
                InputText(
                  placeholder: "Description",
                  icon: Icons.description_outlined,
                  controller: ctrlDesc,
                  width: width,
                ),
                SizedBox(
                  width: width,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: InputDate(
                          placeholder: "Date*",
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
                          controller: ctrlDtStart,
                          icon: Icons.calendar_month,
                          width: width,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: InputText(
                          placeholder: "Temps*",
                          icon: Icons.chair,
                          controller: ctrlTime,
                          width: width,
                        ),
                      ),
                    ],
                  ),
                ),
                InputText(
                  placeholder: "Adresse",
                  icon: Icons.streetview,
                  controller: ctrlAddress,
                  width: width,
                ),
                SizedBox(
                  width: width,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: InputSelected<Department>(
                          future: GeoService().getDepartments(),
                          items: [],
                          value: currentDepartment,
                          placeholder: "Département",
                          icon: Icons.landscape,
                          validator: _validatorInputFieldNullOrEmpty,
                          onChanged: (value) =>
                              setState(() => currentDepartment = value),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(child: _getDropdownTown(context)),
                    ],
                  ),
                ),
                SizedBox(
                  width: width,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: InputText(
                            placeholder: "Nombre de places*",
                            icon: Icons.chair,
                            width: width,
                            controller: ctrlNbPlace,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Champs obligatoire";
                              }
                              try {
                                int valueInt = int.parse(value);
                              } on FormatException catch (e) {
                                return "La valeur doit être un nombre non décimale";
                              }
                            }),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: InputText(
                          placeholder: "Prix HT*",
                          icon: Icons.euro,
                          width: width,
                          controller: ctrlPriceExcl,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Champs obligatoire";
                            }
                            try {
                              double valueDouble = double.parse(value);
                              if (valueDouble < 0.00) {
                                return "Le prix ne peut pas être négatif";
                              } else {
                                return null;
                              }
                            } on FormatException catch (e) {
                              return "La valeur doit être un nombre";
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: InputText(
                          placeholder: "TVA*",
                          icon: Icons.percent,
                          controller: ctrlVAT,
                          width: width,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Champs obligatoire";
                            }
                            try {
                              double valueDouble = double.parse(value);
                              if (valueDouble < 0.00) {
                                return "La TVA ne peut pas être négatif";
                              } else {
                                return null;
                              }
                            } on FormatException catch (e) {
                              return "La valeur doit être un nombre";
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
                InputSelected<PoliticalParty>(
                  width: width,
                  future: PartyService().getAllParty(),
                  validator: _validatorInputFieldNullOrEmpty,
                  items: [],
                  value: currentParty,
                  placeholder: "Parti politique*",
                  icon: Icons.group,
                  onChanged: (value) => currentParty = value,
                ),
                InputText(
                  placeholder: "Lien Twitch",
                  icon: Icons.ondemand_video_outlined,
                  controller: ctrlLinkTwitch,
                  width: width,
                ),
                InputText(
                  placeholder: "Lien Youtube",
                  icon: Icons.ondemand_video_outlined,
                  controller: ctrlLinkYoutube,
                  width: width,
                ),
                const SizedBox(height: 10),
                Button(
                  label: "Sauvegarder",
                  width: width,
                  pressedColor: Colors.lightBlue,
                  click: () => _saveMeeting(context),
                ),
                const SizedBox(height: 10),
                Button(
                  label: "Annuler",
                  width: width,
                  color: Colors.red,
                  pressedColor: Colors.redAccent,
                  click: () => NavigationNotification(MeetingsPage()).dispatch(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _saveMeeting(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        Meeting meeting = Meeting(
            id: -1,
            name: ctrlName.text,
            object: ctrlObject.text,
            description: ctrlDesc.text,
            dateStart: DateFormat("dd/MM/yyyy HH:mm").parse(ctrlDtStart.text),
            nbTime: double.parse(ctrlTime.text),
            addressStreet: ctrlAddress.text,
            townCodeInsee: currentTown!.codeInsee,
            nbPlace: int.parse(ctrlNbPlace.text),
            priceExcl: double.parse(ctrlPriceExcl.text),
            rateVAT: double.parse(ctrlVAT.text),
            idPoliticalParty: currentParty!.id!,
            linkTwitch: ctrlLinkTwitch.text,
            linkYoutube: ctrlLinkYoutube.text
        );
        await MeetingService().addMeeting(meeting);
        NavigationNotification(MeetingsPage()).dispatch(context);
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
      return "Champs obligatoire";
    } else {
      return null;
    }
  }

  String? _validatorInputFieldNullOrEmpty(dynamic value) {
    if (value == null) {
      return "Champs obligatoire";
    } else {
      return null;
    }
  }

  Widget _getDropdownTown(BuildContext context) {
    String placeholder = "Ville*";
    IconData icon = Icons.location_city;
    if (currentDepartment != null) {
      return InputSelected<Town>(
        future: GeoService().getTownsFromDept(currentDepartment!.code),
        items: [],
        value: currentTown,
        placeholder: placeholder,
        icon: Icons.location_city,
        validator: _validatorInputFieldNullOrEmpty,
        onChanged: (value) => currentTown = value,
      );
    } else {
      return InputText(
        placeholder: placeholder,
        icon: icon,
        isReadOnly: true,
      );
    }
  }
}
