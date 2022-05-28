import 'package:bo_cyberacy/models/services/auth_service.dart';
import 'package:flutter/material.dart';

class Session {

  static Session? _instance;
  String jwtToken;

  Session._(this.jwtToken);

  static void openSession(String nir, String pwd, BuildContext context) async {
    if(Session._instance == null) {
      try {
        var token = await AuthService(context).login(nir, pwd);
        Session._instance = Session._(token);
      } catch(e) {
        throw Future.error(e);
      }
    }
  }

  static Session? getInstance() {
    return Session._instance;
  }

}