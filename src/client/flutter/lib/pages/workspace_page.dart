import 'package:bo_cyberacy/models/entities/manifestation.dart';
import 'package:bo_cyberacy/widgets/cards/card_manif.dart';
import 'package:bo_cyberacy/widgets/cards/card_party.dart';
import 'package:flutter/material.dart';

import '../models/entities/political_party.dart';
import '../widgets/draggable_target.dart';

class WorkspacePage extends StatefulWidget {
  List<PoliticalParty> parties = [];
  List<Manifestation> manifs = [];
  final Function(Manifestation)? callbackRemoveManif;
  final Function(PoliticalParty)? callbackRemoveParty;

  WorkspacePage({
    Key? key,
    required this.parties,
    required this.manifs,
    this.callbackRemoveManif,
    this.callbackRemoveParty,
  }) : super(key: key);

  @override
  State<WorkspacePage> createState() => _WorkspacePageState();
}

class _WorkspacePageState extends State<WorkspacePage> {
  bool isDraggingParty = false;
  bool isDraggingManif = false;
  final double _widthCard = 500;
  final double _heightCardParty = 120;
  final double _heightCardManif = 200;

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Stack(
        children: [
          _getBody(context),
          SizedBox(
            height: MediaQuery.of(context).size.height - 100,
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

  Widget _getBody(BuildContext context) {
    if (widget.parties.isEmpty && widget.manifs.isEmpty) {
      return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.laptop_chromebook_rounded,
              color: Theme.of(context).cardColor,
              size: 400,
            ),
            Text(
              "Votre espace de travail est vide.",
              style: TextStyle(
                color: Theme.of(context).cardColor,
                fontSize: 30,
                fontWeight: FontWeight.bold
              ),
            )
          ],
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _getPoliticalParties(context),
        SizedBox(height: 50),
        _getManifestations(context),
      ],
    );
  }

  Widget _getPoliticalParties(BuildContext context) {
    if (widget.parties.isEmpty) {
      return Container();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _getTitle("Parties politiques", context),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: widget.parties
                .map((e) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CardParty(
                        party: e,
                        dragStart: () => setState(() => isDraggingParty = true),
                        dragFinish: () =>
                            setState(() => isDraggingParty = false),
                        width: _widthCard,
                        height: _heightCardParty,
                      ),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _getManifestations(BuildContext context) {
    if (widget.manifs.isEmpty) {
      return Container();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _getTitle("Manifestations", context),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: widget.manifs
                .map((e) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CardManif(
                        manifestation: e,
                        dragStart: () => setState(() => isDraggingManif = true),
                        dragFinish: () =>
                            setState(() => isDraggingManif = false),
                        width: _widthCard,
                        height: _heightCardManif,
                      ),
                    ))
                .toList(),
          ),
        ),
      ],
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

  Widget? _getTargetDraggable(BuildContext context) {
    if (isDraggingParty) {
      return DraggableTarget<PoliticalParty>(
        label: "Retirer partie",
        callback: widget.callbackRemoveParty,
        color: Colors.redAccent,
        colorEnter: Colors.red,
        icon: const Icon(Icons.delete_forever, size: 30),
      );
    } else if (isDraggingManif) {
      return DraggableTarget<Manifestation>(
        label: "Retirer manifestation",
        callback: widget.callbackRemoveManif,
        color: Colors.redAccent,
        colorEnter: Colors.red,
        icon: const Icon(Icons.delete_forever, size: 30),
      );
    } else {
      return null;
    }
  }
}
