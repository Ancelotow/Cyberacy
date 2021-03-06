import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/dialog/alert_normal.dart';
import '../../models/dialog/alert_yes_no.dart';
import '../../models/entities/step.dart';
import '../../models/errors/api_service_error.dart';
import '../../models/notifications/save_notification.dart';
import '../../models/notifications/step_notification.dart';
import '../../models/services/manifestation_service.dart';

class CardStep extends StatelessWidget with ChangeNotifier {
  final StepManif step;
  final int index;

  CardStep({Key? key, required this.step, this.index = 0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).highlightColor.withOpacity(0.50),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => StepNotification(step).dispatch(context),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                      color: _getColorCard(step.idTypeStep),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(5.00))),
                  child: Text(
                    "$index",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black,
                      fontFamily: "HK-Nova",
                      fontSize: 20,
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 6,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${step.addressStreet}",
                        overflow: TextOverflow.clip,
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      const SizedBox(height: 5),
                      SizedBox(
                        child: Text(
                          "${step.townZipCode}, ${step.town}",
                          overflow: TextOverflow.clip,
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Icon(
                        Icons.calendar_month,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      DateFormat("dd/MM/yyyy\nHH:mm").format(step.dateArrived!),
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 40,
                child: Center(
                  child: PopupMenuButton(
                    padding: EdgeInsets.zero,
                    itemBuilder: (BuildContext contextPopup) {
                      return [
                        PopupMenuItem<String>(
                          value: "Supprimer",
                          child: const Text("Supprimer"),
                          onTap: () => Future.delayed(
                            const Duration(seconds: 0),
                            () => AlertYesNo(
                              title: "Supprimer l'??tape n??$index",
                              message:
                                  "Souhaitez-vous vraiment supprimer l'??tape $index ?",
                              labelButtonNo: "Non",
                              labelButtonYes: "Supprimer",
                              context: context,
                              callback: () async {
                                try{
                                  await ManifService().deleteStep(step.id!);
                                  SaveNotification(step).dispatch(context);
                                  Navigator.of(context).pop();
                                } on ApiServiceError catch(e) {
                                  AlertNormal(
                                    title: "Echec de la suppression",
                                    message: e.responseHttp.body,
                                    labelButton: "R??ssayer",
                                    context: context,
                                  ).show();
                                }
                              },
                            ).show(),
                          ),
                        )
                      ];
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Color _getColorCard(int? typeStep) {
    if (typeStep == 1) {
      return Colors.yellow;
    } else if (typeStep == 3) {
      return Colors.red;
    } else {
      return Colors.orangeAccent;
    }
  }
}
