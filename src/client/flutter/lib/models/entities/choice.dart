class Choice {
  int id;
  String name;
  int idVote;
  String? description;
  String? candidateNIR;
  String candidate;

  Choice({
    required this.id,
    required this.name,
    required this.idVote,
    this.description,
    this.candidateNIR,
    this.candidate = "",
  });

  Choice.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        idVote = json["id_vote"],
        description = json["description"],
        candidateNIR = json["candidat_nir"],
        candidate = json["candidat"];

  Object toJson() {
    Map<String, dynamic> object = {
      "name": name,
      "description": description,
    };
    if (candidateNIR != null) {
      object["candidat_nir"] = candidateNIR;
    }
    return object;
  }
}
