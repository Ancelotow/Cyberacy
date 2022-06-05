// ignore_for_file: prefer_const_constructors

import 'package:bo_cyberacy/models/entities/political_party.dart';
import 'package:bo_cyberacy/models/services/party_service.dart';
import 'package:bo_cyberacy/pages/party/info_party_page.dart';
import 'package:bo_cyberacy/widgets/buttons/button_card.dart';
import 'package:bo_cyberacy/widgets/card_party.dart';
import 'package:flutter/material.dart';

class PartyPage extends StatelessWidget {
  const PartyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder(
        future: PartyService().getAllParty(),
        builder: (BuildContext context,
            AsyncSnapshot<List<PoliticalParty>> snapshot) {
          if (snapshot.hasData) {
            return getListParty(snapshot.data, context);
          } else if (snapshot.hasError) {
            return getPartyError();
          } else {
            return getPartyLoader(context);
          }
        },
      ),
    );
  }

  Widget getListParty(List<PoliticalParty>? parties, BuildContext context) {
    List<Widget> cards = [];
    cards.add(ButtonCard(
      icon: Icons.add_circle_outline,
      label: "Ajouter",
      color: Colors.greenAccent,
      onTap: () => Navigator.of(context).pushNamed(InfoPartyPage.routeName),
    ));
    if (parties != null) {
      cards.addAll(parties.map((e) => CardParty(party: e)).toList());
    }
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Wrap(
        spacing: 8.0,
        runSpacing: 4.0,
        alignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.start,
        children: cards,
      ),
    );
  }

  Widget getPartyLoader(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 60,
      child: CircularProgressIndicator(
        color: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget getPartyError() {
    return Icon(
      Icons.error_outline,
      color: Colors.red,
      size: 60,
    );
  }
}
