import 'dart:convert';

import 'package:bo_cyberacy/models/entities/option.dart';
import 'package:bo_cyberacy/models/entities/step.dart';

import '../enums/state_progress.dart';

class Manifestation {
  int? id;
  String? name;
  DateTime? dateStart;
  DateTime? dateEnd;
  String? object;
  String? securityDescription;
  int? nbPersonEstimate;
  List<StepManif>? steps;
  List<Option>? options;

  Manifestation({
    this.id,
    this.name,
    this.dateStart,
    this.dateEnd,
    this.object,
    this.securityDescription,
    this.nbPersonEstimate,
    this.steps,
    this.options
  });

  Manifestation.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        dateStart = DateTime.parse(json["date_start"]),
        dateEnd = DateTime.parse(json["date_end"]),
        object = json["object"],
        securityDescription = json["security_description"],
        nbPersonEstimate = json["nb_person_estimate"] {
    if(json["steps"] != null) {
      List<dynamic> listStepsJson = json["steps"];
      steps = listStepsJson.map((jsonStep) => StepManif.fromJson(jsonStep)).toList();
    }
    if(json["options"] != null) {
      List<dynamic> listOptionsJson = json["options"];
      options = listOptionsJson.map((jsonOpt) => Option.fromJson(jsonOpt)).toList();
    }
  }

  Object toJson() {
    return {
      "name": name,
      "date_start": dateStart?.toString(),
      "date_end": dateStart?.toString(),
      "object": object,
      "security_description": securityDescription,
      "nb_person_estimate": nbPersonEstimate.toString()
    };
  }

  StateProgress getStateProgress() {
    DateTime today = DateTime.now();
    if(dateEnd == null || dateStart == null) {
      return StateProgress.coming;
    } else if(today.isAfter(dateEnd!)) {
      return StateProgress.passed;
    } else if (today.isBefore(dateStart!)) {
      return StateProgress.coming;
    } else {
      return StateProgress.inProgress;
    }
  }

}
