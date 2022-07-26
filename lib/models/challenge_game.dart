import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';

import '../pages/challenge_results.dart';
import '../utils/haptics.dart';
import '../utils/math.dart';
import 'fraction.dart';
import 'op.dart';
import 'problem.dart';

class ChallengeGame extends ChangeNotifier {
  BuildContext context;
  late AnimationController animation;
  late int target;
  late Problem problem;
  List<Fraction> originalNums = [];
  List<Fraction> nums = [];
  List<bool> numShown = [true, true, true, true];
  List<bool> numPressed = [false, false, false, false];
  List<bool> opPressed = [false, false, false, false];
  List<List<dynamic>> pastStates = [];
  int hintShown = 0;
  bool resetShown = true;
  int solvedCount = 0;
  int secondsElapsed = 0;
  int timerSeconds = 0;
  late Timer timer;
  String timeString = '';
  String timeChangeString = '';

  ChallengeGame(this.context);

  void initialize(BuildContext context, AnimationController animation) {
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
    Random random = Random();
    target = random.nextInt(100) + 1;
    problem = Problem.generate(target, 1, 13);
    originalNums = List.generate(4, (i) => Fraction(problem.nums[i]));
    originalNums.shuffle();
    nums = originalNums.toList();
    numShown = [true, true, true, true];
    numPressed = [false, false, false, false];
    opPressed = [false, false, false, false];
    pastStates = [];
    hintShown = 0;
    resetShown = true;
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
      hapticVibrate(context);
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

  void pressNumButton(int index, bool userPress) {
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
        hintShown,
      ]);
      var firstIndex = numPressed.indexOf(true);
      var opIndex = opPressed.indexOf(true);
      nums[index] = operate(Op.values[opIndex], nums[firstIndex], nums[index]);
      numShown[firstIndex] = false;
      numPressed[firstIndex] = false;
      nums[firstIndex] = Fraction(100000);

      if (numShown.where((x) => x).toList().length == 1) {
        opPressed[opIndex] = false;
        if (nums[index] == Fraction(target)) {
          updateTimer(10);
          solvedCount++;
          hapticVibrate(context);
          notifyListeners();
          Future.delayed(const Duration(milliseconds: 200), () {
            newProblem();
          });
          return;
        }
      } else {
        numPressed[index] = true;
      }
    } else {
      return;
    }
    if (userPress) {
      hapticClick(context);
    }
    hintShown = 0;
    resetShown = false;
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
    resetShown = false;
    notifyListeners();
  }

  void undo() {
    if (pastStates.isNotEmpty) {
      hapticClick(context);
      List operation = pastStates.removeLast();
      nums = List<Fraction>.from(operation[0]);
      numShown = List<bool>.from(operation[1]);
      numPressed = List<bool>.from(operation[2]);
      opPressed = List<bool>.from(operation[3]);
      hintShown = operation[4] as int;
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
      reset(false);
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
