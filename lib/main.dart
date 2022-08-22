import 'package:flutter/material.dart';
import 'package:talkback/audio_manager/audioApi.dart';
import 'package:talkback/feedbackWidget/feedBackWidget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AudioApi.api.loadKeyAuth();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(alignment: Alignment.center,
      color: Colors.deepPurple,
        child:
        // Container(
        //   margin: const EdgeInsets.all(50),
        //   child:
        //  Column(
        //    mainAxisAlignment: MainAxisAlignment.spaceAround,
        //    children: [ TextButton(onPressed: () {
        //      AudioApi.api.authinit();
        //      //  AudioApi.api.output();
        //
        //
        //    },child : const Text('Press')),
        //      TextButton(onPressed: () {
        //
        //       Stream<String> stream = AudioApi.api.output();
        //       stream.listen((event) {print(event);});
        //
        //      },child : const Text('Press')),
        //      TextButton(onPressed: () {
        //
        //        AudioApi.api.cancelSubscription();
        //
        //
        //      },child : const Text('cancel')),
        //    ],
        //  )
        // )

        const FeedBackWidget(),

      ),
    );
  }



}
