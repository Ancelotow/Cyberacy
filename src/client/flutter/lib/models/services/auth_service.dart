import 'package:bo_cyberacy/models/services/api_service.dart';
import '../entities/login.dart';

class AuthService extends ApiService {

  AuthService(super.context);

  Future<String> login(String login, String pwd) async {
    try {
      var token = await post<String>("login_bo", body: Login(login, pwd).toJson());
      return token;
    } catch (e) {
      throw Future.error(e);
    }
  }

}