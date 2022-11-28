import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/casual_game.dart';

class TutorialPage extends StatefulWidget {
  const TutorialPage({super.key});

  @override
  State<TutorialPage> createState() => _TutorialPageState();
}

class _TutorialPageState extends State<TutorialPage> {
  static const opIcons = [CupertinoIcons.plus, CupertinoIcons.minus, CupertinoIcons.multiply, CupertinoIcons.divide];
  int sequence = -1;

  @override
  void initState() {
    super.initState();
    Provider.of<CasualGame>(context, listen: false).initialize(context, -1);
  }

  bool numButtonEnabled(i) {
    return ((i == 0 && sequence == 0) ||
        (i == 1 && sequence == 2) ||
        (i == 2 && sequence == 4) ||
        (i == 3 && sequence == 6));
  }

  bool opButtonEnabled(i) {
    return ((i == 0 && (sequence == 1 || sequence == 3)) || (i == 2 && sequence == 5));
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 450),
              padding: const EdgeInsets.fromLTRB(24, 30, 24, 12),
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
                              if (Provider.of<CasualGame>(context, listen: false).hintShown == 1) {
                                sequence = 2;
                              } else if (Provider.of<CasualGame>(context, listen: false).hintShown == 2) {
                                sequence = 4;
                              } else if (Provider.of<CasualGame>(context, listen: false).hintShown == 3) {
                                sequence = 6;
                              }
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
                              if (sequence == 3 || sequence == 4) {
                                sequence = 2;
                              } else if (sequence == 5 || sequence == 6) {
                                sequence = 4;
                              }
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
                              sequence = 0;
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
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
                      Container(
                        padding: const EdgeInsets.fromLTRB(0, 6, 0, 0),
                        child: Text(
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18),
                          sequence == -1
                              ? 'The goal is to create this number by combining the 4 numbers below.'
                              : 'Follow the outlined buttons.\n',
                        ),
                      ),
                    ],
                  ),
                  const Spacer(flex: 2),
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
                                      if (numButtonEnabled(i)) {
                                        casualGame.pressNumButton(i, true);
                                        sequence++;
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                      backgroundColor: casualGame.numPressed[i] ? colorScheme.primaryContainer : null,
                                      side: numButtonEnabled(i)
                                          ? BorderSide(
                                              width: 4, // thickness
                                              color: colorScheme.primary, // color
                                            )
                                          : null,
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
                                  if (opButtonEnabled(i)) {
                                    casualGame.pressOpButton(i, true);
                                    sequence++;
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: casualGame.opPressed[i] ? colorScheme.primaryContainer : null,
                                  side: opButtonEnabled(i)
                                      ? BorderSide(
                                          width: 4, // thickness
                                          color: colorScheme.primary, // color
                                        )
                                      : null,
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
          if (sequence == -1)
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                sequence++;
                setState(() {});
              },
            ),
        ],
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   ColorScheme colorScheme = Theme.of(context).colorScheme;

  //   return Scaffold(
  //     body: Padding(
  //       padding: const EdgeInsets.fromLTRB(24, 36, 24, 36),
  //       child: ElevatedButton(
  //         onPressed: () {
  //           hapticClick(context);
  //           Provider.of<Preferences>(context, listen: false)
  //               .setPref('tutorial', false, false);
  //           Navigator.pushReplacement(
  //             context,
  //             MaterialPageRoute(
  //               builder: (context) => const HomePage(),
  //             ),
  //           );
  //         },
  //         child: Text('finish tutorial'),
  //       ),
  //     ),
  //   );
  // }
}
