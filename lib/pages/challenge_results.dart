import 'package:flutter/material.dart';

import 'challenge.dart';

class ChallengeResultsPage extends StatefulWidget {
  final int solvedCount;

  const ChallengeResultsPage({super.key, required this.solvedCount});

  @override
  State<ChallengeResultsPage> createState() => _ChallengeResultsPageState();
}

class _ChallengeResultsPageState extends State<ChallengeResultsPage> {
  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 36, 24, 36),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const Spacer(flex: 1),
            Center(
              child: Hero(
                tag: 'timer',
                child: Material(
                  type: MaterialType.transparency,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceTint.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(' 0:00 ',
                        style: TextStyle(
                            fontSize: 48, color: colorScheme.primary)),
                  ),
                ),
              ),
            ),
            const Spacer(flex: 1),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Center(
                      child: Text("time's up!",
                          style: Theme.of(context).textTheme.displaySmall)),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Center(
                      child: Text('${widget.solvedCount} problems solved',
                          style: Theme.of(context).textTheme.headlineMedium)),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Center(
                      child: Text('high score: 10',
                          style: Theme.of(context).textTheme.headlineMedium)),
                ),
              ],
            ),
            const Spacer(flex: 1),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  iconSize: 36,
                  icon: const Icon(Icons.clear_rounded),
                  color: colorScheme.onSurfaceVariant,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                IconButton(
                  iconSize: 36,
                  icon: const Icon(Icons.arrow_forward_rounded),
                  color: colorScheme.onSurfaceVariant,
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChallengePage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
