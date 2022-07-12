import '../session.dart';

abstract class ApiService {
  final String apiUrl = "cyberacy.herokuapp.com";

  Future<Map<String, String>?> getHeaders({bool auth = false}) async {
    Map<String, String>? headers = {};
    String? token = await Session.getToken();
    if (auth && token != null) {
      headers["Authorization"] = 'Bearer ${token}';
    }
    headers["Access-Control-Allow-Origin"] = '*';
    headers["Access-Control-Allow-Headers"] = 'Access-Control-Allow-Origin, Accept';
    return headers;
  }

  /// Get full url of endpoint ([parameters] included)
  Uri getUrl(String endpoint, Map<String, dynamic>? parameters) {
    return Uri.https(apiUrl, endpoint, parameters);
  }

}
