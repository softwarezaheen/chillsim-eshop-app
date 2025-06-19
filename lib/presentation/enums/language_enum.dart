enum LanguageEnum {
  arabic,
  english,
  french;

  static LanguageEnum fromString(String language) {
    if (language == LanguageEnum.english.languageText) {
      return LanguageEnum.english;
    } else if (language == LanguageEnum.french.languageText) {
      return LanguageEnum.french;
    } else {
      return LanguageEnum.arabic;
    }
  }

  static LanguageEnum fromCode(String languageCode) {
    if (languageCode == LanguageEnum.english.code) {
      return LanguageEnum.english;
    } else if (languageCode == LanguageEnum.french.code) {
      return LanguageEnum.french;
    } else {
      return LanguageEnum.arabic;
    }
  }

  String get code {
    switch (this) {
      case LanguageEnum.arabic:
        return "ar";
      case LanguageEnum.english:
        return "en";
      case LanguageEnum.french:
        return "fr";
    }
  }

  String get languageText {
    switch (this) {
      case LanguageEnum.arabic:
        return "العربية";
      case LanguageEnum.english:
        return "English";
      case LanguageEnum.french:
        return "French";
    }
  }

  bool get isRTL {
    switch (this) {
      case LanguageEnum.arabic:
        return true;
      case LanguageEnum.french:
      case LanguageEnum.english:
        return false;
    }
  }
}
