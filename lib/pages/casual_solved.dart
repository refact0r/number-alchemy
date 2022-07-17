import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'casual.dart';
import '../utils/time.dart';

class CasualSolvedPage extends StatefulWidget {
  final heroTag;
  final time;

  const CasualSolvedPage(
      {super.key, @required this.heroTag, @required this.time});

  @override
  State<CasualSolvedPage> createState() => _CasualSolvedPageState();
}

class _CasualSolvedPageState extends State<CasualSolvedPage> {
  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                  child: Text('you solved it!',
                      style: TextStyle(
                          fontSize: 24, color: colorScheme.onSurfaceVariant))),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                  child: Text('time elapsed: ${msToString(widget.time)}',
                      style: TextStyle(
                          fontSize: 24, color: colorScheme.onSurfaceVariant))),
            ),
          ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
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
                        builder: (context) => const CasualPage(),
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
