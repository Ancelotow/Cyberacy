import 'package:bo_cyberacy/models/notifications/remove_notification.dart';
import 'package:bo_cyberacy/widgets/buttons/button_card.dart';
import 'package:flutter/material.dart';

import '../../models/entities/choice.dart';

class CardChoice extends StatelessWidget {
  final Choice choice;
  final double width;
  final double height;
  final bool canEdit;

  const CardChoice(
      {Key? key,
      required this.choice,
      required this.width,
      required this.height,
      this.canEdit = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        color: Theme.of(context).cardColor,
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            blurRadius: 6,
            offset: Offset(1, 1), // Shadow position
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Container(
                      width: 15,
                      height: 15,
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8.0)),
                        color: choice.getColor(),
                      ),),
                ),
                Expanded(
                  child: SizedBox(
                    child: Text(
                      choice.name,
                      maxLines: 2,
                      overflow: TextOverflow.clip,
                      style: Theme.of(context).textTheme.headline2,
                    ),
                  ),
                ),
                _getPopupMenu(context),
              ],
            ),
            Text(
              choice.candidate,
              style: Theme.of(context).textTheme.headline3,
            )
          ],
        ),
      ),
    );
  }

  Widget _getPopupMenu(BuildContext context) {
    if (canEdit) {
      return PopupMenuButton(
        padding: EdgeInsets.zero,
        itemBuilder: (BuildContext contextPopup) {
          return [
            PopupMenuItem<String>(
              value: "Supprimer",
              child: const Text("Supprimer"),
              onTap: () => RemoveNotification(choice).dispatch(context),
            )
          ];
        },
      );
    } else {
      return Container();
    }
  }
}
