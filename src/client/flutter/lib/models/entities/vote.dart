import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:bo_cyberacy/models/entities/region.dart';
import 'package:bo_cyberacy/models/entities/round.dart';
import 'package:bo_cyberacy/models/entities/town.dart';
import 'department.dart';

class Vote {
  int? id;
  String? name;
  String? townCodeInsee;
  String? deptCode;
  String? regCode;
  String? idPoliticalParty;
  Town? town;
  Region? region;
  Department? department;
  List<Round> rounds = [];

  Vote({
    this.id,
    this.name,
    this.townCodeInsee,
    this.deptCode,
    this.regCode,
    this.idPoliticalParty,
  });

  Vote.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        townCodeInsee = json["town_code_insee"],
        deptCode = json["department_code"],
        regCode = json["reg_code_insee"],
        idPoliticalParty = json["id_political_party"] {
    if (json["town"] != null) {
      town = Town.fromJson(json["town"]);
    }
    if (json["department"] != null) {
      department = Department.fromJson(json["department"]);
    }
    if (json["region"] != null) {
      region = Region.fromJson(json["region"]);
    }
    if(json["rounds"] != null) {
      rounds = (json["rounds"] as List).map((dynamic json) => Round.fromJson(json)).toList();
    }
  }

  String getDateStartStr() {
    if(rounds.isEmpty) {
      return "-- inconnue --";
    }
    rounds.sort((a, b) => a.dateStart!.compareTo(b.dateStart!));
    return DateFormat("dd/MM/yyyy HH:mm").format(rounds[0].dateStart!);
  }

}
