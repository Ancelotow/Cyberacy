import 'package:flutter/material.dart';
import '../../models/entities/political_party.dart';

class CardParty extends StatelessWidget {
  final PoliticalParty party;
  final double width;
  final double height;
  final Function()? dragStart;
  final Function()? dragFinish;

  CardParty({
    Key? key,
    required this.party,
    required this.width,
    required this.height,
    this.dragStart,
    this.dragFinish
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String name = (party.name == null) ? "- NONE -" : party.name!;
    return LongPressDraggable(
      onDragStarted: () => dragStart?.call(),
      onDraggableCanceled: (velocity, offset) => dragFinish?.call(),
      onDragEnd: (details) => dragFinish?.call(),
      onDragCompleted: () => dragFinish?.call(),
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
        )
      ),
      childWhenDragging: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          color: Theme.of(context).unselectedWidgetColor,
        ),
      ),
      data: party,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          color: Theme.of(context).cardColor,
          boxShadow: const [
            BoxShadow(
              color: Colors.black,
              blurRadius: 10,
              offset: Offset(3, 3), // Shadow position
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: width - 16,
                    child: Text(
                      name,
                      maxLines: 2,
                      overflow: TextOverflow.clip,
                      style: Theme.of(context).textTheme.headline2,
                    ),
                  ),
                  Text(
                    "SIREN : ${party.siren}",
                    style: Theme.of(context).textTheme.headline3,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

}
