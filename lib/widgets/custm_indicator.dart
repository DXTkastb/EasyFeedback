import 'package:flutter/material.dart';

class CustomIndicatorWidget extends StatelessWidget{
  const CustomIndicatorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(height: 15,width: 15,child: CircularProgressIndicator(color: Colors.white,strokeWidth: 1,),);
  }
}