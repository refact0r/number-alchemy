import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/preferences.dart';
import '../utils/haptics.dart';
import 'tutorial.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $uri';
    }
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
                  highlightColor: colorScheme.onSurfaceVariant.withOpacity(0.08),
                  iconSize: 32,
                  icon: const Icon(Icons.clear_rounded),
                ),
                Text('settings', style: Theme.of(context).textTheme.headlineMedium),
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
                                style: Theme.of(context).textTheme.headlineSmall,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  if (preferences.prefs['haptics']) {
                                    HapticFeedback.selectionClick();
                                  }
                                  preferences.setPref('darkMode', !preferences.prefs['darkMode'], true);
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                                ),
                                child: Text(
                                  preferences.prefs['darkMode'] ? 'on' : 'off',
                                  style: const TextStyle(fontSize: 24),
                                ),
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
                                  style: Theme.of(context).textTheme.headlineSmall,
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    if (!preferences.prefs['haptics']) {
                                      HapticFeedback.selectionClick();
                                    }
                                    preferences.setPref('haptics', !preferences.prefs['haptics'], true);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                                  ),
                                  child: Text(
                                    preferences.prefs['haptics'] ? 'on' : 'off',
                                    style: const TextStyle(fontSize: 24),
                                  ),
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
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: () {
                  hapticClick(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TutorialPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
                child: const Text(
                  'replay tutorial',
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.only(bottom: 12)),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: () {
                  _launchUrl('https://github.com/refact0r/number-alchemy/blob/main/PRIVACY-POLICY.md');
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
                child: const Text(
                  'privacy policy',
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
