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

class _ChallengePageState extends State<ChallengePage>
    with TickerProviderStateMixin {
  var _numShown = [];
  var _numPressed = [];
  var _opPressed = [];
  var _log = [];
  var _nums = [];
  var _originalNums = [];
  var _hintShown = 0;
  var _timer;
  var _time = '';
  var _timeChangeValue = '';
  var _seconds = 60;
  var _problem = Problem.generate();
  var _solvedCount = 0;

  late final _fadeAnimation = AnimationController(
    value: 0,
    duration: const Duration(milliseconds: 800),
    vsync: this,
  );

  @override
  void initState() {
    super.initState();
    initialize();
    _timer = Timer.periodic(const Duration(seconds: 1), _timerTick);
    _updateTimer(0);
  }

  @override
  void dispose() {
    _timer.cancel();
    _fadeAnimation.dispose();
    super.dispose();
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

  void _timerTick(timer) {
    _seconds -= 1;
    _time = '${_seconds ~/ 60}:${(_seconds % 60).toString().padLeft(2, '0')}';
    setState(() {});
    if (_seconds <= 0) {
      _timer.cancel();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ChallengeResultsPage(solvedCount: _solvedCount),
        ),
      );
    }
  }

  void _updateTimer(int amount) {
    if (amount != 0) {
      _seconds += amount;
      if (amount > 0) {
        _timeChangeValue = '+$amount';
      } else {
        _timeChangeValue = '$amount';
      }
      _fadeAnimation.value = 1;
      _fadeAnimation.reverse();
    }
    if (_seconds <= 0) {
      _seconds = 0;
    }
    _time = '${_seconds ~/ 60}:${(_seconds % 60).toString().padLeft(2, '0')}';
    setState(() {});
    if (_seconds <= 0) {
      _timer.cancel();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ChallengeResultsPage(solvedCount: _solvedCount),
        ),
      );
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
      _solvedCount++;
      _updateTimer(5);
      Future.delayed(const Duration(milliseconds: 300), () {
        initialize(); // Prints after 1 second.
      });
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
    // _seconds += 10;

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
        _pressSolutionNum(1);
        _opPressed[_opPressed.indexOf(true)] = false;
        _pressOpButton(Op.values.indexOf(_problem.ops[1]));
      } else {
        _pressSolutionNum(2);
        _opPressed[_opPressed.indexOf(true)] = false;
        _pressOpButton(Op.values.indexOf(_problem.ops[2]));
      }
      _hintShown = 3;
      _updateTimer(-15);
    } else if (_hintShown == 1) {
      if (_problem.split) {
        _pressSolutionNum(3);
        _numPressed[_numPressed.indexOf(true)] = false;
        _pressSolutionNum(0);
        _opPressed[_opPressed.indexOf(true)] = false;
        _pressOpButton(Op.values.indexOf(_problem.ops[0]));
      } else {
        _pressSolutionNum(1);
        _opPressed[_opPressed.indexOf(true)] = false;
        _pressOpButton(Op.values.indexOf(_problem.ops[1]));
      }
      _hintShown = 2;
      _updateTimer(-10);
    } else {
      _reset();
      if (_problem.split) {
        _pressSolutionNum(2);
        _pressOpButton(Op.values.indexOf(_problem.ops[2]));
      } else {
        _pressSolutionNum(0);
        _pressOpButton(Op.values.indexOf(_problem.ops[0]));
      }
      _hintShown = 1;
      _updateTimer(-5);
    }
    setState(() {});
  }

  void _pressSolutionNum(index) {
    var firstIndex = _nums.indexOf(Fraction(_problem.nums[index]));
    if (!_numPressed[firstIndex]) {
      _pressNumButton(firstIndex);
    } else {
      _pressNumButton(_nums.lastIndexOf(Fraction(_problem.nums[index])));
    }
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 128,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 12),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceTint.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text('$_time',
                            style: TextStyle(
                                fontSize: 32, color: colorScheme.primary))),
                  ),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: SizedBox(
                      width: 128,
                      child: Text(_timeChangeValue,
                          style: TextStyle(
                              fontSize: 32, color: colorScheme.primary)),
                    ),
                  ),
                ],
              )),
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
