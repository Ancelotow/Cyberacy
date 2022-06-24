import 'package:flutter/material.dart';
import '../../models/entities/political_party.dart';

class CardParty extends StatelessWidget {
  final PoliticalParty party;
  final double width;
  final double height;
  final Function()? dragStart;
  final Function()? dragFinish;

  CardParty(
      {Key? key,
      required this.party,
      required this.width,
      required this.height,
      this.dragStart,
      this.dragFinish})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String name = (party.name == null) ? "- NONE -" : party.name!;
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
    );
  }
}
