import 'package:flutter/material.dart';
import 'dart:async';

import '../pages/challenge_results.dart';
import '../utils/math.dart';
import 'fraction.dart';
import 'op.dart';
import 'problem.dart';

class ChallengeGame extends ChangeNotifier {
  BuildContext context;
  late AnimationController animation;
  late Problem problem;
  List<Fraction> originalNums = [];
  List<Fraction> nums = [];
  List<bool> numShown = [true, true, true, true];
  List<bool> numPressed = [false, false, false, false];
  List<bool> opPressed = [false, false, false, false];
  List<List<List<dynamic>>> log = [];
  int hintShown = 0;
  int solvedCount = 0;
  int secondsElapsed = 0;
  int timerSeconds = 60;
  late Timer timer;
  String timeString = '';
  String timeChangeString = '';

  ChallengeGame(this.context);

  void initialize(BuildContext context, animation) {
    this.context = context;
    this.animation = animation;
    newProblem();
    solvedCount = 0;
    secondsElapsed = 0;
    timerSeconds = 60;
    timer = Timer.periodic(const Duration(seconds: 1), _timerTick);
    timeString =
        '${timerSeconds ~/ 60}:${(timerSeconds % 60).toString().padLeft(2, '0')}';
  }

  void newProblem() {
    problem = Problem.generate();
    originalNums = List.generate(4, (i) => Fraction(problem.nums[i]));
    originalNums.shuffle();
    nums = originalNums.toList();
    numShown = [true, true, true, true];
    numPressed = [false, false, false, false];
    opPressed = [false, false, false, false];
    log = [];
    hintShown = 0;
  }

  void _timerTick(Timer timer) {
    print('timertick');
    secondsElapsed += 1;
    timerSeconds -= 1;
    timeString =
        '${timerSeconds ~/ 60}:${(timerSeconds % 60).toString().padLeft(2, '0')}';
    notifyListeners();
    if (timerSeconds <= 0) {
      timer.cancel();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ChallengeResultsPage(
              solvedCount: solvedCount, secondsElapsed: secondsElapsed),
        ),
      );
    }
  }

  void updateTimer(int amount) {
    if (amount != 0) {
      timerSeconds += amount;
      if (amount > 0) {
        timeChangeString = '+$amount';
      } else {
        timeChangeString = '$amount';
      }
      animation.value = 1;
      animation.reverse();
    }
    if (timerSeconds <= 0) {
      timerSeconds = 0;
    }
    timeString =
        '${timerSeconds ~/ 60}:${(timerSeconds % 60).toString().padLeft(2, '0')}';
    notifyListeners();
    if (timerSeconds <= 0) {
      timer.cancel();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ChallengeResultsPage(
              solvedCount: solvedCount, secondsElapsed: secondsElapsed),
        ),
      );
    }
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
      solvedCount++;
      updateTimer(10);
      Future.delayed(const Duration(milliseconds: 300), () {
        newProblem();
      });
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
      updateTimer(-15);
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
      updateTimer(-10);
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
      updateTimer(-5);
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
