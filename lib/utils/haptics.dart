import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../models/preferences.dart';

void hapticClick(context) {
  if (Provider.of<Preferences>(context, listen: false).prefs['haptics']) {
    HapticFeedback.selectionClick();
  }
}

void hapticVibrate(context) {
  if (Provider.of<Preferences>(context, listen: false).prefs['haptics']) {
    HapticFeedback.vibrate();
  }
}
