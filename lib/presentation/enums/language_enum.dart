enum LanguageEnum {
  arabic,
  english;

  static LanguageEnum fromString(String language) {
    if (language == LanguageEnum.english.languageText) {
      return LanguageEnum.english;
    }
    return LanguageEnum.arabic;
  }

  static LanguageEnum fromCode(String languageCode) {
    if (languageCode == LanguageEnum.english.code) {
      return LanguageEnum.english;
    }
    return LanguageEnum.arabic;
  }

  String get code {
    switch (this) {
      case LanguageEnum.arabic:
        return "ar";
      case LanguageEnum.english:
        return "en";
    }
  }

  String get languageText {
    switch (this) {
      case LanguageEnum.arabic:
        return "العربية";
      case LanguageEnum.english:
        return "English";
    }
  }

  bool get isRTL {
    switch (this) {
      case LanguageEnum.arabic:
        return true;
      case LanguageEnum.english:
        return false;
    }
  }
}
