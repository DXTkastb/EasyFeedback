import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talkback/providers/user_provider.dart';
import 'package:talkback/services/storage_service.dart';
import 'package:talkback/widgets/custm_indicator.dart';

import '../../styles/user_button_styles.dart';

class LogoutAlertBox extends StatefulWidget {
  const LogoutAlertBox({Key? key}) : super(key: key);

  @override
  State<LogoutAlertBox> createState() => _LogoutAlertBoxState();
}

class _LogoutAlertBoxState extends State<LogoutAlertBox> {
  bool loggingOut = false;

  void logout() async {
    setState(() {
      loggingOut = true;
    });
    await Future.delayed(const Duration(seconds: 2));
    await StorageService.service.deleteToken();
    Provider.of<UserProvider>(context,listen: false).removeUserName();
    Navigator.of(context).pushNamedAndRemoveUntil('login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: AlertDialog(
        actionsAlignment: MainAxisAlignment.center,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        icon: const Icon(
          Icons.error_outline_outlined,
          size: 40,
          color: Colors.redAccent,
        ),
        title: const Text(
          'Are you sure?',
          style: TextStyle(fontSize: 17),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              if(loggingOut) return;
              Navigator.of(context).pop();
            },
            child: const Text('cancel'),
            style: UserButtonStyles.userButtonStyle,
          ),
          const SizedBox(
            width: 10,
          ),
          ElevatedButton(
            onPressed: logout,
            child: (loggingOut)
                ? const CustomIndicatorWidget()
                : const Text('logout'),
            style: UserButtonStyles.userButtonStyle,
          ),
        ],
      ),
    );
  }
}
