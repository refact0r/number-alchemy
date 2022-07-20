import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'models/casual_game.dart';
import 'models/challenge_game.dart';
import 'pages/casual.dart';
import 'pages/challenge.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    var theme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorSchemeSeed: Colors.cyan,
    );
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => ChallengeGame(context)),
          ChangeNotifierProvider(create: (context) => CasualGame(context)),
        ],
        child: MaterialApp(
          title: "number alchemy",
          theme: theme.copyWith(
              textTheme: GoogleFonts.jostTextTheme(theme.textTheme)),
          home: const HomePage(),
          debugShowCheckedModeBanner: false,
        ));
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CasualPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24)),
                  ),
                  child: const Text('casual', style: TextStyle(fontSize: 24))),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: SizedBox(
                width: 168,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChallengePage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24)),
                    ),
                    child: const Text('challenge',
                        style: TextStyle(fontSize: 24))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
