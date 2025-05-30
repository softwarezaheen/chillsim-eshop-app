enum ResponseCodes { testOneResponseCode }

extension ResponseCodesExtension on ResponseCodes {
  String get code {
    switch (this) {
      case ResponseCodes.testOneResponseCode:
        return "2002";
    }
  }
}
