import 'package:flutter/material.dart';

class MyColor {
  int id;
  String name;
  double red;
  double green;
  double blue;
  double opacity;

  MyColor({
    required this.id,
    required this.name,
    required this.red,
    required this.green,
    required this.blue,
    required this.opacity,
  });

  MyColor.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        red = double.parse(json["red"]),
        green = double.parse(json["green"]),
        blue = double.parse(json["blue"]),
        opacity = double.parse(json["opacity"]);

  Color toColor() {
    return Color.fromARGB(opacity.floor(), red.floor(), green.floor(), blue.floor());
  }

  @override
  String toString(){
    return name;
  }

}
