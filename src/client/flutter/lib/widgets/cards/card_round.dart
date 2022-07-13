import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/entities/round.dart';

class CardRound extends StatelessWidget {
  final Round round;

  const CardRound({
    Key? key,
    required this.round,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      height: 360,
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              round.name,
              maxLines: 2,
              overflow: TextOverflow.clip,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: "HK-Nova",
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Icon(Icons.calendar_today),
                Text(
                  "Début : ${DateFormat("dd/MM/yyyy HH:mm").format(round.dateStart)}",
                  maxLines: 2,
                  overflow: TextOverflow.clip,
                  style: Theme.of(context).textTheme.bodyText1,
                )
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.calendar_today),
                Text(
                  "Fin : ${DateFormat("dd/MM/yyyy HH:mm").format(round.dateEnd)}",
                  maxLines: 2,
                  overflow: TextOverflow.clip,
                  style: Theme.of(context).textTheme.bodyText1,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
