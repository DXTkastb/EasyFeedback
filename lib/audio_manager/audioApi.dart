import 'package:sound_stream/sound_stream.dart';

class AudioApi {
  AudioApi._constructor();
  static final AudioApi api= AudioApi._constructor();
  final RecorderStream _recorder = RecorderStream();

}