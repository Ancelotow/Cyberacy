import 'dart:convert';

import 'package:bo_cyberacy/models/entities/political_party.dart';
import 'package:http/http.dart' as http;
import '../errors/api_service_error.dart';
import 'api_service.dart';

class PartyService extends ApiService {

  PartyService();


  Future<List<PoliticalParty>> getAllParty() async {
    try {
      List<PoliticalParty> parties = [];
      var response = await http.get(getUrl("political_party", null), headers: getHeaders(auth: true));
      if(response.statusCode == 200) {
        List<dynamic> list = jsonDecode(response.body);
        parties = list.map((json) => PoliticalParty.fromJson(json)).toList();
      }
      return parties;
    } on ApiServiceError {
      rethrow;
    }
  }

}