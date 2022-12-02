import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences extends ChangeNotifier {
  final SharedPreferences _prefs;
  Map prefs = {
    'darkMode': true,
    'haptics': true,
    'highscore_classic': 0,
    'highscore_random': 0,
    'tutorial': true,
  };

  Preferences(this._prefs) {
    getPrefs();
  }

  void setPref(String pref, value, bool update) async {
    prefs[pref] = value;
    if (value.runtimeType == bool) {
      _prefs.setBool(pref, value);
    } else if (value.runtimeType == int) {
      _prefs.setInt(pref, value);
    } else if (value.runtimeType == double) {
      _prefs.setDouble(pref, value);
    } else if (value.runtimeType == String) {
      _prefs.setString(pref, value);
    } else {
      throw Exception('Unsupported type');
    }
    if (update) {
      notifyListeners();
    }
  }

  void getPrefs() async {
    for (String pref in prefs.keys) {
      if (_prefs.containsKey(pref)) {
        prefs[pref] = _prefs.get(pref);
      } else {
        setPref(pref, prefs[pref], false);
      }
    }
    notifyListeners();
  }
}
