import 'package:flutter/material.dart';

import 'my_color.dart';

class Choice {
  int id;
  String name;
  int idVote;
  String? description;
  String? candidateNIR;
  String candidate;
  int? idColor;
  MyColor? color;

  Choice({
    required this.id,
    required this.name,
    required this.idVote,
    this.description,
    this.candidateNIR,
    this.candidate = "",
    this.idColor
  });

  Choice.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        idVote = json["id_vote"],
        description = json["description"],
        candidateNIR = json["candidat_nir"],
        idColor = json["idColor"],
        candidate = json["candidat"] {
    if(json["color"] != null) {
      color = MyColor.fromJson(json["color"] as Map<String, dynamic>);
    }
  }

  Object toJson() {
    Map<String, dynamic> object = {
      "name": name,
      "description": description,
    };
    if (candidateNIR != null) {
      object["candidat_nir"] = candidateNIR;
    }
    if (idColor != null) {
      object["id_color"] = idColor.toString();
    }
    return object;
  }

  Color getColor() {
    if(color == null) {
      return Colors.grey;
    } else {
      return color!.toColor();
    }
  }

}
