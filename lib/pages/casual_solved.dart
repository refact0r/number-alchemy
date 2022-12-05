import 'package:flutter/material.dart';

import '../utils/haptics.dart';
import 'casual.dart';
import '../utils/time.dart';

class CasualSolvedPage extends StatelessWidget {
  final String heroTag;
  final int time;
  final String expression;
  final int target;
  final int mode;

  const CasualSolvedPage(
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
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      'you solved it!',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      expression,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      msToString(time),
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                ],
              ),
              const Spacer(flex: 1),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    iconSize: 36,
                    icon: const Icon(Icons.clear_rounded),
                    color: colorScheme.onSurfaceVariant,
                    onPressed: () {
                      hapticClick(context);
                      Navigator.pop(context);
                    },
                  ),
                  IconButton(
                    iconSize: 36,
                    icon: const Icon(Icons.arrow_forward_rounded),
                    color: colorScheme.onSurfaceVariant,
                    onPressed: () {
                      hapticClick(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CasualPage(mode: mode),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
