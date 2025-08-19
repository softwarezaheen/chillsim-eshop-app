import "dart:async";
import "dart:convert";
import "dart:developer";

import "package:crypto/crypto.dart";
import "package:esim_open_source/app/environment/app_environment.dart";
import "package:esim_open_source/domain/repository/services/social_login_service.dart";
import "package:flutter_facebook_auth/flutter_facebook_auth.dart";
import "package:google_sign_in/google_sign_in.dart";
import "package:sign_in_with_apple/sign_in_with_apple.dart";
import "package:supabase_flutter/supabase_flutter.dart";

class SocialLoginServiceImpl extends SocialLoginService {
  SocialLoginServiceImpl._privateConstructor();

  static SocialLoginServiceImpl? _instance;

  static SocialLoginServiceImpl get instance {
    _instance ??= SocialLoginServiceImpl._privateConstructor();
    return _instance!;
  }

  StreamSubscription<AuthState>? _authStateSubscription;

  final StreamController<SocialLoginResult> _socialLoginResultStream =
      StreamController<SocialLoginResult>.broadcast();

  @override
  Stream<SocialLoginResult> get socialLoginResultStream =>
      _socialLoginResultStream.stream
          .distinct((SocialLoginResult previous, SocialLoginResult current) {
        return previous.equals(current);
      });

  @override
  Future<Stream<SocialLoginResult>> initialise({
    required String url,
    required String anonKey,
  }) async {
    await _initializeSupaBase(url: url, anonKey: anonKey);
    _authStateSubscription =
        Supabase.instance.client.auth.onAuthStateChange.listen(
      (AuthState data) {
        log("Supabase authStateSubscription response:  $data");
        final Session? session = data.session;
        if (session != null) {
          String provider = session.user.appMetadata["provider"];
          SocialMediaLoginType socialMediaLoginType =
              SocialMediaLoginType.getSocialMediaLoginType(name: provider);
          _socialLoginResultStream.add(
            SocialLoginResult(
              accessToken: session.accessToken,
              refreshToken: session.refreshToken ?? "",
              socialType: socialMediaLoginType,
            ),
          );
        }
      },
      onError: (dynamic error) {
        String errorMessage = error.toString();

        if (errorMessage.contains("Error getting user email")) {
          errorMessage =
              "Facebook account has no email. Please try another account";
        }
        log("SupaBase authStateSubscription error:  $errorMessage");
        _socialLoginResultStream.add(
          SocialLoginResult(
            socialType: SocialMediaLoginType.google,
            errorMessage: errorMessage,
          ),
        );
      },
    );

    return socialLoginResultStream;
  }

  //Apple Sign in
  @override
  Future<Stream<SocialLoginResult>> signInWithApple() async {
    try {
      String rawNonce = Supabase.instance.client.auth.generateRawNonce();
      String hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();
      final AuthorizationCredentialAppleID credential =
          await SignInWithApple.getAppleIDCredential(
        scopes: <AppleIDAuthorizationScopes>[
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: hashedNonce,
      );

      Supabase.instance.client.auth.signInWithIdToken(
        provider: OAuthProvider.apple,
        idToken: credential.identityToken ?? "",
        nonce: rawNonce,
      );

      //log("email ${credential.email}, name: ${credential.givenName} ${credential.familyName}, accessToken: ${credential.identityToken}");
    } on Object catch (error) {
      log(error.toString());
      _socialLoginResultStream.add(
        SocialLoginResult(
          socialType: SocialMediaLoginType.apple,
          errorMessage: error.toString(),
        ),
      );
    }

    return socialLoginResultStream;
  }

  //Google Sign in
  GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: <String>["email"],
  );

  @override
  Future<Stream<SocialLoginResult>> signInWithGoogle() async {
    GoogleSignInAccount? currentUser;

    try {
      currentUser = await googleSignIn.signIn();
      GoogleSignInAuthentication? auth = await currentUser?.authentication;
      String accessToken = auth?.accessToken ?? "";
      String idToken = auth?.idToken ?? "";
      //log("email ${currentUser?.email}, name: ${currentUser?.displayName}, accessToken: $accessToken");

      await Supabase.instance.client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );
    } on Object catch (error) {
      log(error.toString());
      _socialLoginResultStream.add(
        SocialLoginResult(
          socialType: SocialMediaLoginType.google,
          errorMessage: error.toString(),
        ),
      );
    }

    return socialLoginResultStream;
  }

  //Facebook Sign in
  FacebookAuth facebookAuth = FacebookAuth.instance;

  @override
  Future<Stream<SocialLoginResult>> signInWithFaceBook() async {
    // final LoginResult result = await facebookAuth.login();
    // if (result.status == LoginStatus.success) {
    //   String accessToken = result.accessToken?.tokenString ?? "";
    //
    //   //log("accessToken: $accessToken");
    //
    //   return SocialLoginResult(
    //     accessToken: accessToken,
    //     socialType: SocialMediaLoginType.facebook,
    //   );
    // } else {
    //   log("Login Failed! Please try again.");
    //   return SocialLoginResult(
    //     socialType: SocialMediaLoginType.facebook,
    //   );
    // }

    try {
      await Supabase.instance.client.auth.signInWithOAuth(
        OAuthProvider.facebook,
        redirectTo:
            AppEnvironment.appEnvironmentHelper.supabaseFacebookCallBackScheme,
        authScreenLaunchMode: LaunchMode.externalApplication,
        // scopes: "email public_profile",
      );
    } on Object catch (error) {
      log("signInWithFaceBook: ${error.toString()}");
      _socialLoginResultStream.add(
        SocialLoginResult(
          socialType: SocialMediaLoginType.facebook,
          errorMessage: error.toString(),
        ),
      );
    }
    return socialLoginResultStream;
  }

  //Logout
  @override
  Future<void> logOut() async {
    Supabase.instance.client.auth.signOut();
    googleSignIn.signOut();
    facebookAuth.logOut();
  }

  Future<dynamic> _initializeSupaBase({
    required String url,
    required String anonKey,
  }) async {
    return Supabase.initialize(
      url: url,
      anonKey: anonKey,
      // authOptions: const FlutterAuthClientOptions(
      //   authFlowType: AuthFlowType.pkce,
      // ),
      // realtimeClientOptions: const RealtimeClientOptions(
      //   logLevel: RealtimeLogLevel.info,
      // ),
      // storageOptions: const StorageClientOptions(
      //   retryAttempts: 10,
      // ),
    );
  }

  void onDispose() {
    unawaited(_authStateSubscription?.cancel());
    _authStateSubscription = null;
    unawaited(_socialLoginResultStream.close());
  }
}
