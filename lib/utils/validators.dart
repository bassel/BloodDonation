/// To chain validators, call them one after the other with the ?? operator.
/// Reasoning: If the first validator returns null then it has no errors, so
/// we check the second one, etc.
/// Once a validator returns a non-null value, this means it caught an error
/// and no need to check any further
class Validators {
  static String required(String val, String name) {
    if (val == null || val.isEmpty) {
      return '* $name is required';
    }
    return null;
  }

  static String email(String val) {
    if (val == null || !val.contains('@')) {
      return '* Please enter a valid email';
    }
    return null;
  }

  static String phone(String val) {
    final regExp = RegExp(r'(^[0-9]{7,8}$)');
    if (!regExp.hasMatch(val)) {
      return '* Please enter a valid phone number';
    }
    return null;
  }

  /// Allows years only between 1900 and 2099
  /// Allows only birth years of people between 18 and 100 years old
  static String birthYear(String val) {
    final regExp = RegExp(r'^(19|20)\d{2}$');
    if (!regExp.hasMatch(val)) {
      return '* Please enter a valid year';
    }
    final year = int.tryParse(val) ?? 0;
    final age = DateTime.now().year - year;
    if (age < 18) {
      return '* You must be at least 18 years old';
    } else if (age > 100) {
      return '* You must be less than 100 years old';
    }
    return null;
  }

  /// Allows only alphabetical non numeric characters,
  /// and only the dash and apostrophe in special chars
  static String name(String val) {
    final regExp =
        RegExp(r"^[a-zA-Z]+(([' -][a-zA-Z ])?[a-zA-Z]*)*$");
    if (!regExp.hasMatch(val)) {
      return '* Please enter a valid name';
    }
    return null;
  }
}
