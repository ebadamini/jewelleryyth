class Formatters {
  static String weight(num value) => '${value.toStringAsFixed(3)} g';
  static String money(num value) => '\$${value.toStringAsFixed(2)}';
  static String percent(num value) => '${value.toStringAsFixed(1)}%';
}
