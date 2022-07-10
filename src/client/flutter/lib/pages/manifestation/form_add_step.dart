import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../models/dialog/alert_normal.dart';
import '../../models/entities/coordinates.dart';
import '../../models/entities/department.dart';
import '../../models/entities/step.dart';
import '../../models/entities/town.dart';
import '../../models/entities/type_step.dart';
import '../../models/errors/api_service_error.dart';
import '../../models/errors/invalid_form_error.dart';
import '../../models/notifications/save_notification.dart';
import '../../models/services/geo_service.dart';
import '../../models/services/manifestation_service.dart';
import '../../models/services/ref_service.dart';
import '../../widgets/buttons/button.dart';
import '../../widgets/input_field/input_date.dart';
import '../../widgets/input_field/input_selected.dart';
import '../../widgets/input_field/input_text.dart';

class FormAddStep extends StatefulWidget {
  final int idManifesation;

  const FormAddStep({
    Key? key,
    required this.idManifesation,
  }) : super(key: key);

  @override
  State<FormAddStep> createState() => _FormAddStepState();
}

class _FormAddStepState extends State<FormAddStep> {
  final TextEditingController ctrlAddress = TextEditingController();
  final TextEditingController ctrlDateArrived = TextEditingController();
  final MapController mapController = MapController();
  Town? currentTown;
  Department? currentDepartment;
  TypeStep? currentType;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer =
        Timer.periodic(const Duration(seconds: 15), (Timer t) => refreshMap());
  }

  @override
  Widget build(BuildContext context) {
    double width = 500;
    return Center(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: Container(
                width: width,
                height: 200,
                child: FlutterMap(
                  key: ValueKey(MediaQuery.of(context).orientation),
                  mapController: mapController,
                  options: MapOptions(
                    zoom: 11,
                    center: LatLng(48.866667, 2.333333),
                  ),
                  layers: [
                    TileLayerOptions(
                      urlTemplate:
                          "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                      subdomains: ['a', 'b', 'c'],
                    ),
                  ],
                ),
              ),
            ),
            InputText(
              placeholder: "Adresse (n°voie, rue)",
              icon: Icons.streetview,
              width: width,
              controller: ctrlAddress,
            ),
            InputDate(
              placeholder: "Date d'arrivé",
              icon: Icons.calendar_today,
              width: width,
              controller: ctrlDateArrived,
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
                      onChanged: (value) =>
                          setState(() => currentDepartment = value),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(child: _getDropdownTown(context)),
                ],
              ),
            ),
            InputSelected<TypeStep>(
              future: RefService().getAllTypeStep(),
              items: [],
              value: currentType,
              placeholder: "Type d'étape",
              icon: Icons.where_to_vote,
              width: width,
              onChanged: (value) => currentType = value,
            ),
            const SizedBox(height: 10),
            Button(
              label: "Sauvegarder",
              width: width,
              isLoad: false,
              pressedColor: Colors.lightBlue,
              click: () => _addStep(context),
            ),
            const SizedBox(height: 10),
            Button(
              label: "Annuler",
              width: width,
              color: Colors.red,
              pressedColor: Colors.redAccent,
              click: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getDropdownTown(BuildContext context) {
    String placeholder = "Ville";
    IconData icon = Icons.location_city;
    if (currentDepartment != null) {
      return InputSelected<Town>(
        future: GeoService().getTownsFromDept(currentDepartment!.code),
        items: [],
        value: currentTown,
        placeholder: "Ville",
        icon: Icons.location_city,
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

  Future<void> refreshMap() async {
    if (currentTown != null) {
      try {
        MyCoordinates? coordinates = await GeoService()
            .getCoordinates(ctrlAddress.text, currentTown!.zipCode);
        if (coordinates != null) {
          mapController.move(coordinates.getLatLng(), 17);
        }
      } on ApiServiceError catch (e) {
        print(e);
      }
    }
  }

  Future<void> _addStep(BuildContext context) async {
    try {
      _formIsValid();
      StepManif step = StepManif(
        idManifestation: widget.idManifesation,
        addressStreet: ctrlAddress.text,
        dateArrived: DateFormat("dd/MM/yyyy HH:mm").parse(ctrlDateArrived.text),
        townCodeInsee: currentTown!.codeInsee,
        idTypeStep: currentType!.id,
      );
      await ManifService().addStep(step);
      SaveNotification(step).dispatch(context);
      timer?.cancel();
      Navigator.of(context).pop();
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
    if (ctrlAddress.text.isEmpty) {
      throw InvalidFormError("Le champ \"Adresse\" est obligatoire");
    } else if (ctrlDateArrived.text.isEmpty) {
      throw InvalidFormError("Le champ \"Date d'arrivée'\" est obligatoire");
    } else if (currentTown == null) {
      throw InvalidFormError("Le champ \"Ville\" est obligatoire");
    } else if (currentType == null) {
      throw InvalidFormError("Le champ \"Type d'étapes\" est obligatoire");
    }
  }
}
