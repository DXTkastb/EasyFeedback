import 'package:flutter/material.dart';
import '/apis/audio_api.dart';
import '/widgets/feedback_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AudioApi.api.loadKeyAuthForUser();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: MyHomePage(linearGradient: const  LinearGradient(
        begin: Alignment.centerLeft ,
        colors: <Color>[Colors.white, Colors.lightBlueAccent],
      ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final Shader linearGradient;
  const MyHomePage({Key? key, required this.linearGradient}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      child: Scaffold(
        body: Container(
            alignment: Alignment.center,
            color: Colors.black,
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
            ),
            child:
                // fetch vendorID & Ordernumber From QR/Order Details(like UPI)
                // Ordernumber can be user's phone_number + order time
                Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children:  [
                Text(
                  "Bored of typing feedbacks or giving long surveys?\nTell us about your last meal. What you liked and disliked.",
                  textScaleFactor: 3.2,
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    // color: const Color.fromRGBO(220, 220, 220, 1.0),
                    foreground: Paint()..shader = linearGradient
                  ),
                ),
                const FeedBackWidget(
                  vendrID: 12345,
                ),
              ],
            )),
      ),
    );
  }
}
