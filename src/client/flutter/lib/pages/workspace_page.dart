import 'package:bo_cyberacy/models/entities/manifestation.dart';
import 'package:bo_cyberacy/widgets/cards/card_manif.dart';
import 'package:bo_cyberacy/widgets/cards/card_party.dart';
import 'package:flutter/material.dart';

import '../models/entities/political_party.dart';

class WorkspacePage extends StatelessWidget {
  List<PoliticalParty> parties = [];
  List<Manifestation> manifs = [];
  final double _widthCard = 500;
  final double _heightCardParty = 120;
  final double _heightCardManif = 200;

  WorkspacePage({
    Key? key,
    required this.parties,
    required this.manifs
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _getTitle("Parties politiques", context),
          _getPoliticalParties(context),
          SizedBox(height: 50),
          _getTitle("Manifestations", context),
          _getManifestations(context),
        ],
      ),
    );
  }

  Widget _getPoliticalParties(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: parties
            .map((e) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CardParty(
                      party: e, width: _widthCard, height: _heightCardParty),
                ))
            .toList(),
      ),
    );
  }

  Widget _getManifestations(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: manifs
            .map((e) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CardManif(
                      manifestation: e, width: _widthCard, height: _heightCardManif),
                ))
            .toList(),
      ),
    );
  }

  Widget _getTitle(String title, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        title,
        textAlign: TextAlign.start,
        style: Theme.of(context).textTheme.headline1,
      ),
    );
  }
}
