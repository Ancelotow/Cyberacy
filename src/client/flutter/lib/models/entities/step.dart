class StepManif {
  int? id;
  String? addressStreet;
  String? town;
  String? townCodeInsee;
  String? townZipCode;
  DateTime? dateArrived;
  int? idManifestation;
  int? idTypeStep;
  double? latitude;
  double? longitude;

  StepManif({
    this.id,
    this.addressStreet,
    this.town,
    this.townCodeInsee,
    this.dateArrived,
    this.idManifestation,
    this.idTypeStep,
    this.latitude,
    this.longitude,
  });

  StepManif.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        addressStreet = json["address_street"] ?? "",
        town = json["town_name"] ?? "",
        townCodeInsee = json["town_code_insee"] ?? "",
        townZipCode = json["town_zip_code"] ?? "",
        dateArrived = DateTime.parse(json["date_arrived"]),
        idManifestation = json["id_manifestation"],
        idTypeStep = json["id_step_type"],
        latitude = double.parse(json["latitude"] ?? "0.0") ,
        longitude = double.parse(json["longitude"] ?? "0.0");

  Object toJson() {
    return {
      "address_street": addressStreet,
      "town_code_insee": townCodeInsee,
      "date_arrived": dateArrived.toString(),
      "id_manifestation": idManifestation.toString(),
      "id_step_type": idTypeStep.toString()
    };
  }
}
