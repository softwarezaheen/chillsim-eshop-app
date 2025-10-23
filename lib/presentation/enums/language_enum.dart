enum LanguageEnum {
  arabic,
  english,
  french,
  romanian,
  spanish;

  static LanguageEnum fromString(String language) {
    if (language == LanguageEnum.english.languageText) {
      return LanguageEnum.english;
    } else if (language == LanguageEnum.french.languageText) {
      return LanguageEnum.french;
    } else if (language == LanguageEnum.romanian.languageText) {
      return LanguageEnum.romanian;
    } else if (language == LanguageEnum.spanish.languageText) {
      return LanguageEnum.spanish;
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
    } else if (languageCode == LanguageEnum.spanish.code) {
      return LanguageEnum.spanish;
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
      case LanguageEnum.spanish:
        return "es";
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
      case LanguageEnum.spanish:
        return "Español";
    }
  }

  bool get isRTL {
    switch (this) {
      case LanguageEnum.arabic:
        return true;
      case LanguageEnum.french:
      case LanguageEnum.english:
      case LanguageEnum.romanian:
      case LanguageEnum.spanish:
        return false;
    }
  }
}
