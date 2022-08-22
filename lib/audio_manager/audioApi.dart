import 'dart:async';

import 'package:flutter/services.dart';
import 'package:google_speech/config/recognition_config.dart';
import 'package:google_speech/config/recognition_config_v1.dart';
import 'package:google_speech/config/streaming_recognition_config.dart';
import 'package:google_speech/speech_client_authenticator.dart';
import 'package:google_speech/speech_to_text.dart';
import 'package:mic_stream/mic_stream.dart';

class AudioApi {
  late final auth;
  late final acc;
  late final streamconfig;
  late Stream<List<int>>? stream;
  late StreamSubscription subscription;
  late StreamController<String> streamController;
  static final config = RecognitionConfig(
      encoding: AudioEncoding.LINEAR16,
      model: RecognitionModel.phone_call,
      enableAutomaticPunctuation: true,
      sampleRateHertz: 44100,
      languageCode: 'en-US');

  AudioApi._constructor();

  static final AudioApi api = AudioApi._constructor();
  Future<void> loadKeyAuth() async {
    auth = ServiceAccount.fromString(
        await rootBundle.loadString("asset/cred.json"));
    acc = SpeechToText.viaServiceAccount(auth);
    streamconfig =
        StreamingRecognitionConfig(config: config, interimResults: false);
  }
  Future<void> authinit() async {

    stream = (await MicStream.microphone(
            audioSource: AudioSource.MIC,
            sampleRate: 44100,
            channelConfig: ChannelConfig.CHANNEL_IN_MONO,
            audioFormat: AudioFormat.ENCODING_PCM_16BIT)
        ) as Stream<List<int>>;
  }
  static Stream<String> getStream() async* {
    var list =('ABCDEFGHIJKL').split('');
    for (String element in list) {
      // print('list element:'+element);
      await Future.delayed( const Duration(milliseconds: 500));
      yield element;
    }
  }
  Stream<String> output() {
    streamController = StreamController<String>();

    var responseStream =
   getStream();

        // (acc as SpeechToText).streamingRecognize(streamconfig, stream!);
    subscription = responseStream.listen((data) {
      streamController.add(data);

      // for (var element in data.results) {
      //   streamController.add(element.alternatives.first.transcript);
      // }

    });
    return streamController.stream;
  }
  Future<void> cancelAll() async{
    await cancelSubscription();
    stream=null;
  }
  Future<void> cancelSubscription() async {
    if(!(streamController.isClosed))
    await subscription.cancel();
    await streamController.close();

  }
}
