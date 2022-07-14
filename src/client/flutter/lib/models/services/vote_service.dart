import 'dart:convert';
import '../entities/choice.dart';
import '../entities/election.dart';
import '../entities/response_api.dart';
import '../entities/vote.dart';
import '../errors/api_service_error.dart';
import 'api_service.dart';
import 'package:http/http.dart' as http;

class VoteService extends ApiService {
  VoteService();

  Future<List<Vote>> getAllVote(int idElection) async {
    try {
      List<Vote> votes = [];
      var response = await http.get(
        getUrl("election/$idElection/vote", {"includeFinish": "true", "includeFuture": "true"}),
        headers: await getHeaders(auth: true),
      );
      if (response.statusCode == 200) {
        ResponseAPI responseApi = ResponseAPI.fromJson(jsonDecode(response.body));
        List<dynamic> listObject = responseApi.data;
        votes = listObject.map((json) => Vote.fromJson(json)).toList();
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
        ResponseAPI responseApi = ResponseAPI.fromJson(jsonDecode(response.body));
        List<dynamic> listObject = responseApi.data;
        elections = listObject.map((json) => Election.fromJson(json)).toList();
      }
      return elections;
    } on ApiServiceError catch(e) {
      rethrow;
    }
  }

  Future<void> addElection(Election election) async {
    var response = await http.post(
      getUrl("election", null),
      headers: await getHeaders(auth: true),
      body: election.toJson(),
    );
    if (response.statusCode == 201) {
      return;
    } else {
      throw ApiServiceError(response);
    }
  }

  Future<Vote> getVoteById(int id) async {
    try {
      var response = await http.get(
        getUrl("vote/$id/details", null),
        headers: await getHeaders(auth: true),
      );
      if (response.statusCode == 200) {
        ResponseAPI responseApi = ResponseAPI.fromJson(jsonDecode(response.body));
        return Vote.fromJson(responseApi.data);
      } else {
        throw ApiServiceError(response);
      }
    } on ApiServiceError catch(e) {
      rethrow;
    }
  }

  Future<void> addChoice(Choice choice, int idVote) async {
    var response = await http.post(
      getUrl("vote/$idVote/choice", null),
      headers: await getHeaders(auth: true),
      body: choice.toJson(),
    );
    if (response.statusCode == 201) {
      return;
    } else {
      throw ApiServiceError(response);
    }
  }

  Future<void> deleteChoice(int idChoice) async {
    var response = await http.delete(
      getUrl("vote/choice/$idChoice", null),
      headers: await getHeaders(auth: true),
      body: null,
    );
    if (response.statusCode == 201) {
      return;
    } else {
      throw ApiServiceError(response);
    }
  }

}