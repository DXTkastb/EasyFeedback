import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:talkback/services/storage_service.dart';

import '../data/feedback_data.dart';

class BackendApi {
  static String audioDat = '';
  static String vendorID = '';
  static String getUserFeedbackUrl = 'http://192.168.29.136:8080/user/feedbacks?id=';

  static Future<int>? sendSpeechData() async {
    if (audioDat.isEmpty) return 101;
    Map<String, dynamic> data = {"data": audioDat};
    var response = null;
    try {
      response = await post(
          Uri.parse(
              "http://192.168.29.136:8080/customer/feedbackToVendor?vendorID=$vendorID"),
          headers: {
            "Content-type": 'application/json',
          },
          body: jsonEncode(data));
    } catch (e) {
      return 101;
    }
    return response.statusCode;
  }

  static Future<int> sendSpeechData2(String speech, String link, String phoneNum) async {
    Map<String, dynamic> data = {"data": speech};
    var response;
    try {
      response = await post(Uri.parse("http://192.168.29.136:8080/user/post/feedback?phoneNum=$phoneNum&upiLink=$link"),
          headers: {
            "Content-type": 'text/plain',
          },
          body: speech);
    } catch (e) {
      return 400;
    }
    return response.statusCode;
  }

  static void setSpeechData(String string, String id) {
    audioDat = string;
    vendorID = id;
  }

  static void clearData() {
    audioDat = '';
    vendorID = '';
  }

  static Future<List<FeedbackData>> getUserFeedback(
      String? token, int lastid) async {
    if(token == null)  throw Exception('some error occurred. please try later');
    Response response;

    Uri url = Uri.parse(getUserFeedbackUrl + '$lastid');
    response = await get(url, headers: {'auth-token': token});
    if ((response).statusCode != 200) {
      throw Exception('some error occurred. please try later');
    }
    // spawn an isolate to decode json
    var body = response.body;
    var list = await compute(decodeData, body);
    return list;
  }

  static Future<List<FeedbackData>> decodeData(String data) async {
    return (jsonDecode(data) as List).map((e) {
      e = e as Map;
      return FeedbackData(
          feedback: e['feedback'],
          vendorName: e['vendorUpi'],
          feedbackId: e['id'],
          time: e['time']);
    }).toList();
  }
}
