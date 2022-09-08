import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talkback/notifiers/toggle_signup_login.dart';
import 'package:talkback/widgets/login_signup/singup.dart';

import 'login.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(204, 211, 252, 1.0),
      body: Center(
        child: SizedBox(
            width: size.width * 0.75,
            child: ChangeNotifierProvider<ToggleSingupLogin>(
                create: (_) => ToggleSingupLogin(),
                builder: (ctx, wid) {
                  return Consumer<ToggleSingupLogin>(
                      builder: (ctx2, tsl, wid) => (tsl.showLogin)
                          ? const LoginFormWidget()
                          : const SingupFormWidget());
                })),
      ),
    );
  }
}
