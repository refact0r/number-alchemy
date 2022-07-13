import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'casual.dart';

class SolvedPage extends StatefulWidget {
  final heroTag;

  const SolvedPage({super.key, @required this.heroTag});

  @override
  State<SolvedPage> createState() => _SolvedPageState();
}

class _SolvedPageState extends State<SolvedPage> {
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
                  child: Text('You solved it!',
                      style: TextStyle(
                          fontSize: 24, color: colorScheme.onSurfaceVariant))),
            ),
          ),
          Expanded(
            flex: 3,
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
                TextButton(
                  style: TextButton.styleFrom(
                    shape: const CircleBorder(),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.clear_rounded,
                      size: 48, color: colorScheme.onSurfaceVariant),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    shape: const CircleBorder(),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CasualPage(),
                      ),
                    );
                  },
                  child: Icon(Icons.arrow_forward_rounded,
                      size: 48, color: colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
