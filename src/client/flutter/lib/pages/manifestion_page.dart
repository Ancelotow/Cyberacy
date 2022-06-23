// ignore_for_file: prefer_const_constructors

import 'package:bo_cyberacy/models/entities/manifestation.dart';
import 'package:bo_cyberacy/models/services/manifestation_service.dart';
import 'package:bo_cyberacy/pages/manifestation/add_manifestation.dart';
import 'package:bo_cyberacy/widgets/cards/card_manif.dart';
import 'package:flutter/material.dart';

import '../widgets/buttons/button_card.dart';
import '../widgets/cards/card_shimmer.dart';
import '../widgets/draggable_target.dart';

class ManifestationPage extends StatefulWidget {
  final Function(Manifestation)? callbackAddWorkspace;

  ManifestationPage({
    Key? key,
    this.callbackAddWorkspace,
  }) : super(key: key);

  @override
  State<ManifestationPage> createState() => _ManifestationPageState();
}

class _ManifestationPageState extends State<ManifestationPage> {
  List<Manifestation> manifs = [];
  bool isDragging = false;
  double _widthCard = 500;
  final double _heightCard = 200;

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
    return FutureBuilder(
      future: ManifService().getAllManifestations(),
      builder: (BuildContext context,
          AsyncSnapshot<List<Manifestation>> snapshot) {
        if (snapshot.hasData) {
          manifs = snapshot.data!;
          return _getListManifs(context);
        } else if (snapshot.hasError) {
          return _getManifError();
        } else {
          return _getManifLoader(context);
        }
      },
    );
  }

  Widget _getListManifs(BuildContext context) {
    List<Widget> cards = [];
    cards.add(_getButtonAdd(context));
    if (manifs != null) {
      cards.addAll(manifs
          .map((e) => CardManif(
                manifestation: e,
                dragStart: () => setState(() => isDragging = true),
                dragFinish: () => setState(() => isDragging = false),
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
          spacing: 10.0,
          runSpacing: 10.0,
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

  Widget? _getTargetDraggable(BuildContext context) {
    if (!isDragging) {
      return null;
    }
    return DraggableTarget(
      label: "Espace de travaille",
      callback: widget.callbackAddWorkspace,
      color: Colors.greenAccent,
      colorEnter: Colors.green,
      icon: Icon(
        Icons.add_circle_outline,
        size: 30,
      ),
    );
  }

  Widget _getButtonAdd(BuildContext context) {
    return ButtonCard(
      icon: Icons.add_circle_outline,
      label: "Ajouter",
      width: _widthCard,
      height: _heightCard,
      color: Colors.cyanAccent,
      onTap: () =>
          Navigator.of(context).pushNamed(AddManifestationPage.routeName),
    );
  }
}
