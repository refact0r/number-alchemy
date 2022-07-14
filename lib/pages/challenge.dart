import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';

import 'challenge_results.dart';
import '../models/op.dart';
import '../models/fraction.dart';
import '../models/problem.dart';
import '../utils/math.dart';

class ChallengePage extends StatefulWidget {
  const ChallengePage({super.key});

  @override
  State<ChallengePage> createState() => _ChallengePageState();
}

class _ChallengePageState extends State<ChallengePage> {
  var _numShown = [];
  var _numPressed = [];
  var _opPressed = [];
  var _log = [];
  var _nums = [];
  var _originalNums = [];
  var _hintShown = 0;
  var _timer;
  var _seconds = 20;
  var _time = '0:20';
  var _problem = Problem.generate();

  @override
  void initState() {
    super.initState();
    initialize();
    _timer = Timer.periodic(const Duration(seconds: 1), _updateTimer);
  }

  void initialize() {
    _numShown = [true, true, true, true];
    _numPressed = [false, false, false, false];
    _opPressed = [false, false, false, false];
    _log = [];
    _hintShown = 0;
    _problem = Problem.generate();
    _nums = List.generate(4, (i) => Fraction(_problem.nums[i]));
    _nums.shuffle();
    _originalNums = _nums.toList();
  }

  void _updateTimer(timer) {
    if (_seconds == 1) {
      _seconds--;
      setState(() {});
      timer.cancel();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ChallengeResultsPage(),
        ),
      );
    } else {
      _seconds--;
    }
    _time = '${_seconds ~/ 60}:${(_seconds % 60).toString().padLeft(2, '0')}';
    if (mounted) {
      setState(() {});
    } else {
      timer.cancel();
    }
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
      _nums[firstIndex] = null;
      if (_numShown.where((x) => x).toList().length == 1) {
        _opPressed[opIndex] = false;
      } else {
        _numPressed[index] = true;
      }
    } else {
      return;
    }
    _hintShown = 0;
    setState(() {});
    if (_nums.contains(Fraction(24)) &&
        _numShown.where((x) => x).toList().length == 1) {
      initialize();
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
    _hintShown = 0;
    setState(() {});
  }

  void _undo() {
    if (_log.isNotEmpty) {
      var operation = _log.removeLast();
      _nums = operation[0];
      _numShown = operation[1];
      _numPressed = operation[2];
      _opPressed = operation[3];
      _hintShown = 0;
      setState(() {});
    }
  }

  void _reset() {
    _nums = _originalNums.toList();
    _numShown = [true, true, true, true];
    _numPressed = [false, false, false, false];
    _opPressed = [false, false, false, false];
    _log = [];
    _hintShown = 0;
    setState(() {});
  }

  void _hint() {
    if (_hintShown == 3) {
      return;
    } else if (_hintShown == 2) {
      if (_problem.split) {
        _pressNumButton(_nums.lastIndexOf(Fraction(_problem.nums[1])));
        _opPressed[_opPressed.indexOf(true)] = false;
        _pressOpButton(Op.values.indexOf(_problem.ops[1]));
      } else {
        _pressNumButton(_nums.indexOf(Fraction(_problem.nums[2])));
        _opPressed[_opPressed.indexOf(true)] = false;
        _pressOpButton(Op.values.indexOf(_problem.ops[2]));
      }
      _hintShown = 3;
    } else if (_hintShown == 1) {
      if (_problem.split) {
        _pressNumButton(_nums.lastIndexOf(Fraction(_problem.nums[3])));
        _numPressed[_numPressed.indexOf(true)] = false;
        _pressNumButton(_nums.indexOf(Fraction(_problem.nums[0])));
        _opPressed[_opPressed.indexOf(true)] = false;
        _pressOpButton(Op.values.indexOf(_problem.ops[0]));
      } else {
        _pressNumButton(_nums.lastIndexOf(Fraction(_problem.nums[1])));
        _opPressed[_opPressed.indexOf(true)] = false;
        _pressOpButton(Op.values.indexOf(_problem.ops[1]));
      }
      _hintShown = 2;
    } else {
      _reset();
      if (_problem.split) {
        _pressNumButton(_nums.indexOf(Fraction(_problem.nums[2])));
        _pressOpButton(Op.values.indexOf(_problem.ops[2]));
      } else {
        _pressNumButton(_nums.indexOf(Fraction(_problem.nums[0])));
        _pressOpButton(Op.values.indexOf(_problem.ops[0]));
      }
      _hintShown = 1;
    }
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
          Padding(
              padding: const EdgeInsets.all(12),
              child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceTint.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text('$_time',
                      style: TextStyle(
                          fontSize: 32, color: colorScheme.primary)))),
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
                Ink(
                  padding: const EdgeInsets.all(10),
                  decoration: ShapeDecoration(
                    color: _opPressed[0] ? colorScheme.primaryContainer : null,
                    shape: const CircleBorder(),
                  ),
                  child: IconButton(
                    iconSize: 36,
                    icon: const Icon(CupertinoIcons.plus),
                    color: _opPressed[0]
                        ? colorScheme.onSurfaceVariant
                        : colorScheme.onSurfaceVariant,
                    onPressed: () {
                      _pressOpButton(0);
                    },
                  ),
                ),
                Ink(
                  padding: const EdgeInsets.all(10),
                  decoration: ShapeDecoration(
                    color: _opPressed[1] ? colorScheme.primaryContainer : null,
                    shape: const CircleBorder(),
                  ),
                  child: IconButton(
                    iconSize: 36,
                    icon: const Icon(CupertinoIcons.minus),
                    color: _opPressed[1]
                        ? colorScheme.onSurfaceVariant
                        : colorScheme.onSurfaceVariant,
                    onPressed: () {
                      _pressOpButton(1);
                    },
                  ),
                ),
                Ink(
                  padding: const EdgeInsets.all(10),
                  decoration: ShapeDecoration(
                    color: _opPressed[2] ? colorScheme.primaryContainer : null,
                    shape: const CircleBorder(),
                  ),
                  child: IconButton(
                    iconSize: 36,
                    icon: const Icon(CupertinoIcons.multiply),
                    color: _opPressed[2]
                        ? colorScheme.onSurfaceVariant
                        : colorScheme.onSurfaceVariant,
                    onPressed: () {
                      _pressOpButton(2);
                    },
                  ),
                ),
                Ink(
                  padding: const EdgeInsets.all(10),
                  decoration: ShapeDecoration(
                    color: _opPressed[3] ? colorScheme.primaryContainer : null,
                    shape: const CircleBorder(),
                  ),
                  child: IconButton(
                    iconSize: 36,
                    icon: const Icon(CupertinoIcons.divide),
                    color: _opPressed[3]
                        ? colorScheme.onSurfaceVariant
                        : colorScheme.onSurfaceVariant,
                    onPressed: () {
                      _pressOpButton(3);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
