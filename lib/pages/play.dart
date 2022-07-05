import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:math';

import '../models/op.dart';
import '../utils/math.dart';

class PlayPage extends StatefulWidget {
  const PlayPage({super.key});

  @override
  State<PlayPage> createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> {
  var _numShown = [true, true, true, true];
  var _numPressed = [false, false, false, false];
  var _opPressed = [false, false, false, false];
  List<num> _originalNums = [
    for (var i = 0; i < 4; i++) Random().nextInt(13) + 1
  ];
  late List<num> _nums = [..._originalNums];

  void _pressNumButton(index) {
    if (_numPressed[index]) {
      _numPressed[index] = false;
    } else if (!_numPressed.contains(true)) {
      _numPressed[index] = true;
    } else if (_numPressed.contains(true) && !_opPressed.contains(true)) {
      _numPressed[_numPressed.indexOf(true)] = false;
      _numPressed[index] = true;
    } else if (_numPressed.contains(true) && _opPressed.contains(true)) {
      var index1 = _numPressed.indexOf(true);
      _nums[index] = operate(
          Op.values[_opPressed.indexOf(true)], _nums[index1], _nums[index]);
      _numShown[index1] = false;
      _numPressed[index1] = false;
      if (_numShown.where((x) => x).toList().length > 1) {
        _numPressed[index] = true;
      }
    }
    setState(() {});
  }

  void _pressOpButton(index) {
    if (_opPressed[index]) {
      _opPressed[index] = false;
    } else if (!_opPressed.contains(true)) {
      _opPressed[index] = true;
    } else {
      _opPressed[_opPressed.indexOf(true)] = false;
      _opPressed[index] = true;
    }
    setState(() {});
  }

  void _reset() {
    setState(() {
      _nums = [..._originalNums];
      _numShown = [true, true, true, true];
      _numPressed = [false, false, false, false];
      _opPressed = [false, false, false, false];
    });
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
                  icon: const Icon(Icons.arrow_back_rounded),
                ),
                IconButton(
                  onPressed: _reset,
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
                child: GridView.count(
                  primary: false,
                  crossAxisSpacing: 24,
                  mainAxisSpacing: 24,
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  children: <Widget>[
                    for (int i = 0; i < 4; i++)
                      Visibility(
                        visible: _numShown[i],
                        child: ElevatedButton(
                          onPressed: () {
                            _pressNumButton(i);
                          },
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24)),
                              primary: _numPressed[i]
                                  ? colorScheme.primaryContainer
                                  : null),
                          child: Text(
                            _nums[i]
                                .toStringAsFixed(2)
                                .replaceFirst(RegExp(r'\.?0*$'), ''),
                            style: const TextStyle(fontSize: 48),
                          ),
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
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor:
                          _opPressed[0] ? colorScheme.primaryContainer : null,
                      shape: const CircleBorder(),
                    ),
                    onPressed: () {
                      _pressOpButton(0);
                    },
                    child: Icon(CupertinoIcons.plus,
                        size: 48,
                        color: _opPressed[0]
                            ? colorScheme.onSurfaceVariant
                            : colorScheme.onSurfaceVariant),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor:
                          _opPressed[1] ? colorScheme.primaryContainer : null,
                      shape: const CircleBorder(),
                    ),
                    onPressed: () {
                      _pressOpButton(1);
                    },
                    child: Icon(CupertinoIcons.minus,
                        size: 48,
                        color: _opPressed[1]
                            ? colorScheme.onSurfaceVariant
                            : colorScheme.onSurfaceVariant),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor:
                          _opPressed[2] ? colorScheme.primaryContainer : null,
                      shape: const CircleBorder(),
                    ),
                    onPressed: () {
                      _pressOpButton(2);
                    },
                    child: Icon(CupertinoIcons.multiply,
                        size: 48,
                        color: _opPressed[2]
                            ? colorScheme.onSurfaceVariant
                            : colorScheme.onSurfaceVariant),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor:
                          _opPressed[3] ? colorScheme.primaryContainer : null,
                      shape: const CircleBorder(),
                    ),
                    onPressed: () {
                      _pressOpButton(3);
                    },
                    child: Icon(CupertinoIcons.divide,
                        size: 48,
                        color: _opPressed[3]
                            ? colorScheme.onSurfaceVariant
                            : colorScheme.onSurfaceVariant),
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
