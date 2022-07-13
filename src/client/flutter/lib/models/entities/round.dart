class Round {
  int num;
  String name;
  DateTime dateStart;
  DateTime dateEnd;
  int nbVoter;
  int idVote;

  Round({
    required this.num,
    required this.name,
    required this.dateStart,
    required this.dateEnd,
    this.nbVoter = 0,
    required this.idVote,
  });

  Round.fromJson(Map<String, dynamic> json)
      : num = json["num"],
        name = json["name"],
        dateStart = DateTime.parse(json["date_start"]),
        dateEnd = DateTime.parse(json["date_end"]),
        nbVoter = json["nb_voter"] ?? 0,
        idVote = json["id_vote"];

}