import 'package:bo_cyberacy/models/entities/my_color.dart';
import 'package:bo_cyberacy/models/entities/political_edge.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../entities/response_api.dart';
import '../entities/type_step.dart';
import '../entities/type_vote.dart';
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
        ResponseAPI responseApi = ResponseAPI.fromJson(jsonDecode(response.body));
        List<dynamic> listObject = responseApi.data;
        edges = listObject.map((json) => PoliticalEdge.fromJson(json)) .toList();
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
        ResponseAPI responseApi = ResponseAPI.fromJson(jsonDecode(response.body));
        List<dynamic> listObject = responseApi.data;
        types = listObject.map((json) => TypeStep.fromJson(json)).toList();
      }
      return types;
    } on ApiServiceError {
      rethrow;
    }
  }

  Future<List<TypeVote>> getAllTypeVote() async {
    try {
      List<TypeVote> types = [];
      var response = await http.get(
        getUrl("type_vote", null),
        headers: await getHeaders(auth: false),
      );
      if (response.statusCode == 200) {
        ResponseAPI responseApi = ResponseAPI.fromJson(jsonDecode(response.body));
        List<dynamic> listObject = responseApi.data;
        types = listObject.map((json) => TypeVote.fromJson(json)).toList();
      }
      return types;
    } on ApiServiceError {
      rethrow;
    }
  }

  Future<List<MyColor>> getAllColors() async {
    try {
      List<MyColor> colors = [];
      var response = await http.get(
        getUrl("colors", null),
        headers: await getHeaders(auth: true),
      );
      if (response.statusCode == 200) {
        ResponseAPI responseApi = ResponseAPI.fromJson(jsonDecode(response.body));
        List<dynamic> listObject = responseApi.data;
        colors = listObject.map((json) => MyColor.fromJson(json)).toList();
      }
      return colors;
    } on ApiServiceError {
      rethrow;
    }
  }

}
