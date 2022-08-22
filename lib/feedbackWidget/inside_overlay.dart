import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:talkback/main_api/mainapi.dart';
import 'package:talkback/main_api/refreshttext.dart';

class InsideOverlay extends StatelessWidget {
  final BoxConstraints boxConstraints;
  final void Function()? onpressed;

  const InsideOverlay({Key? key, required this.boxConstraints, this.onpressed})
      : super(key: key);

//   @override
//   State<StatefulWidget> createState() {
//     // TODO: implement createState
//     return InsideOverlayState();
//   }
// }
//
// class InsideOverlayState extends State<InsideOverlay> {
//
//
//
//
//   @override
//   void initState() {
//     print('init done');
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//   }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ChangeNotifierProvider(
      create: (BuildContext ctx) => RefreshText(),
      builder: (cnp,_){
        return Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.blue.shade200,
                  borderRadius: BorderRadius.circular(10)),
              height: boxConstraints.maxHeight - 100,
              width: boxConstraints.maxWidth,
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(15),
                  child: Consumer<RefreshText>(builder: (cnp2,b,c){
                    return StreamTextWidget();
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
              width: boxConstraints.maxWidth,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  BottomButton(onpressed: () {

                    Provider.of<RefreshText>(cnp,listen: false).refresh();

                  }, text: 'Restart'),
                  BottomButton(
                      onpressed: () async {
                        onpressed!();
                      },
                      text: 'OK')
                ],
              ),
            )
          ],
        );
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
  // const StreamTextWidget({Key? key}) : super(key: key);
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
    print(x);
    if(x>4) {
      return  const Text(
        'Not allowed more than 3 times',
        style: TextStyle(decoration: TextDecoration.none, fontSize: 14),
      );
    }
    return StreamBuilder<String>(
      key: Key(x.toString()),
      initialData: 'Please start speaking',
      stream: MainApi.getStream(),
      builder: (BuildContext ctx, AsyncSnapshot<String> snapshot) {
        if (snapshot.data!.compareTo('Please start speaking') == 0) {
          return const Text(
            'Please start speaking',
            style: TextStyle(decoration: TextDecoration.none, fontSize: 14),
          );
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
