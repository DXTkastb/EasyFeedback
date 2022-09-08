import 'package:flutter/material.dart';
import 'package:talkback/apis/main_api.dart';

import '../apis/audio_api.dart';

class RefreshText extends ChangeNotifier{
  String text = '';
  bool recording = true;
  late Future<int>? future;
  int counter = 0;
  Future<void> refresh() async {
    // await AudioApi.api.cancelSubscription();
    print(text);
    counter++;
    notifyListeners();
  }
  void recordingOff(){
    print(text);
    recording = false;
    future = BackendApi.sendSpeechData();
    notifyListeners();
  }

  void setText(String string) {
    text = string;
  }

  @override
  void dispose(){
    super.dispose();
    BackendApi.clearData();
  }

}