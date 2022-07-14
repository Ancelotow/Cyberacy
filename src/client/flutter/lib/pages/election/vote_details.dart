import 'package:bo_cyberacy/models/notifications/remove_notification.dart';
import 'package:bo_cyberacy/pages/election/add_choice.dart';
import 'package:bo_cyberacy/widgets/cards/card_choice.dart';
import 'package:bo_cyberacy/widgets/cards/card_round.dart';
import 'package:flutter/material.dart';

import '../../models/dialog/alert_normal.dart';
import '../../models/dialog/alert_yes_no.dart';
import '../../models/entities/choice.dart';
import '../../models/entities/vote.dart';
import '../../models/errors/api_service_error.dart';
import '../../models/notifications/navigation_notification.dart';
import '../../models/services/vote_service.dart';
import '../../widgets/buttons/button_card.dart';
import '../../widgets/info_error.dart';
import '../party/add_party_page.dart';

class VoteDetailsPage extends StatefulWidget {
  final int idVote;

  VoteDetailsPage({
    Key? key,
    required this.idVote,
  }) : super(key: key);

  @override
  State<VoteDetailsPage> createState() => _VoteDetailsPageState();
}

class _VoteDetailsPageState extends State<VoteDetailsPage> {
  Vote? vote;

  bool canEdit = false;

  final double _widthCard = 500;

  final double _heightCard = 120;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: FutureBuilder(
        future: VoteService().getVoteById(widget.idVote),
        builder: (BuildContext context, AsyncSnapshot<Vote> snapshot) {
          if (snapshot.hasData) {
            vote = snapshot.data;
            DateTime? dateStart = vote?.getDateStart();
            if (dateStart == null) {
              canEdit = true;
            } else if (dateStart.isAfter(DateTime.now())) {
              canEdit = true;
            }
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
        const SizedBox(height: 20),
        Expanded(child: _getRounds(context)),
      ],
    );
  }

  Widget _getChoices(BuildContext context) {
    List<Widget> cards = [];
    if (canEdit) {
      cards.add(_getButtonAdd(context));
    }
    cards.addAll(vote!.choices.map((e) => _getCardChoice(context, e)).toList());
    return SingleChildScrollView(
      controller: ScrollController(),
      child: Column(
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
      ),
    );
  }

  Widget _getRounds(BuildContext context) {
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
          children: vote!.rounds.map((e) => CardRound(round: e)).toList(),
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
      onTap: () => NavigationNotification(AddChoice(
        vote: vote!,
      )).dispatch(context),
    );
  }

  Widget _getCardChoice(BuildContext context, Choice choice) {
    return NotificationListener<RemoveNotification<Choice>>(
      onNotification: (notification) {
        Future.delayed(
          const Duration(seconds: 0),
          () => AlertYesNo(
            title: "Supprimer le choix ${choice.name}",
            message:
                "Souhaitez-vous vraiment supprimer le choix ${choice.name} ?",
            labelButtonNo: "Non",
            labelButtonYes: "Supprimer",
            context: context,
            callback: () async {
              try {
                await VoteService().deleteChoice(choice.id);
                setState(() {
                  Navigator.of(context).pop();
                });
              } on ApiServiceError catch (e) {
                AlertNormal(
                  title: "Echec de la suppression",
                  message: e.responseHttp.body,
                  labelButton: "Réssayer",
                  context: context,
                ).show();
              }
            },
          ).show(),
        );
        return true;
      },
      child: CardChoice(
        choice: choice,
        canEdit: canEdit,
        width: _widthCard,
        height: _heightCard,
      ),
    );
  }
}
