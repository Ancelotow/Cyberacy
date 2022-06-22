import 'package:bo_cyberacy/models/services/auth_service.dart';
import 'package:hive/hive.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:path_provider/path_provider.dart';

class Session {

  static const String _idHiveToken = "JWTToken";

  static Future<void> initToken(String nir, String pwd) async {
    if(!kIsWeb) {
      var dir = await getApplicationDocumentsDirectory();
      Hive.init(dir.path);
    }
    Box<String> box = await Hive.openBox("loginBox");
    var token = await AuthService().login(nir, pwd);
    box.put(_idHiveToken, token);
  }

  static Future<String?> getToken() async {
    Box<String> box = await Hive.openBox("loginBox");
    return box.get(_idHiveToken);
  }

}