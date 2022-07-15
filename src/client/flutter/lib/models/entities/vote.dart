import 'dart:convert';
import 'dart:ui';
import 'package:bo_cyberacy/models/entities/result_vote.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bo_cyberacy/models/entities/region.dart';
import 'package:bo_cyberacy/models/entities/round.dart';
import 'package:bo_cyberacy/models/entities/town.dart';
import 'choice.dart';
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
  List<Choice> choices = [];
  ResultVote? choiceWin;
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
    if(json["choices"] != null) {
      choices = (json["choices"] as List).map((dynamic json) => Choice.fromJson(json)).toList();
    }
    if (json["choice_win"] != null) {
      choiceWin = ResultVote.fromJson(json["choice_win"]);
    }
  }

  DateTime? getDateStart() {
    if(rounds.isEmpty) {
     return null;
    }
    rounds.sort((a, b) => a.dateStart.compareTo(b.dateStart));
    return rounds[0].dateStart;
  }

  String getDateStartStr() {
    DateTime? dateStart = getDateStart();
    if(dateStart == null) {
      return "-- inconnue --";
    }
    return DateFormat("dd/MM/yyyy HH:mm").format(dateStart);
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

  String getLocalisationCode() {
    if (idType == null) {
      return "";
    }
    switch (idType) {
      case 1:
      case 6:
        return "France";

      case 2:
        if (region != null) return region!.name;
        return "";

      case 3:
        if (department != null) return department!.name;
        return "";

      case 4:
        if (town != null) return town!.name;
        return "France";

      default:
        return "France";
    }
  }

  Color getColorResult() {
    if(choiceWin == null) {
      return Colors.grey;
    }
    return choiceWin!.getColor();
  }

  String getLibelleResult() {
    if(choiceWin == null) {
      return "-- Inconnu --";
    }
    return choiceWin!.nameChoice;
  }

}
