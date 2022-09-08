import 'package:flutter/material.dart';
import 'package:google_speech/generated/google/cloud/speech/v1/cloud_speech.pb.dart';

import '../apis/audio_api.dart';
import '../apis/main_api.dart';

class StreamTextWidget extends StatefulWidget {
  final vendorId;

  const StreamTextWidget(this.vendorId, {Key? key}) : super(key: key);

  @override
  State<StreamTextWidget> createState() => _StreamTextWidgetState();
}

class _StreamTextWidgetState extends State<StreamTextWidget> {
  int x = 0;
  String text = '';

  @override
  void dispose() {
    super.dispose();
    BackendApi.setSpeechData(text, widget.vendorId);
  }

  @override
  void didUpdateWidget(var oldWidget) {
    super.didUpdateWidget(oldWidget);
    text = '';
    x++;
  }

  TextStyle getStyle() {
    return const TextStyle(
        decoration: TextDecoration.none, fontSize: 15, color: Colors.black);
  }

  @override
  Widget build(BuildContext context) {
    if (x > 4) {
      return const Text(
        'Not allowed more than 3 times',
        style: TextStyle(decoration: TextDecoration.none, fontSize: 14),
      );
    }
    return

        // testing streambuilder with dummy speech input

        // StreamBuilder<String>(
        //   key: Key(x.toString()),
        //   stream: AudioApi.api.getForControllerTestStream(),
        //   // AudioApi.api.output(),
        //   builder: (BuildContext ctx, AsyncSnapshot<String> snapshot) {
        //     String tempText = '';
        //     bool finalFound = false;
        //     double stability = - 1.0;
        //
        //     if (snapshot.hasError) {
        //       return const Text("SOME ERROR OCCURED.\nPLEASE TRY LATER");
        //     }
        //     if (snapshot.connectionState == ConnectionState.done) {
        //       print("done!");
        //       return const Text(
        //         'SUBMITTING...',textAlign: TextAlign.center,
        //         style: TextStyle(decoration: TextDecoration.none, fontSize: 14,color: Color.fromRGBO(
        //             26, 29, 63, 1.0)),
        //       );
        //     } else if (snapshot.connectionState == ConnectionState.waiting) {
        //       print("still waiting");
        //       return const Text("PLEASE START SPEAKING",textAlign: TextAlign.center,
        //           style: TextStyle(decoration: TextDecoration.none, fontSize: 14,color: Color.fromRGBO(
        //               26, 29, 63, 1.0)));
        //     }
        //     text = text + snapshot.data!+" ";
        //   //  BackendApi.audioDat = text;
        //     return Text(text,textAlign: TextAlign.center,style: getStyle(),);
        //   },
        // );

        // real speech input

        StreamBuilder<StreamingRecognizeResponse>(
      key: Key(x.toString()),
      stream: (AudioApi.api.initRealAudioStream().responseStream),
      // AudioApi.api.output(),
      builder: (BuildContext ctx,
          AsyncSnapshot<StreamingRecognizeResponse> snapshot) {
        String tempText = '';
        bool finalFound = false;
        double stability = -1.0;

        if (snapshot.hasError) {
          return const Text(
            "SOME ERROR OCCURED.\nPLEASE TRY LATER",
            style: TextStyle(
                decoration: TextDecoration.none,
                fontSize: 14,
                color: Color.fromRGBO(26, 29, 63, 1.0)),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return const Text(
            'SUBMITTING...',
            style: TextStyle(
                decoration: TextDecoration.none,
                fontSize: 14,
                color: Color.fromRGBO(26, 29, 63, 1.0)),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("PLEASE START SPEAKING",
              style: TextStyle(
                  decoration: TextDecoration.none,
                  fontSize: 14,
                  color: Color.fromRGBO(26, 29, 63, 1.0)));
        }
        if (snapshot.hasData) {
          int y = 0;
          print('iiiiiii');
          for (var element in snapshot.data!.results) {
            // var element = snapshot.data!.results[0];
            String textOut = element.alternatives.first.transcript;
            if (element.isFinal) {
              text = text + textOut;
              finalFound = true;
              break;
            } else if (element.stability > stability) {
              stability = element.stability;
              tempText = textOut;
            }
          }
        }
        if (finalFound) {
          BackendApi.audioDat = text;
          return Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
                decoration: TextDecoration.none,
                fontSize: 15,
                color: Colors.black),
          );
        }
        return Text.rich(
          TextSpan(
            text: text,
            style: const TextStyle(
                decoration: TextDecoration.none,
                fontSize: 15,
                color: Colors.black), // default text style
            children: <TextSpan>[
              TextSpan(
                text: tempText,
                style: const TextStyle(
                    decoration: TextDecoration.none,
                    fontSize: 15,
                    color: Colors.black45),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        );
      },
    );
  }
}
