class PoliticalParty {
  int? id;
  String? name;
  DateTime? dateCreate;
  String? description;
  String? object;
  String? addressStreet;
  String? siren;
  String? codeInseeTown;
  String? nirFondator;
  int? idPoliticalEdge;
  String? iban;
  String? urlLogo;

  PoliticalParty(
      {this.id,
      this.name,
      this.dateCreate,
      this.object,
      this.addressStreet,
      this.siren,
      this.codeInseeTown,
      this.idPoliticalEdge,
      this.nirFondator,
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
      "object": object,
      "siren": siren,
      "url_logo": urlLogo,
      "iban": iban,
      "nir": nirFondator,
      "id_political_edge": idPoliticalEdge?.toString()
    };
  }

}
