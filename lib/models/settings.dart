import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends ChangeNotifier {
  bool darkMode = true;
  SharedPreferences prefs;

  Settings(this.prefs) {
    getPrefs();
  }

  void setPref(darkMode) async {
    this.darkMode = darkMode;
    prefs.setBool('darkMode', darkMode);
    notifyListeners();
  }

  void getPrefs() async {
    darkMode = prefs.getBool('darkMode') ?? true;
    notifyListeners();
  }
}
