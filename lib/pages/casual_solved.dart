import 'package:flutter/material.dart';

import 'casual.dart';
import '../utils/time.dart';

class CasualSolvedPage extends StatefulWidget {
  final String heroTag;
  final int time;
  final String expression;

  const CasualSolvedPage(
      {super.key,
      required this.heroTag,
      required this.time,
      required this.expression});

  @override
  State<CasualSolvedPage> createState() => _CasualSolvedPageState();
}

class _CasualSolvedPageState extends State<CasualSolvedPage> {
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
              child: SizedBox(
                width: (MediaQuery.of(context).size.width - 72) / 2,
                height: (MediaQuery.of(context).size.width - 72) /
                    2, // <-- Your height
                child: Hero(
                  tag: widget.heroTag,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24)),
                    ),
                    child: const Text(
                      '24',
                      style: TextStyle(fontSize: 48),
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
                  child: Center(
                      child: Text('you solved it!',
                          style: Theme.of(context).textTheme.displaySmall)),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Center(
                      child: Text(widget.expression,
                          style: Theme.of(context).textTheme.headlineMedium)),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Center(
                      child: Text(msToString(widget.time),
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
                        builder: (context) => const CasualPage(),
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
