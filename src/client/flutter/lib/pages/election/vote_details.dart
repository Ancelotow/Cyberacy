import 'package:bo_cyberacy/widgets/cards/card_choice.dart';
import 'package:bo_cyberacy/widgets/cards/card_round.dart';
import 'package:flutter/material.dart';

import '../../models/entities/vote.dart';
import '../../models/notifications/navigation_notification.dart';
import '../../models/services/vote_service.dart';
import '../../widgets/buttons/button_card.dart';
import '../../widgets/info_error.dart';
import '../party/add_party_page.dart';

class VoteDetailsPage extends StatelessWidget {
  final int idVote;
  Vote? vote;

  final double _widthCard = 500;
  final double _heightCard = 120;

  VoteDetailsPage({
    Key? key,
    required this.idVote,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: FutureBuilder(
        future: VoteService().getVoteById(idVote),
        builder: (BuildContext context, AsyncSnapshot<Vote> snapshot) {
          if (snapshot.hasData) {
            vote = snapshot.data;
            return _getBody(context);
          } else if (snapshot.hasError) {
            return InfoError(error: snapshot.error as Error);
          } else {
            return const Center(
              child: SizedBox(
                width: 100,
                height: 100,
                child: CircularProgressIndicator(
                  strokeWidth: 7.0,
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _getBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            vote!.name,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline1,
          ),
        ),
        Expanded(child: _getChoices(context)),
        Expanded(child: _getRounds(context)),
      ],
    );
  }

  Widget _getChoices(BuildContext context) {
    List<Widget> cards = [];
    cards.add(_getButtonAdd(context));
    cards.addAll(vote!.choices
        .map((e) => CardChoice(
      choice: e,
      width: _widthCard,
      height: _heightCard,
    )).toList());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Liste des choix :",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline3,
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10.0,
          runSpacing: 10.0,
          children: cards,
        ),
      ],
    );
  }

  Widget _getRounds(BuildContext context) {
    List<Widget> cards = [];
    cards.add(_getButtonAdd(context));
    cards.addAll(vote!.choices
        .map((e) => CardChoice(
      choice: e,
      width: _widthCard,
      height: _heightCard,
    )).toList());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Liste des tours :",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline3,
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10.0,
          runSpacing: 10.0,
          children: vote!.rounds
              .map((e) => CardRound(
            round: e
          )).toList(),
        ),
      ],
    );
  }

  Widget _getButtonAdd(BuildContext context) {
    return ButtonCard(
      icon: Icons.add_circle_outline,
      label: "Ajouter un choix",
      height: _heightCard,
      width: _widthCard,
      color: Theme.of(context).highlightColor,
      onTap: () => NavigationNotification(AddPartyPage()).dispatch(context),
    );
  }
}
