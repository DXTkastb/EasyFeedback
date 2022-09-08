class Validators {
  static final phoneRegexp = RegExp(r"^[1-9]\d{9}$");

  static final usernameRegexp = RegExp(r"^\w*$");

  static final passwordRegexp = RegExp(r"^[0-9a-zA-Z]{15}$");

  static String? phoneValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter phone number';
    } else if (!(phoneRegexp.hasMatch(value))) {
      return 'Incorrect phone number';
    }
  }

  static String? usernameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter username';
    } else if (!(usernameRegexp.hasMatch(value))) {
      return 'Incorrect username';
    }
  }

  static String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter password';
    } else if (!(passwordRegexp.hasMatch(value))) {
      return 'Incorrect password format';
    }
  }
}
