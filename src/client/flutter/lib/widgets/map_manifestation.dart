// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/entities/step.dart';

class MapManifestation extends StatelessWidget {
  final List<StepManif> steps;
  double latStart = 0.0;
  double lngStart = 0.0;
  double zoom = 0.0;

  MapManifestation({
    Key? key,
    required this.steps,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _initValues();
    return FlutterMap(
      mapController: MapController(),
      options: MapOptions(
        zoom: zoom,
        center: LatLng(latStart, lngStart),
      ),
      layers: [
        TileLayerOptions(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c']),
        MarkerLayerOptions(
          markers: _getListMarkers(),
        ),
      ],
    );
  }

  void _initValues() {
    List<StepManif> stepStart =
        steps.where((stp) => stp.idTypeStep == 1).toList();
    if (stepStart.isNotEmpty) {
      latStart =
          (stepStart[0].latitude != null) ? stepStart[0].latitude! : 0.00;
      lngStart =
          (stepStart[0].longitude != null) ? stepStart[0].longitude! : 0.00;
      zoom = (latStart == 0.0 || lngStart == 0.0) ? 0 : 13;
    }
  }

  List<Marker> _getListMarkers() {
    steps.sort((a, b) => (a.idTypeStep ?? 0) - (b.idTypeStep ?? 0));
    List<Marker> markers = [];
    for (StepManif step in steps) {
      markers.add(Marker(
        width: 20,
        height: 20,
        point: LatLng(step.latitude ?? 0.00, step.longitude ?? 0.00),
        builder: (ctx) => _getPoint(steps.indexOf(step), step.idTypeStep),
      ));
    }
    return markers;
  }

  Widget _getPoint(int index, int? typeStep) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: _getColorPoint(typeStep),
      ),
      child: Center(
        child: Text(
          (index + 1).toString(),
          style: TextStyle(
            color: Colors.black,
            fontFamily: "HK-Nova",
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  Color _getColorPoint(int? typeStep) {
    if (typeStep == 1) {
      return Colors.yellow;
    } else if (typeStep == 3) {
      return Colors.red;
    } else {
      return Colors.orangeAccent;
    }
  }
}
