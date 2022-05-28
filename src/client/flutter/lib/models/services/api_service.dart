import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../errors/api_service_error.dart';
import '../session.dart';

abstract class ApiService {
  final String apiUrl = "cyberacy.herokuapp.com";

  Map<String, String>? _getHeaders({bool auth = false}) {
    Map<String, String>? headers;
    if (auth && Session.getInstance() != null) {
      headers = {"Authorization": 'Bearer ${Session.getInstance()!.jwtToken}'};
    }
    return headers;
  }

  /// Get full url of endpoint ([parameters] included)
  Uri _getUrl(String endpoint, Map<String, dynamic>? parameters) {
    return Uri.https(apiUrl, endpoint, parameters);
  }

  /// Call endpoint POST
  Future<T> post<T>(String endpoint,
      {Object? body,
      Map<String, dynamic>? parameters,
      bool auth = false}) async {
    var response = await http.post(_getUrl(endpoint, parameters),
        body: body, headers: _getHeaders(auth: auth));
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response.body as T;
    } else {
      throw ApiServiceError(response);
    }
  }

  /// Call endpoint GET
  Future<T> get<T>(String endpoint,
      {Map<String, dynamic>? parameters, bool auth = false}) async {
    var response = await http.get(_getUrl(endpoint, parameters),
        headers: _getHeaders(auth: auth));
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response as T;
    } else {
      throw ApiServiceError(response);
    }
  }

}
