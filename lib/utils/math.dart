import '../models/op.dart';

bool isInteger(num value) {
  return value is int || value == value.roundToDouble();
}

dynamic operate(Op op, dynamic num1, dynamic num2) {
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
}

dynamic reverseOperate(Op op, dynamic num1, dynamic num2) {
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
}

String opToString(Op op) {
  switch (op) {
    case Op.add:
      return '+';
    case Op.subtract:
      return '-';
    case Op.multiply:
      return '×';
    case Op.divide:
      return '÷';
  }
}
