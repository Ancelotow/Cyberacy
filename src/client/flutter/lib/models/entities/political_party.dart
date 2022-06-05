class PoliticalParty {
  int id;
  String name;
  DateTime dateCreate;
  String? description;
  String object;
  String addressStreet;
  String siren;
  String codeInseeTown;
  String nirFondator;
  int idPoliticalEdge;
  String? iban;
  String? urlLogo;

  PoliticalParty(
      {required this.id,
      required this.name,
      required this.dateCreate,
      required this.object,
      required this.addressStreet,
      required this.siren,
      required this.codeInseeTown,
      required this.idPoliticalEdge,
      required this.nirFondator,
      this.urlLogo,
      this.iban,
      this.description});

  PoliticalParty.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        dateCreate = DateTime.parse(json["date_create"]),
        object = json["object"],
        addressStreet = json["address_street"],
        siren = json["siren"],
        iban = json["iban"],
        idPoliticalEdge = json["id_political_edge"],
        nirFondator = json["nir"],
        urlLogo = json["url_logo"],
        codeInseeTown = json["town_code_insee"];

  Object toJson() {
    return {
      "name": name,
      "date_create": dateCreate.toString(),
      "object": object,
      "address_street": addressStreet,
      "siren": siren,
      "town_code_insee": codeInseeTown,
      "url_logo": urlLogo,
      "iban": iban,
      "nir": nirFondator,
      "id_political_edge": idPoliticalEdge.toString()
    };
  }
}
