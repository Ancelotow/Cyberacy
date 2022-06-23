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
  final Function()? dragStart;
  final Function()? dragFinish;

  CardManif(
      {Key? key,
      required this.manifestation,
      required this.width,
      required this.height,
      this.dragFinish,
      this.dragStart})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String name =
        (manifestation.name == null) ? "- NONE -" : manifestation.name!;
    List<StepManif> steps =
        (manifestation.steps == null) ? [] : manifestation.steps!;
    return LongPressDraggable(
      data: manifestation,
      onDragStarted: () => dragStart?.call(),
      onDraggableCanceled: (velocity, offset) => dragFinish?.call(),
      onDragEnd: (details) => dragFinish?.call(),
      onDragCompleted: () => dragFinish?.call(),
      childWhenDragging: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          color: Theme.of(context).unselectedWidgetColor,
        ),
      ),
      feedback: Container(
          width: width / 2,
          height: height / 2,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            color: Theme.of(context).accentColor.withOpacity(0.5),
          ),
          child: Center(
            child: Text(
              name,
              maxLines: 2,
              overflow: TextOverflow.clip,
              style: Theme.of(context).textTheme.bodyText2,
            ),
          )),
      child: GestureDetector(
        onTap: () => Navigator.of(context)
            .pushNamed(ManifestationDetail.routeName, arguments: manifestation),
        child: Container(
          decoration: BoxDecoration(boxShadow: const [
            BoxShadow(
              color: Color(0x54000000),
              spreadRadius: 4,
              blurRadius: 20,
            ),
          ]),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            child: Container(
              width: width,
              height: height,
              color: Theme.of(context).cardColor,
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
