import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:bo_cyberacy/models/entities/region.dart';
import 'package:bo_cyberacy/models/entities/round.dart';
import 'package:bo_cyberacy/models/entities/town.dart';
import 'department.dart';

class Vote {
  int id;
  String name;
  int idElection;
  int nbVoter;
  String? townCodeInsee;
  String? deptCode;
  String? regCode;
  String? idPoliticalParty;
  Town? town;
  Region? region;
  Department? department;
  List<Round> rounds = [];
  int? idType;

  Vote({
    required this.id,
    required this.name,
    required this.idElection,
    required this.nbVoter,
    this.townCodeInsee,
    this.deptCode,
    this.regCode,
    this.idPoliticalParty,
    this.idType
  });

  Vote.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        nbVoter = json["nb_voter"],
        idElection = json["id_election"],
        townCodeInsee = json["town_code_insee"],
        deptCode = json["department_code"],
        regCode = json["reg_code_insee"],
        idType = json["id_type"],
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

  String getLocalite() {
    if (idType == null) {
      return "-- inconnue --";
    }
    switch (idType) {
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

}
