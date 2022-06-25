import 'dart:convert';
import '../entities/vote.dart';
import '../errors/api_service_error.dart';
import 'api_service.dart';
import 'package:http/http.dart' as http;

class VoteService extends ApiService {
  VoteService();

  Future<List<Vote>> getAllVote() async {
    try {
      List<Vote> votes = [];
      var response = await http.get(
        getUrl("vote", {"includeFinish": "false", "includeFuture": "false"}),
        headers: await getHeaders(auth: true),
      );
      if (response.statusCode == 200) {
        List<dynamic> list = jsonDecode(response.body);
        votes = list.map((json) => Vote.fromJson(json)).toList();
      }
      return votes;
    } on ApiServiceError catch(e) {
      rethrow;
    }
  }

}