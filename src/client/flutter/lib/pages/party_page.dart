// ignore_for_file: prefer_const_constructors

import 'package:bo_cyberacy/models/entities/political_party.dart';
import 'package:bo_cyberacy/models/services/party_service.dart';
import 'package:bo_cyberacy/pages/party/add_party_page.dart';
import 'package:bo_cyberacy/widgets/buttons/button_card.dart';
import 'package:bo_cyberacy/widgets/cards/card_party.dart';
import 'package:bo_cyberacy/widgets/draggable_target.dart';
import 'package:flutter/material.dart';
import '../widgets/cards/card_shimmer.dart';

class PartyPage extends StatefulWidget {
  final Function(PoliticalParty)? callbackAddWorkspace;

  PartyPage({
    Key? key,
    this.callbackAddWorkspace,
  }) : super(key: key);

  @override
  State<PartyPage> createState() => _PartyPageState();
}

class _PartyPageState extends State<PartyPage> {
  List<PoliticalParty> parties = [];
  bool isDragging = false;
  double _widthCard = 500;
  final double _heightCard = 120;

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    if (widthScreen <= 500) {
      _widthCard = widthScreen - 16;
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder(
        future: PartyService().getAllParty(),
        builder:
            (BuildContext context, AsyncSnapshot<List<PoliticalParty>> snapshot) {
          if (snapshot.hasData) {
            parties = snapshot.data!;
            return _getListParty(context);
          } else if (snapshot.hasError) {
            return _getPartyError();
          } else {
            return _getPartyLoader(context);
          }
        },
      ),
    );
  }

  Widget _getListParty(BuildContext context) {
    List<Widget> cards = [];
    cards.add(_getButtonAdd(context)); // Ajoute le bouton d'ajout
    if (parties != null) {
      cards.addAll(parties
          .map((e) => CardParty(
                party: e,
                dragStart: () => setState(() => isDragging = true),
                dragFinish: () => setState(() => isDragging = false),
                width: _widthCard,
                height: _heightCard,
              ))
          .toList());
    }
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Wrap(
        spacing: 10.0,
        runSpacing: 10.0,
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: cards,
      ),
    );
  }

  Widget _getPartyLoader(BuildContext context) {
    final List<Widget> cardLoad = List.filled(
      12,
      CardShimmer(width: _widthCard, height: _heightCard),
    );
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Wrap(
        spacing: 10.0,
        runSpacing: 10.0,
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
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

  Widget _getButtonAdd(BuildContext context) {
    return ButtonCard(
      icon: Icons.add_circle_outline,
      label: "Ajouter",
      width: _widthCard,
      height: _heightCard,
      color: Theme.of(context).highlightColor,
      onTap: () => Navigator.of(context).pushNamed(AddPartyPage.routeName),
    );
  }

}
