import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talkback/providers/user_provider.dart';
import 'package:talkback/services/auth_service.dart';
import 'package:talkback/services/storage_service.dart';
import 'package:talkback/widgets/custm_indicator.dart';
import 'package:http/http.dart' as http;
import '../../notifiers/toggle_signup_login.dart';
import '../../services/validators.dart';
import '../../styles/input_decorations.dart';
import '../../styles/user_button_styles.dart';

class SingupFormWidget extends StatefulWidget {
  const SingupFormWidget({Key? key}) : super(key: key);

  @override
  State<SingupFormWidget> createState() => _SingupFormWidgetState();
}

class _SingupFormWidgetState extends State<SingupFormWidget> {
  late final TextEditingController tec1;
  late final TextEditingController tec2;
  late final TextEditingController tec3;
  late bool processing;

  final _formKey = GlobalKey<FormState>();

  void onSubmitPress() async {
    WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    if (!(_formKey.currentState!.validate())) return;
    setState(() {
      processing = true;
    });
    // Implicates RestCall !!
    await Future.delayed(const Duration(seconds: 2));
    var response = null;
    try
    {
      response = await AuthService.service.signup(
          phoneNumber: tec1.value.text,
          password: tec3.value.text,
          username: tec2.value.text);

    }
    catch(e) {
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                'Some error occurred. Please check your network connection.')));
        setState(() {
          processing = false;
        });
      }
      return;
    }

    if((response as http.Response).statusCode == 200) {
      await StorageService.service.saveToken(response.headers['auth-token']!);
      if(mounted){
        WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
        Provider.of<UserProvider>(context, listen: false)
            .setUserNamePhoneNumber(response.body);
        Navigator.of(context).pushReplacementNamed('home-page');
      }
    }
    else {
      if(mounted)
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text(response.headers['error']!)));
    }
    if(mounted) {
      setState(() {
      processing = false;
    });
    }

  }


  @override
  void initState() {
    super.initState();
    tec1 = TextEditingController();
    tec2 = TextEditingController();
    tec3 = TextEditingController();
    processing = false;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            decoration: InputDecorations.phonenumberDecoration,
            controller: tec1,
            maxLength: 10,
            validator: Validators.phoneValidator,
          ),
          TextFormField(
            decoration: InputDecorations.usernameDecoration,
            controller: tec2,
            maxLength: 20,
            validator: Validators.usernameValidator,
          ),
          TextFormField(
            decoration: InputDecorations.passwordDecoration,
            controller: tec3,
            maxLength: 15,
            obscureText: true,
            validator: Validators.passwordValidator,
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              (processing)
                  ? ElevatedButton(
                  onPressed: () {},style: UserButtonStyles.userButtonStyle,
                  child: const CustomIndicatorWidget())
                  : ElevatedButton(
                onPressed: onSubmitPress,style: UserButtonStyles.userButtonStyle,
                child: const Text('submit'),
              ),
              ElevatedButton(onPressed: processing?null:(){
                Provider.of<ToggleSingupLogin>(context,listen: false).toggle();
              }, style: UserButtonStyles.userButtonStyle, child: const Text('login')),
            ],
          )
        ],
      ),
    );
  }
}
