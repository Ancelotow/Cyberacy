import 'package:flutter/material.dart';

import '../models/entities/political_party.dart';

class CardParty extends StatelessWidget {

  PoliticalParty party;

  CardParty({Key? key, required this.party}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50, height: 50, color: Theme.of(context).primaryColor,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
    );
  }
}
