import 'package:flutter/material.dart';

class PlayPage extends StatefulWidget {
  const PlayPage({super.key});

  @override
  State<PlayPage> createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back_rounded),
                  iconSize: 32,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: GridView.count(
                  primary: false,
                  crossAxisSpacing: 24,
                  mainAxisSpacing: 24,
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.cyan,
                          borderRadius: BorderRadius.circular(24)),
                      child: const Text(
                        '1',
                        style: TextStyle(fontSize: 48),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.cyan,
                          borderRadius: BorderRadius.circular(24)),
                      child: const Text(
                        '2',
                        style: TextStyle(fontSize: 48),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.cyan,
                          borderRadius: BorderRadius.circular(24)),
                      child: const Text(
                        '3',
                        style: TextStyle(fontSize: 48),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.cyan,
                          borderRadius: BorderRadius.circular(24)),
                      child: const Text(
                        '4',
                        style: TextStyle(fontSize: 48),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.autorenew_rounded),
                    iconSize: 48,
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.undo_rounded),
                    iconSize: 48,
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.lightbulb_outline_rounded),
                    iconSize: 48,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
