import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../session.dart';

abstract class ApiService {
  final String apiUrl = "cyberacy.herokuapp.com";
  BuildContext context;

  ApiService(this.context);

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
      _analyzeError(response);
      throw Future.error(response);
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
      _analyzeError(response);
      throw Future.error(response);
    }
  }

  /// Analyse response error
  void _analyzeError(http.Response response) {
    if (response.statusCode == 401) {
      _showAlertError("Non authorisé", response.body);
    } else if (response.statusCode == 403) {
      _showAlertError("Interdit", response.body);
    } else if (response.statusCode == 400) {
      _showAlertError("Erreur requêtes", response.body);
    } else if (response.statusCode >= 500) {
      _showAlertError("Erreur serveur", response.body);
    }
  }

  /// Error alert dialogue
  void _showAlertError(String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          FlatButton(
            child: Text("Ok"),
            onPressed: () {
              Navigator.pop(_);
            },
          )
        ],
        elevation: 30.00,
      ),
    );
  }
}
