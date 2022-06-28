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

}