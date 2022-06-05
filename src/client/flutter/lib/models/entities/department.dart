class Department {
  String code;
  String name;
  String codeRegion;

  Department({
    required this.code,
    required this.name,
    required this.codeRegion,
  });

  Department.fromJson(Map<String, dynamic> json)
      : code = json["code"],
        name = json["name"],
        codeRegion = json["region_code_insee"];

  @override
  String toString(){
    return "$name ($code)";
  }

}
