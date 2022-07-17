import '../models/op.dart';

bool isInteger(num value) {
  return value is int || value == value.roundToDouble();
}

dynamic operate(op, num1, num2) {
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
  return null;
}

dynamic reverseOperate(op, num1, num2) {
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
  return null;
}
