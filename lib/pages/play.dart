import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'solved.dart';
import '../models/op.dart';
import '../models/fraction.dart';
import '../utils/math.dart';
import '../utils/generate.dart';

class PlayPage extends StatefulWidget {
  const PlayPage({super.key});

  @override
  State<PlayPage> createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> {
  var _numShown = [true, true, true, true];
  var _numPressed = [false, false, false, false];
  var _opPressed = [false, false, false, false];
  var _log = [];
  var _nums = [];
  var _originalNums = [];
  final _problem = generateProblem();

  @override
  void initState() {
    super.initState();
    _nums = List.generate(4, (i) => Fraction(_problem.nums[i]));
    _nums.shuffle();
    _originalNums = _nums.toList();
  }

  void _pressNumButton(index) {
    if (_numPressed[index]) {
      _numPressed[index] = false;
    } else if (!_numPressed.contains(true)) {
      _numPressed[index] = true;
    } else if (_numPressed.contains(true) && !_opPressed.contains(true)) {
      _numPressed[_numPressed.indexOf(true)] = false;
      _numPressed[index] = true;
    } else if (_numPressed.contains(true) && _opPressed.contains(true)) {
      _log.add([
        _nums.toList(),
        _numShown.toList(),
        _numPressed.toList(),
        _opPressed.toList(),
      ]);
      var firstIndex = _numPressed.indexOf(true);
      var opIndex = _opPressed.indexOf(true);
      _nums[index] =
          operate(Op.values[opIndex], _nums[firstIndex], _nums[index]);
      _numShown[firstIndex] = false;
      _numPressed[firstIndex] = false;
      if (_numShown.where((x) => x).toList().length == 1) {
        _opPressed[opIndex] = false;
      } else {
        _numPressed[index] = true;
      }
    }
    setState(() {});
    if (_nums.contains(Fraction(24)) &&
        _numShown.where((x) => x).toList().length == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SolvedPage(heroTag: 'num$index'),
        ),
      );
    }
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

  void _undo() {
    if (_log.isNotEmpty) {
      var operation = _log.removeLast();
      _nums = operation[0];
      _numShown = operation[1];
      _numPressed = operation[2];
      _opPressed = operation[3];
      setState(() {});
    }
  }

  void _reset() {
    setState(() {
      _nums = _originalNums.toList();
      _numShown = [true, true, true, true];
      _numPressed = [false, false, false, false];
      _opPressed = [false, false, false, false];
      _log = [];
    });
  }

  void _hint() {
    _reset();
    _numPressed[_nums.indexOf(Fraction(_problem.nums[0]))] = true;
    _opPressed[Op.values.indexOf(_problem.ops[0])] = true;
    setState(() {});
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
                  onPressed: _hint,
                  color: colorScheme.onSurfaceVariant,
                  highlightColor:
                      colorScheme.onSurfaceVariant.withOpacity(0.08),
                  iconSize: 32,
                  icon: const Icon(Icons.lightbulb_outline_rounded),
                ),
                IconButton(
                  onPressed: _undo,
                  color: colorScheme.onSurfaceVariant,
                  highlightColor:
                      colorScheme.onSurfaceVariant.withOpacity(0.08),
                  iconSize: 32,
                  icon: const Icon(Icons.undo_rounded),
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
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  children: <Widget>[
                    for (int i = 0; i < 4; i++)
                      Visibility(
                        visible: _numShown[i],
                        child: Hero(
                          tag: 'num$i',
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
                              _nums[i].toString(),
                              style: const TextStyle(fontSize: 48),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
        ],
      ),
    );
  }
}
