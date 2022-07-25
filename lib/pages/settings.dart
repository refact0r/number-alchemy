import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../models/preferences.dart';
import '../utils/haptics.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 36, 24, 36),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    hapticClick(context);
                    Navigator.pop(context);
                  },
                  color: colorScheme.onSurfaceVariant,
                  highlightColor:
                      colorScheme.onSurfaceVariant.withOpacity(0.08),
                  iconSize: 32,
                  icon: const Icon(Icons.clear_rounded),
                ),
                Text('settings',
                    style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(width: 48),
              ],
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Consumer<Preferences>(
                    builder: (context, preferences, child) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'dark mode',
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                              Switch(
                                value: preferences.prefs['darkMode'],
                                onChanged: (value) {
                                  hapticClick(context);
                                  preferences.setPref('darkMode', value, true);
                                },
                                activeColor: colorScheme.primary,
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 24),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'haptic feedback',
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                ),
                                Switch(
                                  value: preferences.prefs['haptics'],
                                  onChanged: (value) {
                                    if (!Provider.of<Preferences>(
                                      context,
                                      listen: false,
                                    ).prefs['haptics']) {
                                      HapticFeedback.selectionClick();
                                    }
                                    preferences.setPref('haptics', value, true);
                                  },
                                  activeColor: colorScheme.primary,
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
