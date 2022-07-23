import 'package:flutter/material.dart';
import 'package:number_alchemy/utils/time.dart';
import 'package:provider/provider.dart';

import '../models/preferences.dart';
import 'challenge.dart';

class ChallengeResultsPage extends StatefulWidget {
  final int solvedCount;
  final int secondsElapsed;

  const ChallengeResultsPage(
      {super.key, required this.solvedCount, required this.secondsElapsed});

  @override
  State<ChallengeResultsPage> createState() => _ChallengeResultsPageState();
}

class _ChallengeResultsPageState extends State<ChallengeResultsPage> {
  late int highscore;

  @override
  void initState() {
    super.initState();
    highscore =
        Provider.of<Preferences>(context, listen: false).prefs['highscore'];
    if (widget.solvedCount > highscore) {
      Provider.of<Preferences>(context, listen: false)
          .setPref('highscore', widget.solvedCount, false);
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
                    child: Text(
                      ' 0:00 ',
                      style:
                          TextStyle(fontSize: 48, color: colorScheme.primary),
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
                    "time's up!",
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    '${widget.solvedCount} problem${widget.solvedCount == 1 ? '' : 's'} solved',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    widget.solvedCount > highscore
                        ? 'new high score!'
                        : 'high score: $highscore',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'total time: ${secondsToString(widget.secondsElapsed)}',
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
