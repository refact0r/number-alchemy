class Fraction {
  int num;
  int den;

  Fraction._(this.num, this.den);

  factory Fraction(int numerator, [int denominator = 1]) {
    if (denominator == 0) {
      throw Exception('Denominator cannot be zero.');
    }

    if (denominator < 0) {
      numerator = numerator * -1;
      denominator = denominator * -1;
    }
    final lgcd = numerator.gcd(denominator);

    numerator = (numerator) ~/ lgcd;
    denominator = (denominator) ~/ lgcd;

    return Fraction._(numerator, denominator);
  }

  int toInt() {
    return num ~/ den;
  }

  @override
  String toString() {
    if (den == 1) {
      return '$num';
    }

    return '$num/$den';
  }

  @override
  int get hashCode {
    var result = 17;

    result = result * 37 + num.hashCode;
    result = result * 37 + den.hashCode;

    return result;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other is Fraction) {
      final fraction = other;
      return runtimeType == fraction.runtimeType &&
          (num * fraction.den == den * fraction.num);
    }

    return false;
  }

  Fraction operator +(Fraction other) => Fraction(
        num * other.den + den * other.num,
        den * other.den,
      );

  Fraction operator -(Fraction other) => Fraction(
        num * other.den - den * other.num,
        den * other.den,
      );

  Fraction operator *(Fraction other) => Fraction(
        num * other.num,
        den * other.den,
      );

  Fraction operator /(Fraction other) => Fraction(
        num * other.den,
        den * other.num,
      );
}
