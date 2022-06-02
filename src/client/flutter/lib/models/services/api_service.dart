import '../session.dart';

abstract class ApiService {
  final String apiUrl = "cyberacy.herokuapp.com";

  Map<String, String>? getHeaders({bool auth = false}) {
    Map<String, String>? headers;
    if (auth && Session.getInstance() != null) {
      headers = {"Authorization": 'Bearer ${Session.getInstance()!.jwtToken}'};
    }
    return headers;
  }

  /// Get full url of endpoint ([parameters] included)
  Uri getUrl(String endpoint, Map<String, dynamic>? parameters) {
    return Uri.https(apiUrl, endpoint, parameters);
  }

}
