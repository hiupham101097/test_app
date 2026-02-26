extension EmailValidator on String {
  bool isValidEmail() {
    if (this.isEmpty) {
      return false;
    }

    return RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
    ).hasMatch(this);
  }

  bool isValidPassword([int minLength = 8]) {
    if (this.isEmpty || this.length < minLength) {
      return false;
    }

    bool hasUppercase = this.contains(new RegExp(r'[A-Z]'));
    bool hasDigits = this.contains(new RegExp(r'[0-9]'));
    bool hasLowercase = this.contains(new RegExp(r'[a-z]'));
    // bool hasSpecialCharacters = this.contains(new RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    return hasDigits & hasUppercase & hasLowercase;
  }

  bool hasUppercase() {
    if (this.isEmpty) {
      return false;
    }

    return this.contains(new RegExp(r'[A-Z]'));
  }

  bool hasLowercase() {
    if (this.isEmpty) {
      return false;
    }

    return this.contains(new RegExp(r'[a-z]'));
  }

  bool hasDigit() {
    if (this.isEmpty) {
      return false;
    }

    return this.contains(new RegExp(r'[0-9]'));
  }

  bool hasMinLength([int minLength = 8]) {
    if (this.isEmpty || this.length < minLength) {
      return false;
    }

    return true;
  }

  bool isValidOTP() {
    if (this.isEmpty || this.length != 4) {
      return false;
    }

    return RegExp(r'^[0-9]+$').hasMatch(this);
  }

  bool isValidName() {
    if (this.isEmpty) {
      return false;
    }

    bool hasDigits = this.contains(new RegExp(r'[0-9]'));
    bool hasSpecialCharacters = this.contains(
      new RegExp(r'[!@#$%^&*(),.?":{}|<>]'),
    );

    return !hasSpecialCharacters && !hasDigits;
  }

  bool isValidPhone() {
    if (this.isEmpty || this.length != 10) {
      return false;
    }

    return RegExp(r'^[0-9]+$').hasMatch(this);
  }

  bool isValidNumber() {
    if (this.isEmpty) {
      return false;
    }

    return RegExp(r'^[0-9]+$').hasMatch(this);
  }

  bool isValidDate() {
    if (this.isEmpty || this.replaceAll('-', '').length != 10) {
      return false;
    }

    return RegExp(
      r'^(((0[1-9]|[12][0-9]|30)[-/]?(0[13-9]|1[012])|31[-/]?(0[13578]|1[02])|(0[1-9]|1[0-9]|2[0-8])[-/]?02)[-/]?[0-9]{4}|29[-/]?02[-/]?([0-9]{2}(([2468][048]|[02468][48])|[13579][26])|([13579][26]|[02468][048]|0[0-9]|1[0-6])00))$',
    ).hasMatch(this);
  }

  bool isValidReferralCode() {
    if (this.isEmpty) {
      return true;
    }

    if (this.length != 7) {
      return false;
    }

    return RegExp(r'^[0-9]+$').hasMatch(this);
  }

  bool isNumeric() {
    if (this.isEmpty) {
      return false;
    }

    if (double.tryParse(this) == null) {
      return false;
    } else {
      return true;
    }
  }
}
