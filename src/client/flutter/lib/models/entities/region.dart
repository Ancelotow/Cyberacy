class Region {
  String codeInsee;
  String name;

  Region({
    required this.codeInsee,
    required this.name,
  });

  @override
  bool operator == (dynamic other) =>
      other != null && other is Region && codeInsee == other.codeInsee;

  @override
  int get hashCode => super.hashCode;

  Region.fromJson(Map<String, dynamic> json)
      : codeInsee = json["code_insee"],
        name = json["name"];

  @override
  String toString() {
    return name;
  }
}