import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:talkback/providers/user_provider.dart';
import 'package:talkback/services/auth_service.dart';
import 'package:talkback/services/storage_service.dart';
import 'package:talkback/widgets/app_drawer.dart';
import 'package:talkback/widgets/login_signup/main_screen.dart';
import 'package:talkback/widgets/network_error_screen.dart';
import 'package:talkback/widgets/personal_feedbacks_screen.dart';
import 'package:talkback/widgets/scan_view.dart';

import '/widgets/feedback_widget.dart';
import 'apis/audio_api.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  await AudioApi.api.loadKeyAuthForUser();
  await StorageService.service.init();

  var response = await AuthService.service.userLoggedIn();

  runApp(MyApp(code: response.statusCode, data: response.body));
}

class MyApp extends StatelessWidget {
  final String data;
  final int code;

  const MyApp({Key? key, required this.code, required this.data})
      : super(key: key);

  String getInitialRoute() {
    if (code == 200)
      return 'home-page';
    else if (code == 100) return 'server-error';
    return 'login';
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserProvider>(
      create: (_) => UserProvider()..setUserNamePhoneNumber(data),
      child: MaterialApp(
        routes: {
          'scan-qr': (_) => const ScanView(),
          'home-page': (_) => const MyHomePage(),
          'login': (_) => const MainScreen(),
          'server-error': (_) => const NetworkErrorScreenWidget(),
          'my-feedbacks': (_) => const PersonalFeedbacksView(),
        },
        debugShowCheckedModeBanner: false,
        initialRoute: getInitialRoute(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
        ),
        drawer: const CustomAppDrawer(),
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
              children: [
                Text(
                  "Bored of typing feedbacks or giving long surveys?\nScan the outlet's QR and tell us about your meal. What you liked and disliked.",
                  textScaleFactor: 3.2,
                  style: TextStyle(
                      fontWeight: FontWeight.w900,
                      foreground: Paint()
                        ..shader = const LinearGradient(
                          begin: Alignment.centerLeft,
                          colors: <Color>[Colors.white, Colors.lightBlueAccent],
                        ).createShader(
                            const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0))),
                ),
                const FeedBackWidget(),
              ],
            )),
      ),
    );
  }
}
