import 'package:bo_cyberacy/models/entities/result_vote.dart';
import 'package:bo_cyberacy/models/services/vote_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/entities/choice.dart';
import '../../models/entities/round.dart';
import '../info_error.dart';
import 'package:percent_indicator/percent_indicator.dart';

class CardRound extends StatelessWidget {
  final Round round;

  const CardRound({
    Key? key,
    required this.round,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      height: 500,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        color: Theme.of(context).cardColor,
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            blurRadius: 6,
            offset: Offset(1, 1), // Shadow position
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                round.name,
                maxLines: 2,
                overflow: TextOverflow.clip,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: "HK-Nova",
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Icon(Icons.calendar_today),
                Text(
                  " Début : ${DateFormat("dd/MM/yyyy HH:mm").format(round.dateStart)} - Fin : ${DateFormat("dd/MM/yyyy HH:mm").format(round.dateEnd)}",
                  maxLines: 2,
                  overflow: TextOverflow.clip,
                  style: Theme.of(context).textTheme.bodyText1,
                )
              ],
            ),
            const SizedBox(height: 10),
            Expanded(child: _getListChoices(context))
          ],
        ),
      ),
    );
  }

  Widget _getListChoices(BuildContext context) {
    if (round.dateEnd.isBefore(DateTime.now())) {
      return SingleChildScrollView(
        controller: ScrollController(),
        child: FutureBuilder(
          future: VoteService().getResultRound(round.idVote, round.num),
          builder:
              (BuildContext context, AsyncSnapshot<List<ResultVote>> snapshot) {
            if (snapshot.hasData) {
              return _getChoicesWithResult(context, snapshot.data!);
            } else if (snapshot.hasError) {
              return InfoError(error: snapshot.error as Error);
            } else {
              return const Center(
                child: SizedBox(
                  width: 50,
                  height: 50,
                  child: CircularProgressIndicator(
                    strokeWidth: 5.0,
                  ),
                ),
              );
            }
          },
        ),
      );
    }
    return SingleChildScrollView(
      controller: ScrollController(),
      child: _getChoicesWithoutResult(context),
    );
  }

  Widget _getChoicesWithoutResult(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: round.choices.map((e) => _getCardChoice(context, e)).toList(),
    );
  }

  Widget _getChoicesWithResult(BuildContext context, List<ResultVote> results) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: results.map((e) => _getCardResult(context, e)).toList(),
    );
  }

  Widget _getCardChoice(BuildContext context, Choice choice) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          color: Colors.grey,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                choice.name,
                style: const TextStyle(
                  color: Colors.black,
                  fontFamily: "HK-Nova",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getCardResult(BuildContext context, ResultVote resultVote) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          color: Colors.grey,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                resultVote.nameChoice,
                style: const TextStyle(
                    color: Colors.black,
                    fontFamily: "HK-Nova",
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _getLinearPercent(
                perc: resultVote.percWithoutAbs,
                libelle: "Résultat (sans abstention) :",
                color: resultVote.getColor(),
              ),
              const SizedBox(height: 20),
              _getLinearPercent(
                perc: resultVote.percWithAbs,
                libelle: "Résultat (avec abstention) :",
                color: resultVote.getColor(),
              ),
              const SizedBox(height: 20),
              Text(
                "Nombre de voies : ${resultVote.nbVoice}",
                style: const TextStyle(color: Colors.black),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _getLinearPercent(
      {required double perc, required String libelle, required Color color}) {
    return LinearPercentIndicator(
      animation: true,
      animationDuration: 1000,
      lineHeight: 20.0,
      leading: const Text(
        "Résultat (avec abstention) :",
        style: TextStyle(color: Colors.black),
      ),
      percent: perc / 100,
      center: Text(
        "${perc.toStringAsFixed(3)}%",
        style: const TextStyle(color: Colors.black),
      ),
      barRadius: const Radius.circular(10.0),
      progressColor: color,
    );
  }
}
