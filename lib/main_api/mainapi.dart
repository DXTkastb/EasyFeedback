import 'dart:math';

import 'package:talkback/audio_manager/audioApi.dart';
import 'package:talkback/grpc_client/my_client.dart';

class MainApi{

  static List<String> list=['Hi ','my ','name ','is ','Kaustubh !'];
  var random= Random();

  bool _isStarted = false;
   Future<void> start() async {
    // _isStarted = true;
    // await AudioApi.api.init();
    // await Future.delayed(const Duration(seconds: 5));
    // if(_isStarted)
    // {
    //   AudioApi.api.startStream();
    // }
    // await MyClient.myClient.main();
  }

  Future<void> dispose() async {
    // await MyClient.myClient.closeChannel();
    // if(_isStarted) {
    //   _isStarted =false;
    //   await AudioApi.api.endStream();
    // }
  }

  static Stream<String> getStream() async* {
    for (String element in list) {
      // print('list element:'+element);
      await Future.delayed( const Duration(milliseconds: 500));
      yield element;
    }
  }

}