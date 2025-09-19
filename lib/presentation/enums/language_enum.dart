enum LanguageEnum {
  arabic,
  english,
  french,
  romanian;

  static LanguageEnum fromString(String language) {
    if (language == LanguageEnum.english.languageText) {
      return LanguageEnum.english;
    } else if (language == LanguageEnum.french.languageText) {
      return LanguageEnum.french;
    } else if (language == LanguageEnum.romanian.languageText) {
      return LanguageEnum.romanian;
    } else {
      return LanguageEnum.arabic;
    }
  }

  static LanguageEnum fromCode(String languageCode) {
    if (languageCode == LanguageEnum.english.code) {
      return LanguageEnum.english;
    } else if (languageCode == LanguageEnum.french.code) {
      return LanguageEnum.french;
    } else if (languageCode == LanguageEnum.romanian.code) {
      return LanguageEnum.romanian;
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
      case LanguageEnum.romanian:
        return "ro";
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
      case LanguageEnum.romanian:
        return "Română";
    }
  }

  bool get isRTL {
    switch (this) {
      case LanguageEnum.arabic:
        return true;
      case LanguageEnum.french:
      case LanguageEnum.english:
      case LanguageEnum.romanian:
        return false;
    }
  }
}
