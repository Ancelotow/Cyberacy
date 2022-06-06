// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import '../../models/entities/manifestation.dart';
import 'package:latlong2/latlong.dart';

class CardManif extends StatelessWidget {
  final Manifestation manifestation;
  final double width;
  final double height;

  CardManif({
    Key? key,
    required this.manifestation,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String name = (manifestation.name == null) ? "- NONE -" : manifestation.name!;
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
        bottomRight: Radius.circular(10),
        bottomLeft: Radius.circular(10),
      ),
      child: Container(
        width: width,
        height: height,
        color: Colors.cyanAccent,
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: FlutterMap(
                mapController: MapController(),
                options: MapOptions(
                  zoom: 0,
                  center: LatLng(48.8538762, 2.3775986),
                ),
                layers: [
                  TileLayerOptions(
                      urlTemplate:
                          "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                      subdomains: ['a', 'b', 'c']),
                  MarkerLayerOptions(
                    markers: [
                      Marker(
                        width: 80.0,
                        height: 80.0,
                        point: LatLng(48.8538763, 2.3775986),
                        builder: (ctx) => Container(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child:  Text(
                  name,
                  maxLines: 2,
                  overflow: TextOverflow.clip,
                  style: Theme.of(context).textTheme.headline2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
