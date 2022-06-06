class Manifestation {
  int? id;
  String? name;
  DateTime? dateStart;
  DateTime? dateEnd;
  String? object;
  String? securityDescription;
  int? nbPersonEstimate;

  Manifestation({
    this.id,
    this.name,
    this.dateStart,
    this.dateEnd,
    this.object,
    this.securityDescription,
    this.nbPersonEstimate,
  });

  Manifestation.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        dateStart = DateTime.parse(json["date_start"]),
        dateEnd = DateTime.parse(json["date_end"]),
        object = json["object"],
        securityDescription = json["security_description"],
        nbPersonEstimate = json["nb_person_estimate"];

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
