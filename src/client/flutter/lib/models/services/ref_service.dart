import 'package:bo_cyberacy/models/entities/political_edge.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../entities/type_step.dart';
import '../errors/api_service_error.dart';
import 'api_service.dart';

class RefService extends ApiService {
  RefService();

  Future<List<PoliticalEdge>> getAllPoliticalEdge() async {
    try {
      List<PoliticalEdge> edges = [];
      var response = await http.get(
        getUrl("political_edge", null),
        headers: await getHeaders(auth: false),
      );
      if (response.statusCode == 200) {
        List<dynamic> list = jsonDecode(response.body);
        edges = list.map((json) => PoliticalEdge.fromJson(json)).toList();
      }
      return edges;
    } on ApiServiceError {
      rethrow;
    }
  }

  Future<List<TypeStep>> getAllTypeStep() async {
    try {
      List<TypeStep> types = [];
      var response = await http.get(
        getUrl("type_step", null),
        headers: await getHeaders(auth: false),
      );
      if (response.statusCode == 200) {
        List<dynamic> list = jsonDecode(response.body);
        types = list.map((json) => TypeStep.fromJson(json)).toList();
      }
      return types;
    } on ApiServiceError {
      rethrow;
    }
  }

}