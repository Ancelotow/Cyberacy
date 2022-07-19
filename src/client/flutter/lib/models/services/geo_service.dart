import 'dart:convert';
import 'dart:html';
import 'package:bo_cyberacy/models/entities/department.dart';
import 'package:bo_cyberacy/models/entities/region.dart';
import 'package:bo_cyberacy/models/entities/response_api.dart';
import 'package:bo_cyberacy/models/entities/town.dart';
import 'package:bo_cyberacy/models/services/api_service.dart';
import 'package:http/http.dart' as http;
import '../entities/coordinates.dart';
import '../errors/api_service_error.dart';

class GeoService extends ApiService {
  GeoService();

  Future<List<Town>> getTownsFromDept(String codeDept) async {
    try {
      List<Town> towns = [];
      var response = await http.get(
        getUrl("department/$codeDept/town", null),
        headers: await getHeaders(auth: false),
      );
      if (response.statusCode == 200) {
        ResponseAPI responseApi = ResponseAPI.fromJson(jsonDecode(response.body));
        List<dynamic> listObject = responseApi.data;
        towns = listObject.map((json) => Town.fromJson(json)).toList();
      }
      return towns;
    } on ApiServiceError catch (e) {
      rethrow;
    }
  }

  Future<List<Department>> getDepartments() async {
    try {
      List<Department> depts = [];
      var response = await http.get(
        getUrl("department", null),
        headers: await getHeaders(auth: false),
      );
      if (response.statusCode == 200) {
        ResponseAPI responseApi = ResponseAPI.fromJson(jsonDecode(response.body));
        List<dynamic> listObject = responseApi.data;
        depts = listObject.map((json) => Department.fromJson(json)).toList();
      }
      return depts;
    } on ApiServiceError {
      rethrow;
    }
  }

  Future<List<Region>> getRegions() async {
    try {
      List<Region> regions = [];
      var response = await http.get(
        getUrl("region", null),
        headers: await getHeaders(auth: false),
      );
      if (response.statusCode == 200) {
        ResponseAPI responseApi = ResponseAPI.fromJson(jsonDecode(response.body));
        List<dynamic> listObject = responseApi.data;
        regions = listObject.map((json) => Region.fromJson(json)).toList();
      }
      return regions;
    } on ApiServiceError {
      rethrow;
    }
  }

  Future<MyCoordinates?> getCoordinates(String address, String zipCode) async {
    try {
      var response = await http.get(
        getUrl("coordinates", {"address_street": address, "zip_code": zipCode}),
        headers: await getHeaders(auth: true),
      );
      if (response.statusCode == 200) {
        ResponseAPI responseApi = ResponseAPI.fromJson(jsonDecode(response.body));
        return MyCoordinates.fromJson(responseApi.data);
      }
      return null;
    } on ApiServiceError {
      rethrow;
    }
  }
}
