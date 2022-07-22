import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends ChangeNotifier {
  bool darkMode = true;

  Settings() {
    getPrefs();
  }

  void setPref(darkMode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.darkMode = darkMode;
    prefs.setBool('darkMode', darkMode);
    notifyListeners();
  }

  void getPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    darkMode = prefs.getBool('darkMode') ?? true;
  }
}
