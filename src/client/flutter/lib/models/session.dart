import 'package:bo_cyberacy/models/services/auth_service.dart';
import 'package:hive/hive.dart';

class Session {

  static const String _idHiveToken = "JWTToken";

  static Future<void> initToken(String nir, String pwd) async {
    Box<String> box = await Hive.openBox("loginBox");
    var token = await AuthService().login(nir, pwd);
    box.put(_idHiveToken, token);
  }

  static Future<String?> getToken() async {
    Box<String> box = await Hive.openBox("loginBox");
    return box.get(_idHiveToken);
  }

}