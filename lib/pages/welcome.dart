import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:number_alchemy/pages/tutorial.dart';
import 'package:provider/provider.dart';

import '../models/preferences.dart';
import '../utils/haptics.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                'welcome to \nnumber alchemy!',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
            ),
            ElevatedButton(
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
                'begin tutorial',
                style: TextStyle(fontSize: 24),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
