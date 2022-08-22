import 'package:flutter/material.dart';
import 'package:talkback/audio_manager/audioApi.dart';

class RefreshText extends ChangeNotifier{
  Future<void> refresh() async {
    await AudioApi.api.cancelSubscription();
    notifyListeners();
  }
}