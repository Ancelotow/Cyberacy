// ignore_for_file: prefer_const_constructors

import 'package:bo_cyberacy/models/entities/manifestation.dart';
import 'package:bo_cyberacy/models/services/manifestation_service.dart';
import 'package:bo_cyberacy/pages/manifestation/add_manifestation.dart';
import 'package:bo_cyberacy/widgets/cards/card_manif.dart';
import 'package:flutter/material.dart';

import '../widgets/buttons/button_card.dart';
import '../widgets/cards/card_shimmer.dart';

class ManifestationPage extends StatelessWidget {
  double _widthCard = 500;
  final double _heightCard = 200;
  
  ManifestationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    if(widthScreen <= 500) {
      _widthCard = widthScreen - 16;
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder(
        future: ManifService().getAllManifestations(),
        builder: (BuildContext context,
            AsyncSnapshot<List<Manifestation>> snapshot) {
          if (snapshot.hasData) {
            return _getListManifs(snapshot.data, context);
          } else if (snapshot.hasError) {
            return _getManifError();
          } else {
            return _getManifLoader(context);
          }
        },
      ),
    );
  }

  Widget _getListManifs(List<Manifestation>? manifs, BuildContext context) {
    List<Widget> cards = [];
    cards.add(ButtonCard(
      icon: Icons.add_circle_outline,
      label: "Ajouter",
      width: _widthCard,
      height: _heightCard,
      color: Colors.cyanAccent,
      onTap: () => Navigator.of(context).pushNamed(AddManifestationPage.routeName),
    ));
    if (manifs != null) {
      cards.addAll(manifs
          .map((e) => CardManif(
        manifestation: e,
        width: _widthCard,
        height: _heightCard,
      ))
          .toList());
    }
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          alignment: WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.start,
          children: cards,
        ),
      ),
    );
  }

  Widget _getManifLoader(BuildContext context) {
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

  Widget _getManifError() {
    return Icon(
      Icons.error_outline,
      color: Colors.red,
      size: 60,
    );
  }
  
}
