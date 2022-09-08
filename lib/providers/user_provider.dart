import 'dart:convert';

import 'package:flutter/material.dart';

import '../apis/main_api.dart';
import '../data/feedback_data.dart';
import '../services/storage_service.dart';

class UserProvider extends ChangeNotifier {
  String username = '';
  String phoneNumber = '';
  bool loadingMore = false;
  bool canLoadMore = true;
  List<FeedbackData> dataList = [];

  late Future loadDataList;
  bool refreshing = true;

  void setUserNamePhoneNumber(String values) {
   Map<String,dynamic> map = jsonDecode(values);
    username = map["user_name"]??'';
    phoneNumber = (map["user_phone_number"] == null) ? '' : '${map["user_phone_number"]}';
    initialiseFuture();
    notifyListeners();
  }

  Future loadList() async {
    await Future.delayed(const Duration(seconds: 1));
    try {
      String? token =
          StorageService.service.sharedPreferences.getString('auth-token');
      dataList = await BackendApi.getUserFeedback(token, 0);
      if (dataList.length < 50) canLoadMore = false;
    } catch (e) {
      dataList = [];
      rethrow;
    } finally {
      refreshing = false;
    }
  }

  Future localFuture() {
    return Future.delayed(Duration.zero);
  }

  void initialiseFuture() async {
    if (username.isNotEmpty) {
      refreshing = true;
      loadDataList = loadList();
    }
  }

  void loadMoreFeedbacksForUser() async {
    if (loadingMore || !canLoadMore) return;
    loadingMore = true;
    await Future.delayed(const Duration(seconds: 2));
    try {
      String? token =
          StorageService.service.sharedPreferences.getString('auth-token');
      List<FeedbackData> oldFeedbacks =
          await BackendApi.getUserFeedback(token, dataList.last.feedbackId);

      // rest call for more data, ask for 10 feedbacks, if received lower, set canLoadMore to false;
      dataList.addAll(oldFeedbacks);
      if (oldFeedbacks.length < 50) canLoadMore = false;
    } catch (e) {
      // error logging!
    } finally {
      loadingMore = false;
    }
    notifyListeners();
  }

  void refreshLoad() {
    if (refreshing) return;
    initialiseFuture();
    notifyListeners();
  }

  void removeUserName() {
    username = '';
    phoneNumber = '';
    dataList = [];
    canLoadMore = true;
    loadingMore = false;
    loadDataList = localFuture();
    notifyListeners();
  }
}
