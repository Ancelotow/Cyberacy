class Option {

  int? id;
  String? name;
  String? description;
  bool? isDelete;
  int? idManifestation;

  Option({
    this.id,
    this.name,
    this.description,
    this.isDelete,
    this.idManifestation
  });

  Option.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        description = json["description"],
        idManifestation = json["id_manifestation"];

  Object toJson() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "is_delete": isDelete.toString(),
      "id_manifestation": idManifestation.toString()
    };
  }

}