import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_speech/generated/google/cloud/speech/v1/cloud_speech.pb.dart';

import '../apis/audio_api.dart';

class StreamSpeechDataWidget extends StatefulWidget {
  final int retryCount;
  final void Function(String) setStringFunction;
  final bool streamCollected;

  const StreamSpeechDataWidget(
      {Key? key,
      required this.retryCount,
      required this.setStringFunction,
      required this.streamCollected})
      : super(key: key);

  @override
  State<StreamSpeechDataWidget> createState() => _StreamSpeechDataWidgetState();
}

class _StreamSpeechDataWidgetState extends State<StreamSpeechDataWidget> {
  late StreamSubscription<StreamingRecognizeResponse> subscription;
  String text = '';
  final String beginText = 'please start speaking...';
  String interimText = '';
  bool textFinal = true;
  bool caughtError = false;
 // static const String temp = 'I recently had the pleasure of trying out a new pizza joint in town, and I must say, their pizza exceeded my expectations. The crust was perfectly crisp, and the toppings were fresh and flavorful, creating a delightful combination of textures and tastes. It was a truly satisfying experience that left me craving for more. However, I have to admit that the pizza\'s sauce lacked a bit of depth in flavor. While the crust and toppings were outstanding, the sauce didn\'t quite match up in terms of taste. It felt slightly bland.';

  StreamSubscription<StreamingRecognizeResponse> getSubscription() {
    return (AudioApi.api.initRealAudioStream().responseStream)!.listen((event) {
      bool finalFound = false;
      double stability = -1.0;
      // String tempText = '';
      if (mounted) {
        for (var element in event.results) {
          String textOut = element.alternatives.first.transcript;
          if (element.isFinal) {
            text = text + textOut;
            interimText = '';
            finalFound = true;
          } else if (element.stability > stability) {
            stability = element.stability;
            interimText = textOut;
          }
        }
        setState(() {
          textFinal = finalFound;
        });
      }
    }, onError: (_) {
      if (mounted) {
        setState(() {
          caughtError = true;
        });
      }
    }, onDone: () {});
  }

  @override
  void initState() {
    super.initState();
    if(!(widget.streamCollected)) subscription = getSubscription();
  }

  @override
  void didUpdateWidget(StreamSpeechDataWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.retryCount != oldWidget.retryCount) {
      text = '';
      interimText = '';
      textFinal = true;
      caughtError = false;
      subscription.pause();
      if (!(widget.streamCollected))
        subscription = getSubscription();
      else
        subscription.cancel();
    }
    widget.setStringFunction(text);
  }

  @override
  void dispose() {
    super.dispose();
    try {
      subscription.cancel();
    }
    catch (_) {}
  }

  Widget simpleText(String string) {
    if (string.isEmpty) string = beginText;
    return Text(
      string,
      textAlign: TextAlign.center,
      style: const TextStyle(
          decoration: TextDecoration.none, fontSize: 15, color: Colors.black),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.streamCollected)
      return (text.isEmpty)
          ? simpleText('Nothing recorded !')
          : simpleText(text);
    if (caughtError) return simpleText('some error occurred please try later!');
    return (textFinal)
        ? simpleText(text)
        : Text.rich(
            TextSpan(
              text: text,
              style: const TextStyle(
                  decoration: TextDecoration.none,
                  fontSize: 15,
                  color: Colors.black), // default text style
              children: <TextSpan>[
                TextSpan(
                  text: interimText,
                  style: const TextStyle(
                      decoration: TextDecoration.none,
                      fontSize: 15,
                      color: Colors.black45),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          );
  }
}
