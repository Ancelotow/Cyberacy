import 'package:bo_cyberacy/models/enums/state_progress.dart';
import 'package:flutter/material.dart';

class CardStateProgress extends StatelessWidget {
  final StateProgress stateProgress;
  late final String label;
  late final Color color;

  CardStateProgress({
    Key? key,
    required this.stateProgress,
  }) : super(key: key) {
    switch(stateProgress) {
      case StateProgress.coming:
        color = Colors.blue;
        label = "A venir";
        break;

      case StateProgress.inProgress:
        color = Colors.orangeAccent;
        label = "En cours";
        break;

      case StateProgress.passed:
        color = Colors.green;
        label = "Passé";
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Center(child: Text(label)),
      ),
    );
  }

}
