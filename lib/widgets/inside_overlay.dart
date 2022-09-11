import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_speech/generated/google/cloud/speech/v1/cloud_speech.pb.dart';
import 'package:provider/provider.dart';

import '/apis/audio_api.dart';
import '/apis/main_api.dart';
import '/providers/refreshttext.dart';
import '/timer_indicator/timerindicator.dart';

class InsideOverlay extends StatefulWidget {
  final BoxConstraints boxConstraints;
  final void Function()? onpressed;
  final int vendorID;

  const InsideOverlay({
    Key? key,
    required this.boxConstraints,
    this.onpressed,
    required this.vendorID,
  }) : super(key: key);

  @override
  State<InsideOverlay> createState() => _InsideOverlayState();
}

class _InsideOverlayState extends State<InsideOverlay> {
  late Timer timeout;
  Future audiofuture = AudioApi.api.authInit();

  @override
  void initState() {
    timeout = Timer(const Duration(seconds: 50), () async {
      // await AudioApi.api.cancelAll();
      if (mounted) {
        widget.onpressed!();
      }
    });
    super.initState();
  } // for mic stream

//   @override
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ChangeNotifierProvider(
      create: (BuildContext ctx) => RefreshText(),
      builder: (cnp, _) {
        return FutureBuilder(
            future: audiofuture,
            builder: (futureContext, snapshot) {
              if (snapshot.connectionState == ConnectionState.none) {
                widget.onpressed!();
              }
              if (snapshot.connectionState == ConnectionState.done) {
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
                      child: Center(
                        child: SingleChildScrollView(
                          reverse: true,
                          padding: const EdgeInsets.all(15),
                          child: Consumer<RefreshText>(
                            builder: (cnp2, b, c) {
                              return StreamTextWidget(widget.vendorID);
                            },
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 50,
                      padding: const EdgeInsets.all(10),
                      child: const SpinKitPulse(
                        color: Colors.black,
                        size: 30,
                        duration: Duration(milliseconds: 700),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      width: widget.boxConstraints.maxWidth,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          BottomButton(
                              onpressed: () async {
                                await Provider.of<RefreshText>(futureContext,
                                        listen: false)
                                    .refresh();
                              },
                              text: 'Restart'),
                          BottomButton(
                              onpressed: () {
                                //await AudioApi.api.cancelAll();
                                widget.onpressed!();
                              },
                              text: 'OK')
                        ],
                      ),
                    )
                  ],
                );
              }
              return const CircularProgressIndicator(
                color: Colors.black,
              );
            });
      },
    );
  }
}

class BottomButton extends StatelessWidget {
  final void Function()? onpressed;
  final String text;

  const BottomButton({Key? key, this.onpressed, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onpressed,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.black, borderRadius: BorderRadius.circular(25)),
        alignment: Alignment.center,
        width: 100,
        child: Text(
          text,
          style: const TextStyle(
              decoration: TextDecoration.none,
              fontSize: 14,
              color: Colors.white),
        ),
      ),
    );
  }
}

class StreamTextWidget extends StatefulWidget {
  final vendorId;

  const StreamTextWidget(this.vendorId, {Key? key}) : super(key: key);

  @override
  State<StreamTextWidget> createState() => _StreamTextWidgetState();
}

class _StreamTextWidgetState extends State<StreamTextWidget> {
  late int x;

  @override
  void initState() {
    x = 0;
    super.initState();
  }

  @override
  void dispose() {
    BackendApi.sendSpeechData(widget.vendorId, ordernumber: BackendApi.onum);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String text = '';
    x++;

    if (x > 4) {
      return const Text(
        'Not allowed more than 3 times',
        style: TextStyle(decoration: TextDecoration.none, fontSize: 14),
      );
    }
    return

        // testing streambuilder with dummy speech input

        //   StreamBuilder<String>(
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
        //
        //     text = text + snapshot.data!+" ";
        //     BackendApi.audioDat = text;
        //     return Text(text,textAlign: TextAlign.center,style: const TextStyle(decoration: TextDecoration.none, fontSize: 15,color: Colors.black),);
        //   },
        // );

        // real speech input

        StreamBuilder<StreamingRecognizeResponse>(
      key: Key(x.toString()),
      stream: AudioApi.api.realAudioStream(),
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
          for (var element in snapshot.data!.results) {
            String textOut = element.alternatives.first.transcript;
            if (element.isFinal) {
              text = text + textOut;
              finalFound = true;
            }
            if (element.stability > stability) {
              stability = element.stability;
              tempText = textOut;
            }
            // text = text + element.alternatives;
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
