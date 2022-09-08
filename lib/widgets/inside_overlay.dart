import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:talkback/services/auth_service.dart';
import 'package:talkback/widgets/button_block.dart';
import 'package:talkback/widgets/error_box.dart';

import '/apis/audio_api.dart';
import '../providers/speech_data_provider.dart';
import '../timer_indicator/timerindicator.dart';
import 'live_speech_data_view_widget.dart';

class InsideOverlay extends StatefulWidget {
  final BoxConstraints boxConstraints;
  final void Function(String data)? onpressed;
  final String upiLink;

  const InsideOverlay({
    Key? key,
    required this.boxConstraints,
    this.onpressed,
    required this.upiLink,
  }) : super(key: key);

  @override
  State<InsideOverlay> createState() => _InsideOverlayState();
}

class _InsideOverlayState extends State<InsideOverlay> {
  // bool recording = true;
  late Future audioFuture;
  late Future<http.Response> upiCheckFuture;

  @override
  void initState() {
    upiCheckFuture =
        (AuthService.service.checkUpi(widget.upiLink)).then((value) {
      if (mounted && value.statusCode == 200) {
        audioFuture = AudioApi.api.authInit();
      }
      return value;
    });
    super.initState();
  } // for mic stream

  @override
  void dispose() {
    super.dispose();
    // AudioApi.api.cancelAll();
  }

  //   @override
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: upiCheckFuture,
      builder: (futureContext2, snapshot2) {
        if (snapshot2.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.black,
            ),
          );
        } else if (snapshot2.hasError) {
          return ErrorBox(
              onpressed: widget.onpressed,
              errorMessage: "Some error occurred. Please try later.");
        } else if (snapshot2.connectionState == ConnectionState.done &&
            (snapshot2.data as http.Response).statusCode != 200) {
          var code = (snapshot2.data as http.Response).statusCode;
          String errorText = 'Some error occurred. Please try later';
          if (code == 404) errorText = 'vendor not registered with the UPI ID.';
          return ErrorBox(onpressed: widget.onpressed, errorMessage: errorText);
        }
        return ChangeNotifierProvider<SpeechDataProvider>(
          create: (BuildContext ctx) => SpeechDataProvider((widget.onpressed)!),
          builder: (cnp, _) {
            return FutureBuilder(
                future: audioFuture,
                builder: (futureContext1, snapshot1) {
                  if (snapshot1.hasError) {
                    return ErrorBox(
                      errorMessage: 'some error please try later',
                      onpressed: widget.onpressed,
                    );
                  }
                  if (snapshot1.connectionState == ConnectionState.done) {
                    //   widget.onpressed!();
                    // }
                    // if (snapshot1.connectionState == ConnectionState.done) {
                    return Column(
                      children: [
                        Container(
                            child: const LinearIndicator(),
                            width: 200,
                            padding: const EdgeInsets.all(20)),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.blue.shade200,
                              borderRadius: BorderRadius.circular(30)),
                          height: widget.boxConstraints.maxHeight - 145,
                          width: widget.boxConstraints.maxWidth,
                          child: const Center(
                            child: SingleChildScrollView(
                              reverse: true,
                              padding: EdgeInsets.all(15),
                              child: LiveSpeechView(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 25,),
                        const ButtonBlock(),
                      ],
                    );
                  }
                  return const CircularProgressIndicator(
                    color: Colors.black,
                  );
                });
          },
        );
      },
    );
  }
}
