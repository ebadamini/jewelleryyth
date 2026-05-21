extension StringX on String {
  String get capitalized {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }

  bool get isEmail {
    return RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(trim());
  }
}

extension NumX on num {
  String toMoney() => '\$${toStringAsFixed(2)}';
  String toWeight() => '${toStringAsFixed(3)} g';
}
