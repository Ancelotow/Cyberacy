import 'dart:convert';
import 'package:bo_cyberacy/models/entities/department.dart';
import 'package:bo_cyberacy/models/entities/town.dart';
import 'package:bo_cyberacy/models/services/api_service.dart';
import 'package:http/http.dart' as http;
import '../errors/api_service_error.dart';

class GeoService extends ApiService {
  GeoService();

  Future<List<Town>> getTownsFromDept(String codeDept) async {
    try {
      List<Town> towns = [];
      var response = await http.get(getUrl("department/$codeDept/town", null), headers: await getHeaders(auth: false));
      if(response.statusCode == 200) {
        List<dynamic> list = jsonDecode(response.body);
        towns = list.map((json) => Town.fromJson(json)).toList();
      }
      return towns;
    } on ApiServiceError catch(e) {
      rethrow;
    }
  }

  Future<List<Department>> getDepartments() async {
    try {
      List<Department> depts = [];
      var response = await http.get(getUrl("department", null), headers: await getHeaders(auth: false));
      if(response.statusCode == 200) {
        List<dynamic> list = jsonDecode(response.body);
        depts = list.map((json) => Department.fromJson(json)).toList();
      }
      return depts;
    } on ApiServiceError {
      rethrow;
    }
  }

}