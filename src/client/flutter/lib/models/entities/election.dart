import 'package:bo_cyberacy/models/entities/type_vote.dart';

class Election{

  int id = -1;
  String name;
  int idTypeVote;
  DateTime dateStart;
  DateTime dateEnd;
  TypeVote? type;

  Election({
    required this.id,
    required this.name,
    required this.idTypeVote,
    required this.dateStart,
    required this.dateEnd
  });

  Election.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        idTypeVote = json["id_type_vote"],
        dateStart = DateTime.parse(json["date_start"]),
        dateEnd = DateTime.parse(json["date_end"]) {
    if (json["type_vote"] != null) {
      type = TypeVote.fromJson(json["type_vote"]);
    }
  }

  String getTypeName() {
    if (type != null) {
      return type!.name;
    }
    return "";
  }

}