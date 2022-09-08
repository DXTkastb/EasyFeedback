import 'package:flutter/material.dart';

class UserButtonStyles {
  static ButtonStyle userButtonStyle = ButtonStyle(
      padding: const MaterialStatePropertyAll(EdgeInsets.all(18)),
      backgroundColor:
          const MaterialStatePropertyAll(Color.fromRGBO(23, 84, 126, 1.0)),
      shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))));

  static ButtonStyle normalButtonSyle = ButtonStyle(
      padding: const MaterialStatePropertyAll(EdgeInsets.all(25)),
      backgroundColor:
          const MaterialStatePropertyAll(Color.fromRGBO(10, 57, 89, 1.0)),
      shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))));

}
