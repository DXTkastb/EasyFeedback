import 'dart:async';

import 'package:mic_stream/mic_stream.dart';


class AudioApi {
  AudioApi._constructor();
  static final AudioApi api= AudioApi._constructor();
  StreamSubscription<List<int>>? listener;
  late Stream<List<int>> stream;

 Future<void> init() async {
  stream = (await MicStream.microphone(audioSource:AudioSource.MIC,sampleRate: 48000,channelConfig: ChannelConfig.CHANNEL_IN_MONO,audioFormat: AudioFormat.ENCODING_PCM_16BIT)) as Stream<List<int>>;
 }

   void startStream()  {
   listener = stream.listen((samples) => print('0'),onDone: (){
     print('onDone Called!');
   });
 }


 Future<void> endStream() async {
   if(listener!=null) {
     await listener?.cancel();
   }
 }
}