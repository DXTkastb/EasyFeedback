import 'package:flutter/material.dart';
import 'package:talkback/apis/main_api.dart';
import 'package:talkback/widgets/custm_indicator.dart';

class DataUploadSnackBar extends StatefulWidget {
  final String speech;
  final String link;
  final String phoneNum;
  const DataUploadSnackBar({Key? key, required this.speech, required this.link, required this.phoneNum}) : super(key: key);

  @override
  State<DataUploadSnackBar> createState() => _DataUploadSnackBarState();
}

class _DataUploadSnackBarState extends State<DataUploadSnackBar> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: BackendApi.sendSpeechData2(widget.speech,widget.link,widget.phoneNum),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if((snapshot.data as int) == 200) return const Text('feedback uploaded!');
            return const Text('feedback upload unsuccessful!. please try later');
          }
          return const Center(child: CustomIndicatorWidget());
        });
  }
}
