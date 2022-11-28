import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/casual_game.dart';

class TutorialPage2 extends StatefulWidget {
  const TutorialPage2({super.key});

  @override
  State<TutorialPage2> createState() => _TutorialPage2State();
}

class _TutorialPage2State extends State<TutorialPage2> {
  static const opIcons = [CupertinoIcons.plus, CupertinoIcons.minus, CupertinoIcons.multiply, CupertinoIcons.divide];

  @override
  void initState() {
    super.initState();
    Provider.of<CasualGame>(context, listen: false).initialize(context, -2);
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 450),
          padding: const EdgeInsets.fromLTRB(24, 36, 24, 24),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Spacer(),
                  Column(
                    children: [
                      IconButton(
                        onPressed: () {
                          Provider.of<CasualGame>(context, listen: false).hint();
                        },
                        color: colorScheme.onSurfaceVariant,
                        highlightColor: colorScheme.onSurfaceVariant.withOpacity(0.08),
                        iconSize: 32,
                        icon: const Icon(Icons.lightbulb_outline_rounded),
                      ),
                      const Text('hint', style: TextStyle(fontSize: 18)),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    children: [
                      IconButton(
                        onPressed: () {
                          Provider.of<CasualGame>(context, listen: false).undo();
                        },
                        color: colorScheme.onSurfaceVariant,
                        highlightColor: colorScheme.onSurfaceVariant.withOpacity(0.08),
                        iconSize: 32,
                        icon: const Icon(Icons.undo_rounded),
                      ),
                      const Text('undo', style: TextStyle(fontSize: 18)),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    children: [
                      IconButton(
                        onPressed: () {
                          Provider.of<CasualGame>(context, listen: false).reset(true);
                        },
                        color: colorScheme.onSurfaceVariant,
                        highlightColor: colorScheme.onSurfaceVariant.withOpacity(0.08),
                        iconSize: 32,
                        icon: const Icon(Icons.settings_backup_restore_rounded),
                      ),
                      const Text('reset', style: TextStyle(fontSize: 18)),
                    ],
                  ),
                  const Spacer(),
                ],
              ),
              const Spacer(flex: 2),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceTint.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  ' ${Provider.of<CasualGame>(context, listen: false).target} ',
                  style: TextStyle(fontSize: 32, color: colorScheme.primary),
                ),
              ),
              const Spacer(flex: 1),
              Container(
                padding: const EdgeInsets.fromLTRB(0, 6, 0, 0),
                child: const Text(
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                  'Now try another problem.',
                ),
              ),
              const Spacer(flex: 1),
              Center(
                child: Consumer<CasualGame>(
                  builder: (context, casualGame, child) {
                    return GridView.count(
                      primary: false,
                      crossAxisSpacing: 24,
                      mainAxisSpacing: 24,
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      children: <Widget>[
                        for (int i = 0; i < 4; i++)
                          Visibility(
                            visible: casualGame.numShown[i],
                            child: Hero(
                              tag: 'num$i',
                              child: ElevatedButton(
                                onPressed: () {
                                  casualGame.pressNumButton(i, true);
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                  backgroundColor: casualGame.numPressed[i] ? colorScheme.primaryContainer : null,
                                ),
                                child: Text(
                                  casualGame.nums[i].toString(),
                                  style: const TextStyle(fontSize: 48),
                                ),
                              ),
                            ),
                          )
                      ],
                    );
                  },
                ),
              ),
              const Spacer(flex: 3),
              Consumer<CasualGame>(
                builder: (context, casualGame, child) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for (int i = 0; i < 4; i++)
                        SizedBox(
                          width: 66,
                          height: 66,
                          child: ElevatedButton(
                            onPressed: () {
                              casualGame.pressOpButton(i, true);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: casualGame.opPressed[i] ? colorScheme.primaryContainer : null,
                            ),
                            child: Icon(opIcons[i], size: 36),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
