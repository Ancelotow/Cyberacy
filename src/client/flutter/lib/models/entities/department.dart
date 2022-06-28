import 'package:flutter/material.dart';
import 'my_color.dart';

class Department {
  String code;
  String name;
  String codeRegion;
  int? idColor;
  MyColor? color;

  Department({
    required this.code,
    required this.name,
    required this.codeRegion,
    this.idColor
  });

  @override
  bool operator == (dynamic other) =>
      other != null && other is Department && code == other.code;

  @override
  int get hashCode => super.hashCode;

  Department.fromJson(Map<String, dynamic> json)
      : code = json["code"],
        name = json["name"],
        idColor = json["id_color"],
        codeRegion = json["region_code_insee"] {
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
    return "$code - $name";
  }
}
