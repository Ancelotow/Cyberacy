import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:bo_cyberacy/models/entities/region.dart';
import 'package:bo_cyberacy/models/entities/round.dart';
import 'package:bo_cyberacy/models/entities/town.dart';
import 'package:bo_cyberacy/models/entities/type_vote.dart';

import 'department.dart';

class Vote {
  int? id;
  String? name;
  int? idTypeVote;
  String? townCodeInsee;
  String? deptCode;
  String? regCode;
  String? idPoliticalParty;
  TypeVote? type;
  Town? town;
  Region? region;
  Department? department;
  List<Round> rounds = [];

  Vote({
    this.id,
    this.name,
    this.idTypeVote,
    this.townCodeInsee,
    this.deptCode,
    this.regCode,
    this.idPoliticalParty,
  });

  Vote.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        idTypeVote = json["id_type_vote"],
        townCodeInsee = json["town_code_insee"],
        deptCode = json["department_code"],
        regCode = json["reg_code_insee"],
        idPoliticalParty = json["id_political_party"] {
    if (json["town"] != null) {
      town = Town.fromJson(json["town"]);
    }
    if (json["type_vote"] != null) {
      type = TypeVote.fromJson(json["type_vote"]);
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

  String getTypeName() {
    if (type != null) {
      return type!.name;
    }
    return "";
  }

  String getLocalite() {
    if (type == null) {
      return "-- inconnue --";
    }
    switch (type!.id) {
      case 1:
      case 6:
        return "Internationale";

      case 2:
        if (region != null) return region!.toString();
        return "-- région inconnue --";

      case 3:
        if (department != null) return department!.toString();
        return "-- département inconnu --";

      case 4:
        if (town != null) return town!.toString();
        return "-- ville inconnu --";

      case 5:
        return "Internationale";

      case 8:
      case 7:
        return "Internationale";

      default:
        return "-- inconnue --";
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
