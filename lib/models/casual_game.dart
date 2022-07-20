import 'package:flutter/material.dart';

import '../pages/casual_solved.dart';
import '../utils/math.dart';
import 'fraction.dart';
import 'op.dart';
import 'problem.dart';

class CasualGame extends ChangeNotifier {
  BuildContext context;
  late Problem problem;
  List<Fraction> originalNums = [];
  List<Fraction> nums = [];
  List<String> expression = [];
  List<bool> numShown = [true, true, true, true];
  List<bool> numPressed = [false, false, false, false];
  List<bool> opPressed = [false, false, false, false];
  List<List<dynamic>> pastStates = [];
  int hintShown = 0;
  Stopwatch stopwatch = Stopwatch();

  CasualGame(this.context);

  void initialize(context) {
    this.context = context;
    problem = Problem.generate();
    originalNums = List.generate(4, (i) => Fraction(problem.nums[i]));
    originalNums.shuffle();
    nums = originalNums.toList();
    expression = List.generate(4, (i) => originalNums[i].toString());
    numShown = [true, true, true, true];
    numPressed = [false, false, false, false];
    opPressed = [false, false, false, false];
    pastStates = [];
    hintShown = 0;
    stopwatch.reset();
    stopwatch.start();
  }

  void pressNumButton(int index) {
    if (numPressed[index]) {
      numPressed[index] = false;
    } else if (!numPressed.contains(true)) {
      numPressed[index] = true;
    } else if (numPressed.contains(true) && !opPressed.contains(true)) {
      numPressed[numPressed.indexOf(true)] = false;
      numPressed[index] = true;
    } else if (numPressed.contains(true) && opPressed.contains(true)) {
      pastStates.add([
        nums.toList(),
        numShown.toList(),
        numPressed.toList(),
        opPressed.toList(),
        expression.toList(),
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
      nums[firstIndex] = Fraction(100000);

      if (numShown.where((x) => x).toList().length == 1) {
        opPressed[opIndex] = false;
        if (nums[index] == Fraction(24)) {
          notifyListeners();
          stopwatch.stop();
          print(expression[index]);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => CasualSolvedPage(
                  heroTag: 'num$index',
                  time: stopwatch.elapsedMilliseconds,
                  expression: expression[index]),
            ),
          );
          return;
        }
      } else {
        numPressed[index] = true;
      }
    } else {
      return;
    }
    hintShown = 0;
    notifyListeners();
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
    if (pastStates.isNotEmpty) {
      List<dynamic> operation = pastStates.removeLast();
      nums = List<Fraction>.from(operation[0]);
      numShown = List<bool>.from(operation[1]);
      numPressed = List<bool>.from(operation[2]);
      opPressed = List<bool>.from(operation[3]);
      expression = List<String>.from(operation[4]);
      hintShown = 0;
      notifyListeners();
    }
  }

  void reset() {
    nums = originalNums.toList();
    numShown = [true, true, true, true];
    numPressed = [false, false, false, false];
    opPressed = [false, false, false, false];
    expression = List.generate(4, (i) => originalNums[i].toString());
    pastStates = [];
    hintShown = 0;
    notifyListeners();
  }

  void hint() {
    if (hintShown == 3) {
      return;
    } else if (hintShown == 2) {
      if (problem.split) {
        _pressSolutionNum(1);
        opPressed[opPressed.indexOf(true)] = false;
        pressOpButton(Op.values.indexOf(problem.ops[1]));
      } else {
        _pressSolutionNum(2);
        opPressed[opPressed.indexOf(true)] = false;
        pressOpButton(Op.values.indexOf(problem.ops[2]));
      }
      hintShown = 3;
    } else if (hintShown == 1) {
      if (problem.split) {
        _pressSolutionNum(3);
        numPressed[numPressed.indexOf(true)] = false;
        _pressSolutionNum(0);
        opPressed[opPressed.indexOf(true)] = false;
        pressOpButton(Op.values.indexOf(problem.ops[0]));
      } else {
        _pressSolutionNum(1);
        opPressed[opPressed.indexOf(true)] = false;
        pressOpButton(Op.values.indexOf(problem.ops[1]));
      }
      hintShown = 2;
    } else {
      reset();
      if (problem.split) {
        _pressSolutionNum(2);
        pressOpButton(Op.values.indexOf(problem.ops[2]));
      } else {
        _pressSolutionNum(0);
        pressOpButton(Op.values.indexOf(problem.ops[0]));
      }
      hintShown = 1;
    }
    notifyListeners();
  }

  void _pressSolutionNum(int index) {
    int firstIndex = nums.indexOf(Fraction(problem.nums[index]));
    if (!numPressed[firstIndex]) {
      pressNumButton(firstIndex);
    } else {
      pressNumButton(nums.lastIndexOf(Fraction(problem.nums[index])));
    }
  }
}
