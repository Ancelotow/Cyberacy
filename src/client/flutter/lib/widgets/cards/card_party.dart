import 'package:flutter/material.dart';
import '../../models/entities/political_party.dart';

class CardParty extends StatelessWidget {
  final PoliticalParty party;
  final double width;
  final double height;

  CardParty({
    Key? key,
    required this.party,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String name = (party.name == null) ? "- NONE -" : party.name!;
    return Container(
      width: width,
      height: height,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        color: Colors.greenAccent,
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
                  width: width - (width * 0.10),
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
