import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/entities/choice.dart';
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
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
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Icon(Icons.calendar_today),
                Text(
                  " Début : ${DateFormat("dd/MM/yyyy HH:mm").format(round.dateStart)} - Fin : ${DateFormat("dd/MM/yyyy HH:mm").format(round.dateEnd)}",
                  maxLines: 2,
                  overflow: TextOverflow.clip,
                  style: Theme.of(context).textTheme.bodyText1,
                )
              ],
            ),
            const SizedBox(height: 10),
            Expanded(child: _getListChoices(context))
          ],
        ),
      ),
    );
  }

  Widget _getListChoices(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: round.choices.map((e) => _getCardResult(context, e)).toList(),
      ),
    );
  }

  Widget _getCardResult(BuildContext context, Choice choice) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          color: Colors.grey,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                choice.name,
                style: const TextStyle(
                  color: Colors.black,
                  fontFamily: "HK-Nova",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
