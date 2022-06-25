import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import '../../models/entities/department.dart';
import '../../models/entities/town.dart';
import '../../models/enums/position_input.dart';
import '../../models/services/geo_service.dart';
import '../../widgets/buttons/button.dart';
import '../../widgets/input_field/input_date.dart';
import '../../widgets/input_field/input_selected.dart';
import '../../widgets/input_field/input_text.dart';

class FormAddStep extends StatelessWidget {
  final TextEditingController ctrlAddress = TextEditingController();
  final TextEditingController ctrlDateArrived = TextEditingController();
  final MapController mapController = MapController();
  Town? currentTown;
  Department? currentDepartment;
  Timer? timer;

  FormAddStep({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = 500;
    return Center(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InputText(
              placeholder: "Adresse (n°voie, rue)",
              position: PositionInput.start,
              width: width,
              controller: ctrlAddress,
            ),
            InputDate(
              placeholder: "Date d'arrivé",
              position: PositionInput.middle,
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
            onChanged: (value) {
              currentDepartment = value;
            },
          );
        } else {
          return InputText(
              placeholder: placeholder, icon: icon, isReadOnly: true);
        }
      },
    );
  }

  Widget _getDropdownTown(BuildContext context) {
    String placeholder = "Ville";
    IconData icon = Icons.location_city;
    return FutureBuilder(
      future: GeoService().getTownsFromDept("94"),
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
              placeholder: placeholder, icon: icon, isReadOnly: true);
        }
      },
    );
  }
}
