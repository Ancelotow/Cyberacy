// ignore_for_file: prefer_const_constructors

import 'package:bo_cyberacy/models/entities/political_party.dart';
import 'package:bo_cyberacy/models/services/party_service.dart';
import 'package:bo_cyberacy/pages/party/add_party_page.dart';
import 'package:bo_cyberacy/widgets/buttons/button_card.dart';
import 'package:bo_cyberacy/widgets/cards/card_party.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PartyPage extends StatelessWidget {
  final double _widthCard = 500;
  final double _heightCard = 120;

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
            return _getListParty(snapshot.data, context);
          } else if (snapshot.hasError) {
            return _getPartyError();
          } else {
            return _getPartyLoader(context);
          }
        },
      ),
    );
  }

  Widget _getListParty(List<PoliticalParty>? parties, BuildContext context) {
    List<Widget> cards = [];
    cards.add(ButtonCard(
      icon: Icons.add_circle_outline,
      label: "Ajouter",
      width: _widthCard,
      height: _heightCard,
      color: Colors.greenAccent,
      onTap: () => Navigator.of(context).pushNamed(AddPartyPage.routeName),
    ));
    if (parties != null) {
      cards.addAll(parties
          .map(
            (e) => CardParty(
              party: e,
              width: _widthCard,
              height: _heightCard,
            ),
          )
          .toList());
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

  Widget _getPartyLoader(BuildContext context) {
    final List<Widget> cardLoad = List.filled(
      10,
      Shimmer.fromColors(
        highlightColor: Color.fromARGB(255, 76, 89, 150),
        baseColor: Color.fromARGB(121, 210, 209, 209),
        child: Container(
          width: _widthCard,
          height: _heightCard,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            color: Colors.greenAccent,
          ),
        ),
      ),
    );
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Wrap(
        spacing: 8.0,
        runSpacing: 4.0,
        alignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.start,
        children: cardLoad,
      ),
    );
  }

  Widget _getPartyError() {
    return Icon(
      Icons.error_outline,
      color: Colors.red,
      size: 60,
    );
  }
}
