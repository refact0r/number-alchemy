import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../models/challenge_game.dart';

class ChallengePage extends StatefulWidget {
  const ChallengePage({super.key});

  @override
  State<ChallengePage> createState() => _ChallengePageState();
}

class _ChallengePageState extends State<ChallengePage>
    with TickerProviderStateMixin {
  static const opIcons = [
    Icon(CupertinoIcons.plus),
    Icon(CupertinoIcons.minus),
    Icon(CupertinoIcons.multiply),
    Icon(CupertinoIcons.divide)
  ];

  late final _fadeAnimation = AnimationController(
    value: 0,
    duration: const Duration(milliseconds: 800),
    vsync: this,
  );

  @override
  void initState() {
    super.initState();
    Provider.of<ChallengeGame>(context, listen: false)
        .initialize(context, _fadeAnimation);
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    Provider.of<ChallengeGame>(context, listen: false)
                        .timer
                        .cancel();
                    Navigator.pop(context);
                  },
                  color: colorScheme.onSurfaceVariant,
                  highlightColor:
                      colorScheme.onSurfaceVariant.withOpacity(0.08),
                  iconSize: 32,
                  icon: const Icon(Icons.clear_rounded),
                ),
                IconButton(
                  onPressed:
                      Provider.of<ChallengeGame>(context, listen: false).hint,
                  color: colorScheme.onSurfaceVariant,
                  highlightColor:
                      colorScheme.onSurfaceVariant.withOpacity(0.08),
                  iconSize: 32,
                  icon: const Icon(Icons.lightbulb_outline_rounded),
                ),
                IconButton(
                  onPressed:
                      Provider.of<ChallengeGame>(context, listen: false).undo,
                  color: colorScheme.onSurfaceVariant,
                  highlightColor:
                      colorScheme.onSurfaceVariant.withOpacity(0.08),
                  iconSize: 32,
                  icon: const Icon(Icons.undo_rounded),
                ),
                IconButton(
                  onPressed:
                      Provider.of<ChallengeGame>(context, listen: false).reset,
                  color: colorScheme.onSurfaceVariant,
                  highlightColor:
                      colorScheme.onSurfaceVariant.withOpacity(0.08),
                  iconSize: 32,
                  icon: const Icon(Icons.restart_alt_rounded),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Consumer<ChallengeGame>(
              builder: (context, challengeGame, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 128,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 6, horizontal: 12),
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceTint.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(challengeGame.timeString,
                              style: TextStyle(
                                  fontSize: 32, color: colorScheme.primary))),
                    ),
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: SizedBox(
                        width: 128,
                        child: Text(challengeGame.timeChangeString,
                            style: TextStyle(
                                fontSize: 32, color: colorScheme.primary)),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Consumer<ChallengeGame>(
                  builder: (context, challengeGame, child) {
                    return GridView.count(
                      primary: false,
                      crossAxisSpacing: 24,
                      mainAxisSpacing: 24,
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      children: <Widget>[
                        for (int i = 0; i < 4; i++)
                          Visibility(
                            visible: challengeGame.numShown[i],
                            child: Hero(
                              tag: 'num$i',
                              child: ElevatedButton(
                                onPressed: () {
                                  challengeGame.pressNumButton(i);
                                },
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(24)),
                                    primary: challengeGame.numPressed[i]
                                        ? colorScheme.primaryContainer
                                        : null),
                                child: Text(
                                  challengeGame.nums[i].toString(),
                                  style: const TextStyle(fontSize: 48),
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Consumer<ChallengeGame>(
              builder: (context, casualGame, child) {
                return Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    for (int i = 0; i < 4; i++)
                      Ink(
                        padding: const EdgeInsets.all(10),
                        decoration: ShapeDecoration(
                          color: casualGame.opPressed[i]
                              ? colorScheme.primaryContainer
                              : null,
                          shape: const CircleBorder(),
                        ),
                        child: IconButton(
                          iconSize: 36,
                          icon: opIcons[i],
                          color: colorScheme.onSurfaceVariant,
                          onPressed: () {
                            casualGame.pressOpButton(i);
                          },
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
