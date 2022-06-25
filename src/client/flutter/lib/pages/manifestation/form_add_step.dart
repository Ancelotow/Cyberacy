import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../models/entities/coordinates.dart';
import '../../models/entities/department.dart';
import '../../models/entities/town.dart';
import '../../models/enums/position_input.dart';
import '../../models/errors/api_service_error.dart';
import '../../models/services/geo_service.dart';
import '../../widgets/buttons/button.dart';
import '../../widgets/input_field/input_date.dart';
import '../../widgets/input_field/input_selected.dart';
import '../../widgets/input_field/input_text.dart';

class FormAddStep extends StatefulWidget {
  const FormAddStep({Key? key}) : super(key: key);

  @override
  State<FormAddStep> createState() => _FormAddStepState();
}

class _FormAddStepState extends State<FormAddStep> {
  final TextEditingController ctrlAddress = TextEditingController();
  final TextEditingController ctrlDateArrived = TextEditingController();
  final MapController mapController = MapController();
  Town? currentTown;
  Department? currentDepartment;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 5), (Timer t) => refreshMap());
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
                  Expanded(child: _getDropdownDepartment(context)),
                  SizedBox(width: 10),
                  Expanded(child: _getDropdownTown(context)),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Button(
              label: "Sauvegarder",
              width: width,
              isLoad: false,
              pressedColor: Colors.lightBlue,
              click: () => {},
            ),
            const SizedBox(height: 10),
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

  Widget _getDropdownDepartment(BuildContext context) {
    String placeholder = "Département";
    IconData icon = Icons.landscape;
    print(currentDepartment?.code);
    return FutureBuilder(
      future: GeoService().getDepartments(),
      builder:
          (BuildContext context, AsyncSnapshot<List<Department>> snapshot) {
        if (snapshot.hasData) {
          return InputSelected(
            items: snapshot.data!,
            value: currentDepartment,
            placeholder: placeholder,
            icon: icon,
            onChanged: (value) => setState(() => currentDepartment = value),
          );
        } else {
          return InputText(
            placeholder: placeholder,
            icon: icon,
            isReadOnly: true,
          );
        }
      },
    );
  }

  Widget _getDropdownTown(BuildContext context) {
    String placeholder = "Ville";
    IconData icon = Icons.location_city;
    if (currentDepartment != null) {
      return FutureBuilder(
        future: GeoService().getTownsFromDept(currentDepartment!.code),
        builder: (BuildContext context, AsyncSnapshot<List<Town>> snapshot) {
          if (snapshot.hasData) {
            return InputSelected(
              items: snapshot.data!,
              value: currentTown,
              placeholder: placeholder,
              icon: icon,
              onChanged: (value) {
                currentTown = value;
              },
            );
          } else {
            return InputText(
              placeholder: placeholder,
              icon: icon,
              isReadOnly: true,
            );
          }
        },
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
    if(currentTown != null) {
      try{
        MyCoordinates? coordinates = await GeoService().getCoordinates(ctrlAddress.text, currentTown!.zipCode);
        if(coordinates != null) {
          mapController.move(coordinates.getLatLng(), 17);
        }
      } on ApiServiceError catch (e) {
        print(e);
      }
    }
  }

}
