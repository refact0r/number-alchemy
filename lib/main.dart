import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:number_alchemy/pages/welcome.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/casual_game.dart';
import 'models/challenge_game.dart';
import 'models/preferences.dart';
import 'pages/home.dart';

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
          brightness: Provider.of<Preferences>(context).prefs['darkMode'] ? Brightness.dark : Brightness.light,
          fontFamily: 'Jost'),
      home: Provider.of<Preferences>(context, listen: false).prefs['tutorial'] ? const WelcomePage() : const HomePage(),
      // home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
