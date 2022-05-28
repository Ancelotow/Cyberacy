class PoliticalParty {

  int id;
  String name;
  DateTime dateCreate;
  String? description;
  String object;
  String addressStreet;
  String siren;
  String codeInseeTown;

  PoliticalParty({
    required this.id,
    required this.name,
    required this.dateCreate,
    required this.object,
    required this.addressStreet,
    required this.siren,
    required this.codeInseeTown,
    this.description
  });

}