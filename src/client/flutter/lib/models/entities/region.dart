import 'package:flutter/material.dart';

import 'my_color.dart';

class Region {

  String codeInsee;
  String name;
  int? idColor;
  MyColor? color;

  Region({
    required this.codeInsee,
    required this.name,
    this.idColor
  });

  @override
  bool operator == (dynamic other) =>
      other != null && other is Region && codeInsee == other.codeInsee;

  @override
  int get hashCode => super.hashCode;

  Region.fromJson(Map<String, dynamic> json)
      : codeInsee = json["code_insee"],
        name = json["name"],
        idColor = json["id_color"] {
    if(json["color"] != null) {
      color = MyColor.fromJson(json["color"]);
    }
  }

  Color getColor() {
    if(color != null) {
      return color!.toColor();
    }
    return Colors.grey;
  }

  @override
  String toString() {
    return name;
  }
}