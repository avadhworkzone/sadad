extension TextValidation on String? {
  /// Returns true if string is not :
  /// - null
  /// - empty
  /// - whitespace string.
  ///
  /// Characters considered "whitespace" are listed [here](https://stackoverflow.com/a/59826129/10830091).
  static String alphabetSpaceValidationPattern = r"[a-zA-Z0-9 ]";
  static String alphabetValidationPattern = r"[a-zA-Z ]";
  static String digitsValidationPattern = r"[0-9]";
  static String doubleDigitsValidationPattern = r'^\d*\.?\d{0,2}';
  static String digitsDotValidationPattern = r"[0-9.,]";
  static String addressValidationPattern = r"([a-zA-Z0-9_@ ])";
  static String emailAddressValidationPattern = r"([a-zA-Z0-9_@.])";
  static String password = r"[a-zA-Z0-9#!_@$%^&*-.]";
  static String bankAccountName = r"[a-zA-Z0-9 #!_@$%^&*-.]";

  bool get isValid => this != null && this!.trim().isNotEmpty;
  bool get isValidEmail =>
      this != null &&
      RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(this!);
}
