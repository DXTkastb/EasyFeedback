import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talkback/providers/user_provider.dart';
import 'package:talkback/styles/user_button_styles.dart';

import 'login_signup/logout_alert_box.dart';

class CustomAppDrawer extends StatelessWidget {
  const CustomAppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<UserProvider>(context);
    return Drawer(
      backgroundColor: const Color.fromRGBO(33, 69, 101, 1.0),
      child: Column(
        children: [
          DrawerHeader(
              child: Container(
                  decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black,
                          spreadRadius: 0.28,
                          blurRadius: 10,
                          offset: Offset(0, 7))
                    ],
                    borderRadius: BorderRadius.circular(13),
                    color: Colors.lightBlueAccent,
                  ),
                  alignment: Alignment.center,
                  child: Text(provider.username))),
          const Divider(
            height: 25,
            thickness: 1,
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed('my-feedbacks');
              // Future.delayed(const Duration(seconds: 2), () {
              //   Navigator.of(context).pushNamed('my-feedbacks');
              // });
              // Navigator.of(context).popAndPushNamed('my-feedbacks');
            },
            child: const Text('    My feebacks    '),
            style: UserButtonStyles.normalButtonSyle,
          ),
          const Expanded(child: SizedBox()),
          ElevatedButton(
            onPressed: () {
              showDialog(
                  context: context, builder: (ctx) => const LogoutAlertBox());
            },
            child: const Text('logout'),
            style: UserButtonStyles.userButtonStyle,
          ),
          const Divider(
            height: 15,
            thickness: 1,
          ),
        ],
      ),
    );
  }
}
