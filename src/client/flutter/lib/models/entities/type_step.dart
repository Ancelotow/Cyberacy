class TypeStep {

  int id;
  String name;

  TypeStep(this.id, this.name);

  TypeStep.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"];

  @override
  String toString(){
    return name;
  }

}