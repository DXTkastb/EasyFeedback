import 'package:flutter/material.dart';

class RefreshText extends ChangeNotifier{
  Future<void> refresh() async {
    // await AudioApi.api.cancelSubscription();
    notifyListeners();
  }
}