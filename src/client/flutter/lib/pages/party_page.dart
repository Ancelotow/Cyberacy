// ignore_for_file: prefer_const_constructors

import 'package:bo_cyberacy/models/entities/political_party.dart';
import 'package:bo_cyberacy/models/services/party_service.dart';
import 'package:bo_cyberacy/pages/party/add_party_page.dart';
import 'package:bo_cyberacy/widgets/buttons/button_card.dart';
import 'package:bo_cyberacy/widgets/cards/card_party.dart';
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
  bool apiIsCalled = false;
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
      child: Stack(
        children: [
          _getListBuilder(context),
          SizedBox(
            height: MediaQuery.of(context).size.height - 80,
            width: widthScreen,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: _getTargetDraggable(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getListBuilder(BuildContext context) {
    if (!apiIsCalled) {
      return FutureBuilder(
        future: PartyService().getAllParty(),
        builder: (BuildContext context,
            AsyncSnapshot<List<PoliticalParty>> snapshot) {
          if (snapshot.hasData) {
            apiIsCalled = true;
            parties = snapshot.data!;
            return _getListParty(context);
          } else if (snapshot.hasError) {
            apiIsCalled = true;
            return _getPartyError();
          } else {
            return _getPartyLoader(context);
          }
        },
      );
    } else {
      return _getListParty(context);
    }
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
        alignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.start,
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

  Widget _getButtonAdd(BuildContext context) {
    return ButtonCard(
      icon: Icons.add_circle_outline,
      label: "Ajouter",
      width: _widthCard,
      height: _heightCard,
      color: Colors.greenAccent,
      onTap: () => Navigator.of(context).pushNamed(AddPartyPage.routeName),
    );
  }

  Widget? _getTargetDraggable(BuildContext context) {
    if (!isDragging) {
      return null;
    }
    return DragTarget<PoliticalParty>(
      onAccept: (value) => widget.callbackAddWorkspace?.call(value),
      builder: (context, candidates, rejects) {
        return Container(
          width: 300,
          height: 300,
          decoration: BoxDecoration(
              color: Color.fromARGB(255, 194, 194, 194),
              shape: BoxShape.circle),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Espace de travaille",
                maxLines: 2,
                overflow: TextOverflow.clip,
                style: Theme.of(context).textTheme.headline2,
              ),
              Icon(
                Icons.add_circle_outline,
                color: Colors.black,
                size: 30,
              )
            ],
          ),
        );
      },
    );
  }
}
