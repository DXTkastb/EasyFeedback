import 'dart:async';

import 'package:flutter/services.dart';
import 'package:google_speech/config/recognition_config.dart';
import 'package:google_speech/config/recognition_config_v1.dart';
import 'package:google_speech/config/streaming_recognition_config.dart';
import 'package:google_speech/generated/google/cloud/speech/v1/cloud_speech.pb.dart'
    show StreamingRecognizeResponse;
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
  late StreamSubscription<List<int>> st;
  late StreamController<List<int>> sc;
  Stream<StreamingRecognizeResponse>? responseStream;

  static final config = RecognitionConfig(
      encoding: AudioEncoding.LINEAR16,
      model: RecognitionModel.basic,
      enableAutomaticPunctuation: true,
      sampleRateHertz: 44100,
      languageCode: 'en-US');

  AudioApi._constructor();

  static final AudioApi api = AudioApi._constructor();

  Future<void> loadKeyAuthForUser() async {
    auth = ServiceAccount.fromString(
        await rootBundle.loadString("asset/cred.json"));
    acc = SpeechToText.viaServiceAccount(auth);
    streamconfig =
        StreamingRecognitionConfig(config: config, interimResults: true);
  }

  Future<void> authInit() async {
    sc = StreamController();
    st = ((await MicStream.microphone(
            audioSource: AudioSource.MIC,
            sampleRate: 44100,
            channelConfig: ChannelConfig.CHANNEL_IN_MONO,
            audioFormat: AudioFormat.ENCODING_PCM_16BIT)) as Stream<List<int>>)
        .listen((event) {
          if(!sc.isClosed) sc.add(event);
    });
  }

  AudioApi initRealAudioStream() {
    responseStream ??= ((acc as SpeechToText).streamingRecognize(streamconfig, sc.stream)).asBroadcastStream();
    return this;
  }

  void closeAllConnections() {
    st.cancel();
    sc.close();
    responseStream = null;
  }

  /*

  CODE BELOW IS FOR TESTING PURPOSES --------------------------------------

   */

  Stream<String> getForControllerTestStream() async* {
    String message =
        "Pasta was delicious. It was creamy and had just the right amount of cheese. "
        " I order pasta frequently and I am never disappointed.The ambience had a positive vibe and other customers also looked satisfied. The only thing which I disliked was Green salad ";

    var list = (message).split(' ');
    for (String element in list) {
      await Future.delayed(const Duration(milliseconds: 500));
      yield element;
    }
  }

  Stream<String> controllerStreamSpeechDatas() {
    streamController = StreamController<String>();

    var responseStream =
        (acc as SpeechToText).streamingRecognize(streamconfig, stream!);
    subscription = responseStream.listen((data) {
      for (var element in data.results) {
        streamController.add(element.alternatives.first.transcript);
      }
    });
    return streamController.stream;
  }

  Stream<String> testControllerStreamOutputs() {
    streamController = StreamController<String>();

    var responseStream = AudioApi.api.getForControllerTestStream(); //test
    subscription = responseStream.listen((data) {
      streamController.add(data); // test
    });
    return streamController.stream;
  }

  // for controller streams
  Future<void> cancelAll() async {
    print('cancelling audio streaming!');

    await cancelSubscription();
    stream = null;
  }

  // for controller streams
  Future<void> cancelSubscription() async {
    await subscription.cancel();
    await streamController.close();
  }
}
