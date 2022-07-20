import 'dart:math';
import 'package:collection/collection.dart';

import 'op.dart';
import '../utils/math.dart';

const target = 24;
const minNum = 1;
const maxNum = 13;

class Problem {
  List<int> nums = [];
  List<Op> ops = [];
  bool split = false;

  Problem(this.nums, this.ops, this.split);

  Problem.generate() {
    Random random = Random();

    while (true) {
      var randomNums = [
        random.nextInt(maxNum) + minNum,
        random.nextInt(maxNum) + minNum,
        random.nextInt(maxNum) + minNum,
        random.nextInt(maxNum) + minNum
      ];

      List<List<int>> perms = [];
      _permute(randomNums, 0, perms);

      for (List<int> perm in perms) {
        for (Op op1 in Op.values) {
          for (Op op2 in Op.values) {
            for (Op op3 in Op.values) {
              if (_check(perm, [op1, op2, op3], true)) {
                nums = perm;
                ops = [op1, op2, op3];
                split = true;
                print('Generated problem: $nums, $ops, $split');
                return;
              }

              if (_check(perm, [op1, op2, op3], false)) {
                nums = perm;
                ops = [op1, op2, op3];
                split = false;
                print('Generated problem: $nums, $ops, $split');
                return;
              }
            }
          }
        }
      }
    }
  }

  bool _check(List<int> nums, List<Op> ops, bool split) {
    if (split) {
      var num1 = operate(ops[0], nums[0], nums[1]);
      var num2 = operate(ops[2], nums[2], nums[3]);
      var num3 = operate(ops[1], num1, num2);
      return num3 == target;
    } else {
      var num1 = operate(ops[0], nums[0], nums[1]);
      var num2 = operate(ops[1], num1, nums[2]);
      var num3 = operate(ops[2], num2, nums[3]);
      return num3 == target;
    }
  }

  void _permute(List<int> nums, int k, List<List<int>> perms) {
    for (int i = k; i < nums.length; i++) {
      bool swap = true;

      for (int j = k; j < i; j++) {
        if (nums[j] == nums[i]) {
          swap = false;
          break;
        }
      }

      if (swap) {
        nums.swap(i, k);
        _permute(nums, k + 1, perms);
        nums.swap(k, i);
      }
    }

    if (k == nums.length - 1) {
      List<int> row = nums.toList();
      perms.add(row);
    }
  }
}
