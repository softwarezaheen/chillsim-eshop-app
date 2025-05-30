enum SocialMediaLoginType {
  apple,
  google,
  facebook;

  static SocialMediaLoginType getSocialMediaLoginType({required String name}) {
    switch (name) {
      case "apple":
        return SocialMediaLoginType.apple;
      case "google":
        return SocialMediaLoginType.google;
      case "facebook":
        return SocialMediaLoginType.facebook;
      default:
        return SocialMediaLoginType.google;
    }
  }
}

class SocialLoginResult {
  SocialLoginResult({
    required this.socialType,
    this.accessToken = "",
    this.refreshToken = "",
    this.errorMessage = "",
  });

  final String refreshToken;
  final String accessToken;
  final String errorMessage;
  final SocialMediaLoginType socialType;

  bool equals(SocialLoginResult previous) {
    return previous.socialType == socialType &&
        previous.accessToken == accessToken &&
        previous.errorMessage == errorMessage &&
        previous.refreshToken == refreshToken;
  }
}

abstract class SocialLoginService {
  Future<Stream<SocialLoginResult>> initialise({
    required String url,
    required String anonKey,
  });

  Stream<SocialLoginResult> get socialLoginResultStream;

  Future<Stream<SocialLoginResult>> signInWithApple();

  Future<Stream<SocialLoginResult>> signInWithGoogle();

  Future<Stream<SocialLoginResult>> signInWithFaceBook();

  Future<void> logOut();
}
