import 'dart:convert';
import 'package:bo_cyberacy/models/entities/manifestation.dart';
import 'package:bo_cyberacy/models/services/api_service.dart';
import 'package:http/http.dart' as http;
import '../errors/api_service_error.dart';

class ManifService extends ApiService {
  ManifService();

  Future<List<Manifestation>> getAllManifestations() async {
    try {
      List<Manifestation> manifs = [];
      var response = await http.get(getUrl("manifestation", null),
          headers: await getHeaders(auth: true));
      if (response.statusCode == 200) {
        List<dynamic> list = jsonDecode(response.body);
        manifs = list.map((json) => Manifestation.fromJson(json)).toList();
      }
      return manifs;
    } on ApiServiceError catch (e) {
      rethrow;
    }
  }
}