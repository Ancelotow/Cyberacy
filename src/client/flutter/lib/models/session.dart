import 'package:bo_cyberacy/models/services/auth_service.dart';
import 'errors/api_service_error.dart';

class Session {

  static Session? _instance;
  String jwtToken;

  Session._(this.jwtToken);

  static Future<void> openSession(String nir, String pwd) async {
    if(Session._instance == null) {
      try {
        var token = await AuthService().login(nir, pwd);
        Session._instance = Session._(token);
      } on ApiServiceError {
        rethrow;
      }
    }
  }

  static Session? getInstance() {
    return Session._instance;
  }

}