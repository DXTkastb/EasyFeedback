import 'package:flutter/material.dart';

class RefreshText extends ChangeNotifier{
  void refresh(){
    notifyListeners();
  }
}