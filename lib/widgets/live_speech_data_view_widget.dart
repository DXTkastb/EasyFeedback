import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talkback/widgets/custm_indicator.dart';
import 'package:talkback/widgets/speech_data_stream_widget.dart';

import '../providers/speech_data_provider.dart';

class LiveSpeechView extends StatelessWidget {
  const LiveSpeechView({Key? key}) : super(key: key);

  TextStyle getStyle() {
    return const TextStyle(
        decoration: TextDecoration.none, fontSize: 15, color: Colors.black);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SpeechDataProvider>(
      builder: (cnp2, spd, c) {
        return FutureBuilder(
            future: spd.startSpeechRecognition,
            builder: (futureContext, snapshot) {
              if (snapshot.hasError) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'some error occurred. please try later',
                      style: getStyle(),
                    ),
                    ElevatedButton(
                      onPressed: (){
                        spd.overlayPopFunction('');
                      },
                      child: const Text('OK'),
                    )
                  ],
                );
              }
              else if(snapshot.connectionState == ConnectionState.waiting) {
                return const CustomIndicatorWidget();
              }

              else if(spd.counter >= 3) {
                return  Text(
                  'Not allowed more than 3 times!',
                  style: getStyle(),
                );
              }
              return StreamSpeechDataWidget(key: const Key('speech-stream-widget'), retryCount: spd.counter, setStringFunction: spd.setSpeechData, streamCollected: (spd.recordState == 1));
            });

        // if (spd.recordState == -1) {}
        // if (spd.recordState > -1 && spd.counter < 3) {
        //   return StreamSpeechDataWidget(
        //     key: const Key('speech-stream-widget'),
        //     retryCount: spd.counter,
        //     setStringFunction: spd.setSpeechData,
        //     streamCollected: false,
        //   );
        // }
        //
        // return SubmitDataWidget(onpressed: spd.overlayPopFunction);
      },
    );
  }
}
