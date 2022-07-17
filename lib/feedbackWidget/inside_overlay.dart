import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:talkback/main_api/mainapi.dart';

class InsideOverlay extends StatefulWidget {
  final BoxConstraints boxConstraints;
  final void Function()? onpressed;

  const InsideOverlay({Key? key, required this.boxConstraints, this.onpressed})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return InsideOverlayState();
  }
}

class InsideOverlayState extends State<InsideOverlay> {
  MainApi mainApi = MainApi();
  bool userDispose = false;
  String text = '';

  @override
  void initState() {
    print('init done');
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    if (!userDispose) {
      mainApi.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              color: Colors.blue.shade200,
              borderRadius: BorderRadius.circular(10)),
          height: widget.boxConstraints.maxHeight - 100,
          width: widget.boxConstraints.maxWidth,
          child: Center(
            child: SingleChildScrollView(
                padding: const EdgeInsets.all(15),
                child: StreamBuilder(
                  initialData: 'Text will appear here',
                  stream: mainApi.getStream(),
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    if (snapshot.data!.compareTo('Text will appear here') == 0){
                      return const Text(
                        'Text will appear here',
                        style: TextStyle(
                            decoration: TextDecoration.none, fontSize: 14),
                      );
                    }
                      text = text + snapshot.data!;
                    return Text(
                      text,
                      style: const TextStyle(
                          decoration: TextDecoration.none, fontSize: 14),
                    );
                  },
                )),
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
                  onpressed: () {
                    setState(() {

                      text = '';mainApi = MainApi();
                    });
                  },
                  text: 'Restart'),
              BottomButton(
                  onpressed: () async {
                    await mainApi.dispose();
                    userDispose = true;
                    widget.onpressed!();
                  },
                  text: 'OK')
            ],
          ),
        )
      ],
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
