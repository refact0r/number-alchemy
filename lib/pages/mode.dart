import 'package:flutter/material.dart';

import '../utils/haptics.dart';
import '../utils/time.dart';
import 'casual.dart';
import 'challenge.dart';

class ModePage extends StatefulWidget {
  final int gamemode;

  const ModePage({super.key, required this.gamemode});

  @override
  State<ModePage> createState() => _ModePageState();
}

class _ModePageState extends State<ModePage> {
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      hapticClick(context);
                      Navigator.pop(context);
                    },
                    color: colorScheme.onSurfaceVariant,
                    highlightColor:
                        colorScheme.onSurfaceVariant.withOpacity(0.08),
                    iconSize: 32,
                    icon: const Icon(Icons.clear_rounded),
                  ),
                  Text('mode',
                      style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(width: 48),
                ],
              ),
              const Spacer(flex: 1),
              Column(
                children: [
                  SizedBox(
                    width: 240,
                    child: ElevatedButton(
                      onPressed: () {
                        hapticClick(context);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => widget.gamemode == 0
                                ? const CasualPage(mode: 0)
                                : const ChallengePage(mode: 0),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24)),
                      ),
                      child: const Text(
                        'classic 24',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 24),
                    width: 240,
                    child: ElevatedButton(
                      onPressed: () {
                        hapticClick(context);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => widget.gamemode == 0
                                ? const CasualPage(mode: 1)
                                : const ChallengePage(mode: 1),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24)),
                      ),
                      child: const Text(
                        'random 1 - 100',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}
