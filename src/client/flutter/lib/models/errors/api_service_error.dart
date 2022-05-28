import 'package:http/http.dart' as http;

class ApiServiceError implements Exception {

  http.Response responseHttp;

  ApiServiceError(this.responseHttp);

}