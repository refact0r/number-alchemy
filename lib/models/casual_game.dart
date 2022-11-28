import 'dart:math';

import 'package:flutter/material.dart';

import '../pages/casual_solved.dart';
import '../pages/tutorial_solved.dart';
import '../utils/haptics.dart';
import '../utils/math.dart';
import 'fraction.dart';
import 'op.dart';
import 'problem.dart';

class CasualGame extends ChangeNotifier {
  BuildContext context;
  int mode = 0;
  late int target;
  late Problem problem;
  List<Fraction> originalNums = [];
  List<Fraction> nums = [];
  List<String> expression = [];
  List<bool> numShown = [true, true, true, true];
  List<bool> numPressed = [false, false, false, false];
  List<bool> opPressed = [false, false, false, false];
  List<List<dynamic>> pastStates = [];
  int hintShown = 0;
  bool resetShown = true;
  Stopwatch stopwatch = Stopwatch();

  CasualGame(this.context);

  void initialize(BuildContext context, int mode) {
    this.context = context;
    this.mode = mode;
    target = 24;
    if (this.mode == 1) {
      Random random = Random();
      target = random.nextInt(100) + 1;
    }
    problem = Problem.generate(target, 1, 13);
    originalNums = List.generate(4, (i) => Fraction(problem.nums[i]));
    originalNums.shuffle();
    if (this.mode == -1) {
      problem = Problem(24, 1, 13, [1, 2, 3, 4], [Op.add, Op.add, Op.multiply], false);
      originalNums = [Fraction(1), Fraction(2), Fraction(3), Fraction(4)];
    } else if (this.mode == -2) {
      problem = Problem(24, 1, 13, [2, 2, 10, 10], [Op.add, Op.add, Op.add], false);
      originalNums = [Fraction(2), Fraction(2), Fraction(10), Fraction(10)];
    }
    nums = originalNums.toList();
    expression = List.generate(4, (i) => originalNums[i].toString());
    numShown = [true, true, true, true];
    numPressed = [false, false, false, false];
    opPressed = [false, false, false, false];
    pastStates = [];
    hintShown = 0;
    resetShown = true;
    stopwatch.reset();
    stopwatch.start();
  }

  void pressNumButton(int index, bool userPress) {
    if (pastStates.length == 3) {
      return;
    }
    if (numPressed[index]) {
      numPressed[index] = false;
      opPressed = [false, false, false, false];
    } else if (!numPressed.contains(true)) {
      numPressed[index] = true;
    } else if (numPressed.contains(true) && !opPressed.contains(true)) {
      numPressed = [false, false, false, false];
      numPressed[index] = true;
    } else if (numPressed.contains(true) && opPressed.contains(true)) {
      pastStates.add([
        nums.toList(),
        numShown.toList(),
        numPressed.toList(),
        opPressed.toList(),
        expression.toList(),
        hintShown,
      ]);

      int firstIndex = numPressed.indexOf(true);
      int opIndex = opPressed.indexOf(true);

      String first = expression[firstIndex];
      String op = opToString(Op.values[opIndex]);
      String second = expression[index];
      if (first.length >= 5) {
        first = '($first)';
      }
      if (second.length >= 5) {
        second = '($second)';
      }
      expression[index] = '$first $op $second';

      nums[index] = operate(Op.values[opIndex], nums[firstIndex], nums[index]);
      numShown[firstIndex] = false;
      numPressed[firstIndex] = false;
      opPressed[opIndex] = false;
      nums[firstIndex] = Fraction(100000);

      if (pastStates.length == 3) {
        if (nums[index] == Fraction(target)) {
          notifyListeners();
          stopwatch.stop();
          print(expression[index]);
          hapticVibrate(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) {
                if (mode == -1 || mode == -2) {
                  return TutorialSolvedPage(
                      heroTag: 'num$index',
                      time: stopwatch.elapsedMilliseconds,
                      expression: expression[index],
                      target: target,
                      mode: mode);
                } else {
                  return CasualSolvedPage(
                    heroTag: 'num$index',
                    time: stopwatch.elapsedMilliseconds,
                    expression: expression[index],
                    target: target,
                  );
                }
              },
            ),
          );
          return;
        }
      } else {
        numPressed[index] = true;
      }
    }
    if (userPress) {
      hapticClick(context);
    }
    hintShown = 0;
    resetShown = false;
    notifyListeners();
  }

  void pressOpButton(int index, bool userPress) {
    if (numPressed.contains(true)) {
      if (userPress && !opPressed[index]) {
        hapticClick(context);
      }
      if (!opPressed.contains(true)) {
        opPressed[index] = true;
      } else {
        opPressed = [false, false, false, false];
        opPressed[index] = true;
      }
      hintShown = 0;
      resetShown = false;
      notifyListeners();
    }
  }

  void undo() {
    if (pastStates.isNotEmpty) {
      hapticClick(context);
      List<dynamic> operation = pastStates.removeLast();
      nums = List<Fraction>.from(operation[0]);
      numShown = List<bool>.from(operation[1]);
      numPressed = List<bool>.from(operation[2]);
      opPressed = List<bool>.from(operation[3]);
      expression = List<String>.from(operation[4]);
      hintShown = operation[5] as int;
      resetShown = false;
      notifyListeners();
    }
  }

  void reset(bool userPress) {
    if (!resetShown) {
      if (userPress) {
        hapticClick(context);
      }
      nums = originalNums.toList();
      numShown = [true, true, true, true];
      numPressed = [false, false, false, false];
      opPressed = [false, false, false, false];
      expression = List.generate(4, (i) => originalNums[i].toString());
      pastStates = [];
      hintShown = 0;
      resetShown = true;
      notifyListeners();
    }
  }

  void hint() {
    if (hintShown == 3) {
      return;
    }
    hapticClick(context);
    if (hintShown == 2) {
      if (problem.split) {
        _pressSolutionNum(1);
        pressOpButton(Op.values.indexOf(problem.ops[1]), false);
      } else {
        _pressSolutionNum(2);
        pressOpButton(Op.values.indexOf(problem.ops[2]), false);
      }
      hintShown = 3;
    } else if (hintShown == 1) {
      if (problem.split) {
        _pressSolutionNum(3);
        numPressed[numPressed.indexOf(true)] = false;
        _pressSolutionNum(0);
        pressOpButton(Op.values.indexOf(problem.ops[0]), false);
      } else {
        _pressSolutionNum(1);
        pressOpButton(Op.values.indexOf(problem.ops[1]), false);
      }
      hintShown = 2;
    } else {
      reset(false);
      if (problem.split) {
        _pressSolutionNum(2);
        pressOpButton(Op.values.indexOf(problem.ops[2]), false);
      } else {
        _pressSolutionNum(0);
        pressOpButton(Op.values.indexOf(problem.ops[0]), false);
      }
      hintShown = 1;
    }
    resetShown = false;
    notifyListeners();
  }

  void _pressSolutionNum(int index) {
    int firstIndex = nums.indexOf(Fraction(problem.nums[index]));
    if (!numPressed[firstIndex]) {
      pressNumButton(firstIndex, false);
    } else {
      pressNumButton(nums.lastIndexOf(Fraction(problem.nums[index])), false);
    }
  }
}
