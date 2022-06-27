import 'dart:convert';
import '../entities/election.dart';
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
        getUrl("vote", {"includeFinish": "true", "includeFuture": "true"}),
        headers: await getHeaders(auth: true),
      );
      if (response.statusCode == 200) {
        List<dynamic> list = jsonDecode(response.body);
        try{
          votes = list.map((json) => Vote.fromJson(json)).toList();

        } catch(e) {
          print(e);
        }
      }
      return votes;
    } on ApiServiceError catch(e) {
      rethrow;
    }
  }

  Future<List<Election>> getAllElection() async {
    try {
      List<Election> elections = [];
      var response = await http.get(
        getUrl("election", {"includeFinish": "true", "includeFuture": "true"}),
        headers: await getHeaders(auth: true),
      );
      if (response.statusCode == 200) {
        List<dynamic> list = jsonDecode(response.body);
        elections = list.map((json) => Election.fromJson(json)).toList();
      }
      return elections;
    } on ApiServiceError catch(e) {
      rethrow;
    }
  }

}