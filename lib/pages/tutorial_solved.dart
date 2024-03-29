import 'package:flutter/material.dart';
import 'package:number_alchemy/pages/tutorial.dart';
import 'package:number_alchemy/pages/tutorial2.dart';
import 'package:provider/provider.dart';

import '../models/preferences.dart';
import '../utils/haptics.dart';
import '../utils/time.dart';
import 'home.dart';

class TutorialSolvedPage extends StatelessWidget {
  final String heroTag;
  final int time;
  final String expression;
  final int target;
  final int mode;

  const TutorialSolvedPage(
      {super.key,
      required this.heroTag,
      required this.time,
      required this.expression,
      required this.target,
      required this.mode});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 450),
          padding: const EdgeInsets.fromLTRB(24, 36, 24, 36),
          child: Column(
            children: [
              const Spacer(flex: 1),
              Center(
                child: SizedBox(
                  width: (MediaQuery.of(context).size.width - 72) / 2,
                  height: (MediaQuery.of(context).size.width - 72) / 2, // <-- Your height
                  child: Hero(
                    tag: heroTag,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      ),
                      child: Text(
                        target.toString(),
                        style: const TextStyle(fontSize: 48),
                      ),
                    ),
                  ),
                ),
              ),
              const Spacer(flex: 1),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(18),
                    child: Text(
                      'you solved it!',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18),
                    child: Text(
                      expression,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18),
                    child: Text(
                      msToString(time),
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                ],
              ),
              const Spacer(flex: 1),
              if (mode == -2)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
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
              ElevatedButton(
                onPressed: () {
                  hapticClick(context);
                  if (mode == -2) {
                    Provider.of<Preferences>(context, listen: false).setPref('tutorial', false, false);
                  }
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => mode == -1 ? const TutorialPage2() : const HomePage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
                child: Text(
                  mode == -1 ? 'continue' : 'finish tutorial',
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
