// ignore_for_file: prefer_const_constructors

import 'package:bo_cyberacy/models/entities/step.dart';
import 'package:bo_cyberacy/pages/manifestation/manifestation_details.dart';
import 'package:flutter/material.dart';
import '../../models/entities/manifestation.dart';
import '../map_manifestation.dart';

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
    List<StepManif> steps = (manifestation.steps == null) ? [] : manifestation.steps!;
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(ManifestationDetail.routeName, arguments: manifestation),
      child: ClipRRect(
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
                child: MapManifestation(steps: steps),
              ),
              Expanded(
                child: Center(
                  child:  Text(
                    name,
                    maxLines: 2,
                    overflow: TextOverflow.clip,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
