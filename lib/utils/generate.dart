import '../models/op.dart';
import 'math.dart';

var target = 24;
var ops = Op.values;
var nums = List.generate(13, (i) => i + 1);

void generate(target) {
  var numList4 = nums.toList();
  numList4.shuffle();
  var numList3 = nums.toList();
  numList3.shuffle();
  var numList2 = nums.toList();
  numList2.shuffle();

  var opList3 = ops.toList();
  opList3.shuffle();
  var opList2 = ops.toList();
  opList2.shuffle();
  var opList1 = ops.toList();
  opList1.shuffle();

  for (var num4 in numList4) {
    for (var op3 in opList3) {
      if (num4 == 0 && op3 == Op.divide) {
        continue;
      }

      num rem1 = reverseOperate(op3, target, num4);
      print("num4: $rem1 $op3 $num4 ");

      for (var num3 in numList3) {
        num right = operate(op3, num3, num4);

        for (var op2 in opList2) {
          if (num3 == 0 && op2 == Op.divide) {
            continue;
          }

          num rem2 = reverseOperate(op2, rem1, num3);
          print("num3: ($rem2 $op2 $num3) $op3 $num4");

          if (right == 0 && op2 == Op.divide) {
            continue;
          }

          num left = reverseOperate(op2, target, right);
          print("right: $left $op2 ($num3 $op3 $num4)");

          for (var num2 in numList2) {
            for (var op1 in opList1) {
              if (num2 == 0 && op1 == Op.divide) {
                continue;
              }

              num num1 = reverseOperate(op1, rem2, num2);
              print("num2: (($num1 $op1 $num2) $op2 $num3) $op3 $num4");

              if (isInteger(num1) && num1 > 0 && num1 < 14) {
                print("(($num1 $op1 $num2) $op2 $num3) $op3 $num4");
                return;
              }

              num num12 = reverseOperate(op1, left, num2);
              print("num2-2: ($num12 $op1 $num2) $op2 ($num3 $op3 $num4)");

              if (isInteger(num12) && num12 > 0 && num12 < 14) {
                print("($num12 $op1 $num2) $op2 ($num3 $op3 $num4)");
                return;
              }
            }
          }
        }
      }
    }
  }
}
