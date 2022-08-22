import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:talkback/audio_manager/audioApi.dart';
import 'package:talkback/main_api/refreshttext.dart';

class InsideOverlay extends StatefulWidget {
  final BoxConstraints boxConstraints;
  final void Function()? onpressed;

  const InsideOverlay({Key? key, required this.boxConstraints, this.onpressed})
      : super(key: key);

  @override
  State<InsideOverlay> createState() => _InsideOverlayState();
}

class _InsideOverlayState extends State<InsideOverlay> {
  late Timer timeout;
  Future audiofuture = AudioApi.api.authinit();

  @override
  void initState() {
    timeout= Timer(const Duration(seconds: 35), () async {
      await AudioApi.api.cancelAll();
      if(mounted){
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
      builder: (cnp,_){
        return FutureBuilder(future:audiofuture, builder: (futurecontext,snapshot){
          if(snapshot.connectionState==ConnectionState.none)
            {
              widget.onpressed!();
            }
          if(snapshot.connectionState==ConnectionState.done) {
            return Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.blue.shade200,
                    borderRadius: BorderRadius.circular(30)),
                height: widget.boxConstraints.maxHeight - 100,
                width: widget.boxConstraints.maxWidth,
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(15),
                    child: Consumer<RefreshText>(builder: (cnp2,b,c){
                      return StreamTextWidget(widget.onpressed);
                    },),
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
                    BottomButton(onpressed: () async {

                      await Provider.of<RefreshText>(futurecontext,listen: false).refresh();

                    }, text: 'Restart'),
                    BottomButton(
                        onpressed: () async {
                          await AudioApi.api.cancelAll();
                          widget.onpressed!();
                        },
                        text: 'OK')
                  ],
                ),
              )
            ],
          );
          }
          return const CircularProgressIndicator(color: Colors.black,);
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
  final void Function()? onpressed;
  const StreamTextWidget(this.onpressed);

  @override
  State<StreamTextWidget> createState() => _StreamTextWidgetState();
}

class _StreamTextWidgetState extends State<StreamTextWidget> {

  late int x;


  @override
  void initState() {
    x=0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    String text = '';
    x++;

    if(x>4) {
      return  const Text(
        'Not allowed more than 3 times',
        style: TextStyle(decoration: TextDecoration.none, fontSize: 14),
      );
    }
    return StreamBuilder<String>(
      key: Key(x.toString()),
      initialData: 'Please Start Speaking',
      stream: AudioApi.api.output(),
      builder: (BuildContext ctx, AsyncSnapshot<String> snapshot) {
        if (snapshot.data!.compareTo('Please Start Speaking') == 0) {
          return const Text(
            'Please start speaking',
            style: TextStyle(decoration: TextDecoration.none, fontSize: 14),
          );
        }

        if(snapshot.connectionState==ConnectionState.done) {
          return const Text('SUBMITTING...', style: TextStyle(decoration: TextDecoration.none, fontSize: 14),);
        }
        text = text + snapshot.data!;

        return Text(
          text,
          style: const TextStyle(decoration: TextDecoration.none, fontSize: 14),
        );
      },
    );
  }
}

// FutureBuilder(
// future: mainApi.start(),
// builder: (futurecontext, snapshot) {
// if (snapshot.connectionState == ConnectionState.done) {
// return const Text(
// 'snapshot.data as String',
// style: TextStyle(
// decoration: TextDecoration.none,
// fontSize: 15,
// color: Colors.black),
// );
// }
// return const CircularProgressIndicator(
// color: Colors.black,
// );
// },
// ),
