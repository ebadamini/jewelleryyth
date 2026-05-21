class Validators {
  static String? requiredField(String? value, {String message = 'This field is required.'}) {
    if (value == null || value.trim().isEmpty) return message;
    return null;
  }

  static String? email(String? value, {String message = 'Enter a valid email address.'}) {
    if (value == null || value.trim().isEmpty) return null;
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!regex.hasMatch(value.trim())) return message;
    return null;
  }

  static String? minLength(String? value, int length, {String? message}) {
    if (value == null || value.length < length) {
      return message ?? 'Minimum length is $length.';
    }
    return null;
  }
}
