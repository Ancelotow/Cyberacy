import 'package:bo_cyberacy/models/services/api_service.dart';
import '../entities/login.dart';
import '../errors/api_service_error.dart';

class AuthService extends ApiService {

  AuthService();

  Future<String> login(String login, String pwd) async {
    try {
      var token = await post<String>("login_bo", body: Login(login, pwd).toJson());
      return token;
    } on ApiServiceError {
      rethrow;
    }
  }

}