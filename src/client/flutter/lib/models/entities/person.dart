class Person {
  String nir;
  String firstname;
  String lastname;
  String? email;
  DateTime? birthday;
  String? addressStreet;
  String? town;
  int sex;
  int? profile;
  String? token;

  Person({
    required this.nir,
    required this.firstname,
    required this.lastname,
    this.email,
    this.birthday,
    this.addressStreet,
    this.town,
    required this.sex,
    this.profile,
    this.token,
  });

  Person.fromJson(Map<String, dynamic> json)
      : nir = json["nir"],
        firstname = json["firstname"],
        lastname = json["lastname"],
        email = json["email"],
        birthday = DateTime.parse(json["birthday"]),
        addressStreet = json["address_street"],
        town = json["town"],
        sex = json["sex"],
        profile = json["profile"],
        token = json["token"];


}
