import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/preferences.dart';
import '../pages/mode.dart';
import '../pages/settings.dart';
import '../utils/haptics.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 120,
              height: 120,
              padding: const EdgeInsets.only(bottom: 48),
              child: Provider.of<Preferences>(context).prefs['darkMode']
                  ? SvgPicture.asset('assets/icons/icon.svg')
                  : SvgPicture.asset('assets/icons/icon_dark.svg'),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 48),
              child: Text(
                'number alchemy',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            SizedBox(
              width: 168,
              child: ElevatedButton(
                onPressed: () {
                  hapticClick(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ModePage(gamemode: 0),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
                child: const Text(
                  'casual',
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 24),
              width: 168,
              child: ElevatedButton(
                onPressed: () {
                  hapticClick(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ModePage(gamemode: 1),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
                child: const Text(
                  'challenge',
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 24),
              width: 168,
              child: ElevatedButton(
                onPressed: () {
                  hapticClick(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
                child: const Text(
                  'settings',
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ),
            // Container(
            //   padding: const EdgeInsets.only(top: 24),
            //   width: 168,
            //   child: ElevatedButton(
            //     onPressed: () {
            //       hapticClick(context);
            //       Provider.of<Preferences>(context, listen: false)
            //           .setPref('tutorial', true, false);
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //           builder: (context) => const TutorialPage(),
            //         ),
            //       );
            //     },
            //     style: ElevatedButton.styleFrom(
            //       padding: const EdgeInsets.symmetric(vertical: 12),
            //       shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(24)),
            //     ),
            //     child: const Text(
            //       'tutorial',
            //       style: TextStyle(fontSize: 24),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
