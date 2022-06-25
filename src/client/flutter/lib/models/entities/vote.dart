class Vote {

  int? id;
  String? name;
  int? idTypeVote;
  String? townCodeInsee;
  String? deptCode;
  String? regCode;
  String? idPoliticalParty;

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
        idPoliticalParty = json["id_political_party"];

}
