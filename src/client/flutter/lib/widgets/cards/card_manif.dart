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
    String name =
        (manifestation.name == null) ? "- NONE -" : manifestation.name!;
    List<StepManif> steps =
        (manifestation.steps == null) ? [] : manifestation.steps!;
    return Container(
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            blurRadius: 6,
            offset: Offset(1, 1), // Shadow position
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        child: SizedBox(
          width: width,
          height: height,
          child: Material(
            color: Theme.of(context).cardColor,
            child: InkWell(
              onTap: () => Navigator.of(context).pushNamed(
                ManifestationDetail.routeName,
                arguments: manifestation,
              ),
              highlightColor: Theme.of(context).highlightColor.withOpacity(0.4),
              child: Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: MapManifestation(steps: steps),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
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
        ),
      ),
    );
  }
}
