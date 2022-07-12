import 'dart:convert';

import 'package:bo_cyberacy/models/entities/meeting.dart';
import 'package:bo_cyberacy/models/services/api_service.dart';
import 'package:http/http.dart' as http;

import '../entities/response_api.dart';
import '../errors/api_service_error.dart';

class MeetingService extends ApiService {

  MeetingService();

  Future<List<Meeting>> getAllMeetings() async {
    try {
      List<Meeting> meetings = [];
      var response = await http.get(
        getUrl("meeting", {"includeCompleted": "true", "includeFinished": "true"}),
        headers: await getHeaders(auth: true),
      );
      if (response.statusCode == 200) {
        ResponseAPI responseApi = ResponseAPI.fromJson(jsonDecode(response.body));
        List<dynamic> listObject = responseApi.data;
        meetings = listObject.map((json) => Meeting.fromJson(json)).toList();
      }
      return meetings;
    } on ApiServiceError {
      rethrow;
    }
  }

  Future<Meeting?> getMeetingById(int id) async {
    try {
      var response = await http.get(
        getUrl("meeting/$id/details", null),
        headers: await getHeaders(auth: true),
      );
      if (response.statusCode == 200) {
        ResponseAPI responseApi = ResponseAPI.fromJson(jsonDecode(response.body));
        return Meeting.fromJson(responseApi.data);
      } else {
        throw ApiServiceError(response);
      }
    } on ApiServiceError {
      rethrow;
    }
  }

  Future<void> addMeeting(Meeting meeting) async {
    var response = await http.post(
      getUrl("meeting", null),
      headers: await getHeaders(auth: true),
      body: meeting.toJson(),
    );
    if (response.statusCode == 201) {
      return;
    } else {
      throw ApiServiceError(response);
    }
  }

}