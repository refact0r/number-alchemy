import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'challenge.dart';

class ChallengeResultsPage extends StatefulWidget {
  final solvedCount;

  const ChallengeResultsPage({super.key, @required this.solvedCount});

  @override
  State<ChallengeResultsPage> createState() => _ChallengeResultsPageState();
}

class _ChallengeResultsPageState extends State<ChallengeResultsPage> {
  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                  child: Text("time's up!",
                      style: TextStyle(
                          fontSize: 24, color: colorScheme.onSurfaceVariant))),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                  child: Text('you solved ${widget.solvedCount} problems',
                      style: TextStyle(
                          fontSize: 24, color: colorScheme.onSurfaceVariant))),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  iconSize: 48,
                  icon: const Icon(Icons.clear_rounded),
                  color: colorScheme.onSurfaceVariant,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                IconButton(
                  iconSize: 48,
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
          ),
        ],
      ),
    );
  }
}
