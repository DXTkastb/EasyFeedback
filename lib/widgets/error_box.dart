import 'package:flutter/material.dart';
import 'package:talkback/styles/user_button_styles.dart';

class ErrorBox extends StatelessWidget{
  final String errorMessage;
  final void Function(String data)? onpressed;
  const ErrorBox({Key? key, required this.errorMessage, this.onpressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(errorMessage,style: const TextStyle(
            decoration: TextDecoration.none,color: Colors.black,
            fontSize: 15
          ),),
        ),
        ElevatedButton(onPressed: (){
          (onpressed!)('');
        },child: Text('OK'),style: UserButtonStyles.userButtonStyle,)
      ],
    );
  }
}