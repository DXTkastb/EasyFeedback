import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talkback/widgets/speech_buttons.dart';

import '../apis/audio_api.dart';
import '../providers/speech_data_provider.dart';

class ButtonBlock extends StatelessWidget {
  const ButtonBlock({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<SpeechDataProvider>(
      builder: (ctx, spd, wid) {
        return SizedBox(
          height: 50,
          width: 400,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              BottomButton(
                  onpressed: (spd.recordState == -1)
                      ? null
                      : () async {
                          AudioApi.api.closeAllConnections();
                          spd.overlayPopFunction('');
                        },
                  color: Colors.redAccent,
                  icon: Icons.cancel,
                  text: 'Cancel'),
              BottomButton(
                  onpressed: (spd.recordState == -1)
                      ? null
                      : () async {
                          spd.refresh();
                        },
                  color: Colors.black,
                  icon: Icons.refresh,
                  text: 'Restart'),
              BottomButton(
                  onpressed: (spd.recordState == -1)
                      ? null
                      : () async {
                          if (spd.recordState == 1) {
                            // pop with a future of rest call!
                            AudioApi.api.closeAllConnections();
                            String data = spd.speechData;
                            spd.overlayPopFunction(data);
                          } else {
                            spd.doneRecording();
                          }
                        },
                  color: Colors.green,
                  icon: Icons.check_circle_rounded,
                  text: ((spd.recordState == 1)) ? 'Submit' : 'Done')
            ],
          ),
        );
      },
    );
  }
}
