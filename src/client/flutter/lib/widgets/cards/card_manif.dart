// ignore_for_file: prefer_const_constructors
import 'package:intl/intl.dart';
import 'package:bo_cyberacy/models/entities/step.dart';
import 'package:bo_cyberacy/pages/manifestation/manifestation_details.dart';
import 'package:flutter/material.dart';
import '../../models/entities/manifestation.dart';
import '../../models/notifications/navigation_notification.dart';
import '../map_manifestation.dart';
import 'card_state_progress.dart';

class CardManif extends StatelessWidget {
  final Manifestation manifestation;
  final double width;
  final double height;
  final format = new DateFormat('dd/MM/yyyy HH:mm');

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
          height: 300,
          child: Material(
            color: Theme.of(context).cardColor,
            child: InkWell(
              onTap: () => NavigationNotification(
                ManifestationDetail(
                  manifestation: manifestation,
                ),
              ).dispatch(context),
              highlightColor: Theme.of(context).highlightColor.withOpacity(0.4),
              child: Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: MapManifestation(steps: steps),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Center(
                            child: Text(
                              name,
                              maxLines: 2,
                              overflow: TextOverflow.clip,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headline2,
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Icon(Icons.calendar_today),
                                    SizedBox(width: 5),
                                    Text(
                                      format.format(manifestation.dateStart!),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 5),
                              Expanded(
                                child: CardStateProgress(
                                  stateProgress:
                                      manifestation.getStateProgress(),
                                ),
                              )
                            ],
                          )
                        ],
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
