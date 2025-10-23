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
    log("Initialising Supabase with url: $url");
    await _initializeSupaBase(url: url, anonKey: anonKey);
    log("Supabase initialised. Setting up auth state subscription.");
    _authStateSubscription =
        Supabase.instance.client.auth.onAuthStateChange.listen(
      (AuthState data) {
        log("Supabase authStateSubscription response:  $data");
        final Session? session = data.session;
        if (session != null) {
          log("Session found: ${session.user.appMetadata}");
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
        } else {
          log("No session found in auth state change.");
        }
      },
      onError: (dynamic error) {
        String errorMessage = error.toString();
        log("Auth state subscription error: $errorMessage");
        if (errorMessage.contains("Error getting user email")) {
          errorMessage =
              "Facebook account has no email. Please try another account";
        }
        _socialLoginResultStream.add(
          SocialLoginResult(
            socialType: SocialMediaLoginType.google,
            errorMessage: errorMessage,
          ),
        );
      },
    );
    log("Auth state subscription set up.");
    return socialLoginResultStream;
  }

  //Apple Sign in
  @override
  Future<Stream<SocialLoginResult>> signInWithApple() async {
    log("Starting Apple sign-in");
    try {
      String rawNonce = Supabase.instance.client.auth.generateRawNonce();
      String hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();
      log("Generated nonce for Apple sign-in: $rawNonce, hashed: $hashedNonce");
      final AuthorizationCredentialAppleID credential =
          await SignInWithApple.getAppleIDCredential(
        scopes: <AppleIDAuthorizationScopes>[
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: hashedNonce,
      );
      log("Apple credential received: ${credential.identityToken}");
      Supabase.instance.client.auth.signInWithIdToken(
        provider: OAuthProvider.apple,
        idToken: credential.identityToken ?? "",
        nonce: rawNonce,
      );
      log("Apple sign-in request sent to Supabase.");
    } on Object catch (error) {
      log("Apple sign-in error: $error");
      _socialLoginResultStream.add(
        SocialLoginResult(
          socialType: SocialMediaLoginType.apple,
          errorMessage: error.toString(),
        ),
      );
    }
    return socialLoginResultStream;
  }

  // Google Sign in - Use singleton instance with server client ID for Supabase
  // IMPORTANT: For iOS, we need to use the serverClientId to get ID tokens that Supabase accepts
  final GoogleSignIn googleSignIn = GoogleSignIn.instance;
  bool _isInitialized = false;

  // Initialize Google Sign In with server client ID for Supabase compatibility
  Future<void> _initializeGoogleSignIn() async {
    if (!_isInitialized) {
      try {
        // Use the Web Client ID as serverClientId - this ensures the ID token
        // has the correct audience that Supabase expects (not the iOS client ID)
        await googleSignIn.initialize(
          // Web Client ID from environment configuration
          // This must match what's configured in Supabase Google provider settings
          serverClientId: AppEnvironment.appEnvironmentHelper.googleWebClientId,
        );
        _isInitialized = true;
        log("GoogleSignIn initialized with Web Client ID: ${AppEnvironment.appEnvironmentHelper.googleWebClientId}");
      } on Object catch (e) {
        log("Failed to initialize Google Sign-In: $e");
      }
    }
  }

  @override
  Future<Stream<SocialLoginResult>> signInWithGoogle() async {
    log("Starting Google sign-in");
    // Ensure initialization first
    await _initializeGoogleSignIn();
    log("GoogleSignIn initialized.");
    GoogleSignInAccount? currentUser;
    try {
      log("Authenticating with Google...");
      // Use authenticate() instead of signIn()
      currentUser = await googleSignIn.authenticate(
        scopeHint: <String>["email"], // Use scopeHint parameter
      );
      log("GoogleSignInAccount: $currentUser");
      // Get authorization tokens through the authorization client
      final GoogleSignInClientAuthorization? authorization = await currentUser
          .authorizationClient
          .authorizationForScopes(<String>["email"]);
      log("Google authorization: $authorization");
      if (authorization == null) {
        log("Failed to get authorization from Google Sign In");
        throw Exception("Failed to get authorization from Google Sign In");
      }

      // Get access token from authorization
      String? accessToken = authorization.accessToken;
      
      // Get ID token from the authentication property of the user account
      final GoogleSignInAuthentication authentication = currentUser.authentication;
      String? idToken = authentication.idToken;
      
      log("Google accessToken: $accessToken, idToken: $idToken");
      
      if (idToken == null) {
        log("Failed to get ID token from Google Sign In");
        throw Exception("Failed to get ID token from Google Sign In");
      }
      
      await Supabase.instance.client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );
      log("Google sign-in request sent to Supabase.");
    } on GoogleSignInException catch (error) {
      log("GoogleSignInException: ${error.code}");
      if (error.code == GoogleSignInExceptionCode.canceled) {
        log("Sign in was canceled by user");
        _socialLoginResultStream.add(
          SocialLoginResult(
            socialType: SocialMediaLoginType.google,
            errorMessage: "Sign in was canceled by user",
          ),
        );
        return socialLoginResultStream;
      }
      _socialLoginResultStream.add(
        SocialLoginResult(
          socialType: SocialMediaLoginType.google,
          errorMessage: error.toString(),
        ),
      );
    } on Object catch (error) {
      log("General error during Google sign-in: $error");
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
    log("Starting Facebook sign-in");
    try {
      await Supabase.instance.client.auth.signInWithOAuth(
        OAuthProvider.facebook,
        redirectTo:
            AppEnvironment.appEnvironmentHelper.supabaseFacebookCallBackScheme,
        authScreenLaunchMode: LaunchMode.externalApplication,
        // scopes: "email public_profile",
      );
      log("Facebook sign-in request sent to Supabase.");
    } on Object catch (error) {
      log("Facebook sign-in error: $error");
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
    log("Logging out from Supabase, Google, and Facebook.");
    Supabase.instance.client.auth.signOut();
    googleSignIn.signOut();
    facebookAuth.logOut();
    log("Logout complete.");
  }

  Future<dynamic> _initializeSupaBase({
    required String url,
    required String anonKey,
  }) async {
    log("Initializing Supabase with url: $url, anonKey: $anonKey");
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

  @override
  Future<void> onDispose() async {
    log("Disposing SocialLoginServiceImpl.");
    await _authStateSubscription?.cancel();
    _authStateSubscription = null;
    await _socialLoginResultStream.close();
    log("Dispose complete.");
  }
}
