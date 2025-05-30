import "package:easy_localization/easy_localization.dart";

extension StringExtensions on String {
  int upperCaseCount() {
    return runes.where((int rune) {
      String char = String.fromCharCode(rune);
      return RegExp(r"[A-Z]").hasMatch(char);
    }).length;
  }

  int lowerCaseCount() {
    return runes.where((int rune) {
      String char = String.fromCharCode(rune);
      return RegExp(r"[a-z]").hasMatch(char);
    }).length;
  }

  int digitCount() {
    return runes.where((int rune) {
      String char = String.fromCharCode(rune);
      return RegExp(r"\d").hasMatch(char);
    }).length;
  }

  int specialCharCount() {
    return runes.where((int rune) {
      String char = String.fromCharCode(rune);
      return RegExp(r"[^a-zA-Z0-9\s]").hasMatch(char);
    }).length;
  }

  bool isLettersOnly() {
    return RegExp(r"^[a-zA-Z]+$").hasMatch(this);
  }

  String keepOnlyDigits() {
    return replaceAll(RegExp(r"\D"), "");
  }

  String removeLastCharacters({int number = 1}) {
    if (length >= number) {
      return substring(0, length - number);
    }
    return this;
  }

  String get removeLastCharacter {
    if (length >= 1) {
      return substring(0, length - 1);
    }
    return this;
  }

  String addCharIfNotAvailable(String? character) {
    String newChar = character ?? "";
    if (toLowerCase().contains(newChar.toLowerCase())) {
      return this;
    }
    return newChar + this;
  }

  String get maskString {
    if (length < 5) {
      return this;
    }
    return "*" * (length - 3) + substring(length - 3, length);
  }
}

extension TimestampToDateTime on int {
  DateTime toDateTime({bool isSeconds = false}) {
    return isSeconds
        ? DateTime.fromMillisecondsSinceEpoch(this * 1000)
        : DateTime.fromMillisecondsSinceEpoch(this);
  }
}

// Extension on DateTime to format the date
extension DateTimeFormatting on DateTime {
  String formatDate({String pattern = "yyyy/MM/dd HH:mm:ss"}) {
    return DateFormat(pattern).format(this);
  }
}

extension DateStringExtension on String {
  String toFormattedDate({String format = "yyyy-MM-dd HH:mm:ss"}) {
    DateTime dateTime = DateTime.parse(this);
    return DateFormat(format).format(dateTime);
  }

  DateTime toDateTime({String format = "yyyy/MM/dd"}) {
    DateFormat dateFormat = DateFormat(format);
    return dateFormat.parse(this);
  }
}
