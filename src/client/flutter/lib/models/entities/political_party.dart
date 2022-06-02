class PoliticalParty {
  int id;
  String name;
  DateTime dateCreate;
  String? description;
  String object;
  String addressStreet;
  String siren;
  String codeInseeTown;

  PoliticalParty(
      {required this.id,
      required this.name,
      required this.dateCreate,
      required this.object,
      required this.addressStreet,
      required this.siren,
      required this.codeInseeTown,
      this.description});

  PoliticalParty.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        dateCreate = DateTime.parse(json["date_create"]),
        object = json["object"],
        addressStreet = json["address_street"],
        siren = json["siren"],
        codeInseeTown = json["town_code_insee"];
}
