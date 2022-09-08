import 'dart:async';

import 'package:flutter/material.dart';

import '../apis/audio_api.dart';

class SpeechDataProvider extends ChangeNotifier {
  // -1 not recording __ options: nil
  // 0 recording started __ options: restart, cancel, submit
  // 1 recording stopped __ options: cancel, submit

  String speechData = '';
  int recordState = -1;

  int counter = 0;
  bool disposed = false;
  late Timer timer;
  late Function(String data) overlayPopFunction;
  late Future startSpeechRecognition;

  SpeechDataProvider(Function(String data) popFunction) {
    overlayPopFunction = popFunction;
    startSpeechRecognition = (Future.delayed(Duration.zero)).then((value) {
      if (!disposed) {
        recordState = 0;
        notifyListeners();
        timer = Timer(const Duration(seconds: 50), () async {
          if (!disposed) {
            if(recordState==0) {
              doneRecording();
            }
            // stop this timer, ask user whether to submit
          }
        });
      }
    });
  }

  void setSpeechData(String data) {
    speechData = data;
  }

  void refresh() {
    if(recordState==1 || counter >= 3) return;
    speechData = '';
    counter++;
    if(counter >= 3) recordState = 1;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    disposed = true;
    if (recordState != -1) timer.cancel();
  }

  void doneRecording() {
    if(recordState == 1) return;
    recordState = 1;
    notifyListeners();
  }
}
