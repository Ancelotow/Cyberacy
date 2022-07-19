import 'dart:ui';

import 'package:flutter/material.dart';

import 'my_color.dart';

class ResultVote {
  int idChoice;
  String nameChoice;
  int nbVoice;
  double percWithAbs;
  double percWithoutAbs;
  int? idColor;
  MyColor? color;

  ResultVote({
    required this.idChoice,
    required this.nameChoice,
    required this.nbVoice,
    required this.percWithAbs,
    required this.percWithoutAbs,
    this.idColor,
    this.color,
  });

  ResultVote.fromJson(Map<String, dynamic> json)
      : idChoice = json["id_choice"],
        nameChoice = json["libelle_choice"],
        nbVoice = json["nb_voice"],
        percWithAbs = double.parse(json["perc_with_abstention"]),
        percWithoutAbs = double.parse(json["perc_without_abstention"]),
        idColor = json["id_color"] {
    if (json["color"] != null) {
      color = MyColor.fromJson(json["color"] as Map<String, dynamic>);
    }
  }

  Color getColor() {
    if(color == null) {
      return Colors.grey;
    }
    return color!.toColor();
  }

}
