class Town {
  String codeInsee;
  String name;
  String zipCode;
  int? nbResident;
  String codeDept;

  Town({
    required this.codeInsee,
    required this.name,
    required this.zipCode,
    this.nbResident,
    required this.codeDept,
  });

  Town.fromJson(Map<String, dynamic> json)
      : codeInsee = json["code_insee"],
        name = json["name"],
        zipCode = json["zip_code"],
        codeDept = json["department_code"];

  @override
  String toString(){
    return "$name ($zipCode)";
  }

}
