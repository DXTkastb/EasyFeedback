import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:talkback/grpc_client/my_client.dart';

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
  String str = 'a';

  void redo() {
    setState(() {
      str = str + str;
    });
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
                child: FutureBuilder(
                  future: MyClient.myClient.main(),
                  builder: (futurecontext, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Text(
                        snapshot.data as String,
                        style: const TextStyle(
                            decoration: TextDecoration.none,
                            fontSize: 15,
                            color: Colors.black),
                      );
                    }
                    return const CircularProgressIndicator(color: Colors.black,);
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
              BottomButton(onpressed: redo, text: 'Restart'),
              BottomButton(onpressed: widget.onpressed, text: 'OK')
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
