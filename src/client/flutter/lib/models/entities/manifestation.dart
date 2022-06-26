import 'dart:convert';

import 'package:bo_cyberacy/models/entities/option.dart';
import 'package:bo_cyberacy/models/entities/step.dart';

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
    try {
      List<dynamic> listStepsJson = json["steps"];
      List<dynamic> listOptionsJson = json["options"];
      steps = listStepsJson.map((jsonStep) => StepManif.fromJson(jsonStep)).toList();
      options = listOptionsJson.map((jsonOpt) => Option.fromJson(jsonOpt)).toList();
    } catch(e) {
      print(e);
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

}