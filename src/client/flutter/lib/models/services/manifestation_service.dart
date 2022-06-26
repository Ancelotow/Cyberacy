import 'dart:convert';
import 'package:bo_cyberacy/models/entities/manifestation.dart';
import 'package:bo_cyberacy/models/services/api_service.dart';
import 'package:http/http.dart' as http;
import '../entities/step.dart';
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

  Future<String> addManifestation(Manifestation manif) async {
    var response = await http.post(
      getUrl("manifestation", null),
      headers: await getHeaders(auth: true),
      body: manif.toJson(),
    );
    if (response.statusCode == 201) {
      return response.body;
    } else {
      throw ApiServiceError(response);
    }
  }

  Future<String> abortedManifestation(int idManifestation, String reason) async {
    var response = await http.patch(
      getUrl("manifestation/aborted", null),
      headers: await getHeaders(auth: true),
      body: {"id": idManifestation.toString(), "reason": reason},
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw ApiServiceError(response);
    }
  }

  Future<String> addStep(StepManif step) async {
    var response = await http.post(
      getUrl("manifestation/step", null),
      headers: await getHeaders(auth: true),
      body: step.toJson(),
    );
    if (response.statusCode == 201) {
      return response.body;
    } else {
      throw ApiServiceError(response);
    }
  }

  Future<List<StepManif>> getSteps(int idManifestation) async {
    try {
      List<StepManif> steps = [];
      var response = await http.get(
          getUrl("manifestation/$idManifestation/step", null),
          headers: await getHeaders(auth: true));
      if (response.statusCode == 200) {
        List<dynamic> list = jsonDecode(response.body);
        steps = list.map((json) => StepManif.fromJson(json)).toList();
        print(list);
      }
      return steps;
    } on ApiServiceError catch (e) {
      rethrow;
    }
  }

  Future<String> deleteStep(int idStep) async {
    var response = await http.delete(
      getUrl("manifestation/step/$idStep", null),
      headers: await getHeaders(auth: true),
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw ApiServiceError(response);
    }
  }

}