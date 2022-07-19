import 'package:bo_cyberacy/models/entities/town.dart';
import 'package:bo_cyberacy/models/enums/state_progress.dart';

class Meeting {

  int id = -1;
  String name;
  DateTime dateStart;
  String? description;
  String? object;
  double nbTime;
  bool isAborted;
  int nbPlaceVacant;
  int nbPlace;
  String? addressStreet;
  int idPoliticalParty;
  String townCodeInsee;
  double rateVAT;
  double priceExcl;
  String? townName;
  bool isParticipated;
  String? linkTwitch;
  String? linkYoutube;
  double? latitude;
  double? longitude;
  Town? town;

  Meeting({
    this.id = -1,
    required this.name,
    required this.dateStart,
    required this.nbTime,
    this.isAborted = false,
    this.nbPlaceVacant = 0,
    this.nbPlace = -1,
    this.addressStreet,
    required this.idPoliticalParty,
    required this.townCodeInsee,
    required this.rateVAT,
    required this.priceExcl,
    this.townName,
    this.isParticipated = false,
    this.linkTwitch,
    this.linkYoutube,
    this.latitude,
    this.longitude,
    this.description,
    this.object,
    this.town
  });

  Meeting.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        dateStart = DateTime.parse(json["date_start"] ?? "2022-05-05"),
        nbTime = double.parse(json["nb_time"] ?? "0.0"),
        isAborted = json["is_aborted"],
        nbPlaceVacant = json["nb_place_vacant"] ?? -1,
        nbPlace = json["nb_place"] ?? -1,
        addressStreet = json["address_street"],
        idPoliticalParty = json["id_political_party"],
        townCodeInsee = json["town_code_insee"],
        rateVAT = double.parse(json["vta_rate"] ?? "0.0"),
        priceExcl = double.parse(json["price_excl"] ?? "0.0"),
        townName = json["town_name"],
        isParticipated = json["is_participate"],
        linkTwitch = json["link_twitch"],
        linkYoutube = json["link_youtube"],
        latitude = double.tryParse(json["latitude"] ?? ""),
        longitude = double.tryParse(json["longitude"] ?? ""),
        description = json["description"],
        object = json["object"] {
    if(json["town"] != null) {
      Map<String, dynamic> townJson = json["town"];
      town = Town.fromJson(townJson);
    }
  }

  Object toJson() {
    return {
      "name": name,
      "date_start": dateStart.toString(),
      "nb_time": nbTime.toString(),
      "nb_place": nbPlace.toString(),
      "street_address": addressStreet,
      "id_political_party": idPoliticalParty.toString(),
      "town_code_insee": townCodeInsee,
      "vta_rate": rateVAT.toString(),
      "price_excl": priceExcl.toString(),
      "link_twitch": linkTwitch,
      "link_youtube": linkYoutube,
      "description": description,
      "object": object
    };
  }

  String getFullAddress() {
    String fullAddress = addressStreet ?? "-- aucune adresse --";
    if(townName != null) {
      fullAddress += ", $townName";
    }
    return fullAddress;
  }

  StateProgress getStateProgress() {
    DateTime today = DateTime.now();
    int totalMinutes = (nbTime * 60).toInt();
    DateTime dateEnd = dateStart.add(Duration(minutes: totalMinutes));
    if(today.isAfter(dateEnd)) {
      return StateProgress.passed;
    } else if (today.isBefore(dateStart)) {
      return StateProgress.coming;
    } else {
      return StateProgress.inProgress;
    }
  }

}