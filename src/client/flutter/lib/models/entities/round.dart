class Round {
  int? num;
  String? name;
  DateTime? dateStart;
  DateTime? dateEnd;
  int? nbVoter;
  int? idVote;

  Round({
    this.num,
    this.name,
    this.dateStart,
    this.dateEnd,
    this.nbVoter,
    this.idVote,
  });

  Round.fromJson(Map<String, dynamic> json)
      : num = json["num"],
        name = json["name"],
        dateStart = DateTime.parse(json["date_start"]),
        dateEnd = DateTime.parse(json["date_end"]),
        nbVoter = json["nb_voter"],
        idVote = json["id_vote"];

}