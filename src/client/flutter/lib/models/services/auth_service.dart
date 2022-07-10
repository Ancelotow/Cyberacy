import 'dart:convert';

import 'package:bo_cyberacy/models/services/api_service.dart';
import 'package:http/http.dart' as http;
import '../entities/Person.dart';
import '../entities/response_api.dart';
import '../errors/api_service_error.dart';

class AuthService extends ApiService {
  AuthService();

  Future<Person> login(String login, String pwd) async {
    var response = await http.post(getUrl("login_bo", null),
        headers: await getHeaders(auth: false),
        body: {"nir": login, "password": pwd});
    if (response.statusCode == 200) {
      ResponseAPI responseApi = ResponseAPI.fromJson(jsonDecode(response.body));
      return Person.fromJson(responseApi.data);
    } else {
      throw ApiServiceError(response);
    }
  }
}
