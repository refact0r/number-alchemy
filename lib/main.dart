import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'models/casual_game.dart';
import 'models/challenge_game.dart';
import 'models/preferences.dart';
import 'pages/mode.dart';
import 'pages/settings.dart';
import 'pages/tutorial.dart';
import 'utils/haptics.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  runApp(
    DevicePreview(
      enabled: kDebugMode,
      builder: (context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => ChallengeGame(context)),
          ChangeNotifierProvider(create: (context) => CasualGame(context)),
          ChangeNotifierProvider(create: (context) => Preferences(prefs)),
        ],
        child: const App(),
      ),
    ),
  );
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    return MaterialApp(
      title: "number alchemy",
      theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.cyanAccent,
          brightness: Provider.of<Preferences>(context).prefs['darkMode']
              ? Brightness.dark
              : Brightness.light,
          fontFamily: 'Jost'),
      home: Provider.of<Preferences>(context, listen: false).prefs['tutorial']
          ? const TutorialPage()
          : const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24)),
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
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24)),
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
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24)),
                ),
                child: const Text(
                  'settings',
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
                  Provider.of<Preferences>(context, listen: false)
                      .setPref('tutorial', true, false);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TutorialPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24)),
                ),
                child: const Text(
                  'tutorial',
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
