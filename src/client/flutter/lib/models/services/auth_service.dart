import 'package:bo_cyberacy/models/services/api_service.dart';
import 'package:http/http.dart' as http;
import '../errors/api_service_error.dart';

class AuthService extends ApiService {
  AuthService();

  Future<String> login(String login, String pwd) async {
    var response = await http.post(getUrl("login_bo", null),
        headers: getHeaders(auth: false),
        body: {"nir": login, "password": pwd});
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw ApiServiceError(response);
    }
  }
}
