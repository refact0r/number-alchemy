import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../models/casual_game.dart';

class CasualPage extends StatefulWidget {
  const CasualPage({super.key});

  @override
  State<CasualPage> createState() => _CasualPageState();
}

class _CasualPageState extends State<CasualPage> {
  static const opIcons = [
    Icon(CupertinoIcons.plus),
    Icon(CupertinoIcons.minus),
    Icon(CupertinoIcons.multiply),
    Icon(CupertinoIcons.divide)
  ];

  @override
  void initState() {
    super.initState();
    Provider.of<CasualGame>(context, listen: false).initialize(context);
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
                      Provider.of<CasualGame>(context, listen: false).hint,
                  color: colorScheme.onSurfaceVariant,
                  highlightColor:
                      colorScheme.onSurfaceVariant.withOpacity(0.08),
                  iconSize: 32,
                  icon: const Icon(Icons.lightbulb_outline_rounded),
                ),
                IconButton(
                  onPressed:
                      Provider.of<CasualGame>(context, listen: false).undo,
                  color: colorScheme.onSurfaceVariant,
                  highlightColor:
                      colorScheme.onSurfaceVariant.withOpacity(0.08),
                  iconSize: 32,
                  icon: const Icon(Icons.undo_rounded),
                ),
                IconButton(
                  onPressed:
                      Provider.of<CasualGame>(context, listen: false).reset,
                  color: colorScheme.onSurfaceVariant,
                  highlightColor:
                      colorScheme.onSurfaceVariant.withOpacity(0.08),
                  iconSize: 32,
                  icon: const Icon(Icons.restart_alt_rounded),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Consumer<CasualGame>(
                  builder: (context, casualGame, child) {
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
                            visible: casualGame.numShown[i],
                            child: Hero(
                              tag: 'num$i',
                              child: ElevatedButton(
                                onPressed: () {
                                  casualGame.pressNumButton(i);
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24)),
                                  primary: casualGame.numPressed[i]
                                      ? colorScheme.primaryContainer
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
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Consumer<CasualGame>(
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
