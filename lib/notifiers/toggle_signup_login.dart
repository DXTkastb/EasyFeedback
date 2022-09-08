import 'package:flutter/material.dart';

class ToggleSingupLogin extends ChangeNotifier{
  bool showLogin = true;
  void toggle(){
    showLogin = !showLogin;
    notifyListeners();
  }
}