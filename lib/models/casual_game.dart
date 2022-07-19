import 'package:flutter/material.dart';

import '../pages/casual_solved.dart';
import '../utils/math.dart';
import 'fraction.dart';
import 'op.dart';
import 'problem.dart';

class CasualGame extends ChangeNotifier {
  List<bool> numShown = [true, true, true, true];
  List<bool> numPressed = [false, false, false, false];
  List<bool> opPressed = [false, false, false, false];
  List<List<List<dynamic>>> log = [];
  List<Fraction> nums = [];
  List<Fraction> originalNums = [];
  int hintShown = 0;
  Problem problem = Problem.generate();
  Stopwatch stopwatch = Stopwatch();

  CasualGame() {
    originalNums = List.generate(4, (i) => Fraction(problem.nums[i]));
    originalNums.shuffle();
    nums = originalNums.toList();
    stopwatch.start();
  }

  void pressNumButton(BuildContext context, int index) {
    if (numPressed[index]) {
      numPressed[index] = false;
    } else if (!numPressed.contains(true)) {
      numPressed[index] = true;
    } else if (numPressed.contains(true) && !opPressed.contains(true)) {
      numPressed[numPressed.indexOf(true)] = false;
      numPressed[index] = true;
    } else if (numPressed.contains(true) && opPressed.contains(true)) {
      log.add([
        nums.toList(),
        numShown.toList(),
        numPressed.toList(),
        opPressed.toList(),
      ]);
      var firstIndex = numPressed.indexOf(true);
      var opIndex = opPressed.indexOf(true);
      nums[index] = operate(Op.values[opIndex], nums[firstIndex], nums[index]);
      numShown[firstIndex] = false;
      numPressed[firstIndex] = false;
      nums[firstIndex] = Fraction(100000);
      if (numShown.where((x) => x).toList().length == 1) {
        opPressed[opIndex] = false;
      } else {
        numPressed[index] = true;
      }
    } else {
      return;
    }
    hintShown = 0;
    notifyListeners();
    if (nums.contains(Fraction(24)) &&
        numShown.where((x) => x).toList().length == 1) {
      stopwatch.stop();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => CasualSolvedPage(
              heroTag: 'num$index', time: stopwatch.elapsedMilliseconds),
        ),
      );
    }
  }

  void pressOpButton(int index) {
    if (opPressed[index]) {
      opPressed[index] = false;
    } else if (!opPressed.contains(true)) {
      opPressed[index] = true;
    } else {
      opPressed[opPressed.indexOf(true)] = false;
      opPressed[index] = true;
    }
    hintShown = 0;
    notifyListeners();
  }

  void undo() {
    if (log.isNotEmpty) {
      List<List<dynamic>> operation = log.removeLast();
      nums = List<Fraction>.from(operation[0]);
      numShown = List<bool>.from(operation[1]);
      numPressed = List<bool>.from(operation[2]);
      opPressed = List<bool>.from(operation[3]);
      hintShown = 0;
      notifyListeners();
    }
  }

  void reset() {
    nums = originalNums.toList();
    numShown = [true, true, true, true];
    numPressed = [false, false, false, false];
    opPressed = [false, false, false, false];
    log = [];
    hintShown = 0;
    notifyListeners();
  }

  void hint(BuildContext context) {
    if (hintShown == 3) {
      return;
    } else if (hintShown == 2) {
      if (problem.split) {
        _pressSolutionNum(context, 1);
        opPressed[opPressed.indexOf(true)] = false;
        pressOpButton(Op.values.indexOf(problem.ops[1]));
      } else {
        _pressSolutionNum(context, 2);
        opPressed[opPressed.indexOf(true)] = false;
        pressOpButton(Op.values.indexOf(problem.ops[2]));
      }
      hintShown = 3;
    } else if (hintShown == 1) {
      if (problem.split) {
        _pressSolutionNum(context, 3);
        numPressed[numPressed.indexOf(true)] = false;
        _pressSolutionNum(context, 0);
        opPressed[opPressed.indexOf(true)] = false;
        pressOpButton(Op.values.indexOf(problem.ops[0]));
      } else {
        _pressSolutionNum(context, 1);
        opPressed[opPressed.indexOf(true)] = false;
        pressOpButton(Op.values.indexOf(problem.ops[1]));
      }
      hintShown = 2;
    } else {
      reset();
      if (problem.split) {
        _pressSolutionNum(context, 2);
        pressOpButton(Op.values.indexOf(problem.ops[2]));
      } else {
        _pressSolutionNum(context, 0);
        pressOpButton(Op.values.indexOf(problem.ops[0]));
      }
      hintShown = 1;
    }
    notifyListeners();
  }

  void _pressSolutionNum(BuildContext context, int index) {
    int firstIndex = nums.indexOf(Fraction(problem.nums[index]));
    if (!numPressed[firstIndex]) {
      pressNumButton(context, firstIndex);
    } else {
      pressNumButton(context, nums.lastIndexOf(Fraction(problem.nums[index])));
    }
  }
}
