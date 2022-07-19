class PoliticalEdge {

  int id;
  String name;

  PoliticalEdge(this.id, this.name);

  PoliticalEdge.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"];

  @override
  String toString(){
    return name;
  }

  @override
  bool operator == (dynamic other) =>
      other != null && other is PoliticalEdge && id == other.id;

  @override
  int get hashCode => super.hashCode;

}