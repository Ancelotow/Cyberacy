class TypeVote {

  int id;
  String name;

  TypeVote(this.id, this.name);

  TypeVote.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"];

  @override
  String toString(){
    return name;
  }

}