import '../models/op.dart';

bool isInteger(num value) {
  return value is int || value == value.roundToDouble();
}

num operate(op, num1, num2) {
  switch (op) {
    case Op.add:
      return num1 + num2;
    case Op.subtract:
      return num1 - num2;
    case Op.multiply:
      return num1 * num2;
    case Op.divide:
      return num1 / num2;
  }
  return 0;
}

num reverseOperate(op, num1, num2) {
  switch (op) {
    case Op.add:
      return num1 - num2;
    case Op.subtract:
      return num1 + num2;
    case Op.multiply:
      return num1 / num2;
    case Op.divide:
      return num1 * num2;
  }
  return 0;
}
