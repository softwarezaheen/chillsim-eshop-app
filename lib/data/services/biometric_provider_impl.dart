// import "dart:async";
//
// import "package:esim_open_source/domain/repository/services/biometric_provider.dart";
// import "package:flutter/material.dart";
// import "package:flutter/services.dart";
// import "package:local_auth/local_auth.dart";
//
// class BiometricAuthServiceImpl implements BiometricAuthService {
//   BiometricAuthServiceImpl.privateConstructor();
//   final LocalAuthentication auth = LocalAuthentication();
//   _SupportState _supportState = _SupportState.unknown;
//   bool? _canCheckBiometrics;
//   List<BiometricType>? _availableBiometrics;
//   // String _authorized = 'Not Authorized';
//   bool _isAuthenticating = false;
//
//   static BiometricAuthServiceImpl? _instance;
//
//   static BiometricAuthServiceImpl get instance {
//     if (_instance == null) {
//       _instance = BiometricAuthServiceImpl.privateConstructor();
//       unawaited(_instance?._initialise());
//     }
//     return _instance!;
//   }
//
//   Future<void> _initialise() async {
//     bool isSupported = await auth.isDeviceSupported();
//     _supportState =
//         isSupported ? _SupportState.supported : _SupportState.unsupported;
//   }
//
//   @override
//   Future<bool> checkBiometrics() async {
//     late bool canCheckBiometrics;
//     try {
//       canCheckBiometrics = await auth.canCheckBiometrics;
//     } on PlatformException catch (e) {
//       canCheckBiometrics = false;
//       log(e.message ?? "");
//     }
//     _canCheckBiometrics = canCheckBiometrics;
//     return (_canCheckBiometrics ?? false) &&
//         _supportState == _SupportState.supported;
//   }
//
//   @override
//   Future<List<BiometricType>?> getAvailableBiometrics() async {
//     late List<BiometricType> availableBiometrics;
//     try {
//       availableBiometrics = await auth.getAvailableBiometrics();
//     } on PlatformException catch (e) {
//       availableBiometrics = <BiometricType>[];
//       log(e.message ?? "");
//     }
//
//     _availableBiometrics = availableBiometrics;
//     return _availableBiometrics;
//   }
//
//   @override
//   Future<bool> authenticate() async {
//     bool authenticated = false;
//     try {
//       _isAuthenticating = true;
//       // _authorized = 'Authenticating';
//
//       authenticated = await auth.authenticate(
//         localizedReason: "Let OS determine authentication method",
//         options: const AuthenticationOptions(
//           stickyAuth: true,
//         ),
//       );
//       _isAuthenticating = false;
//     } on PlatformException catch (e) {
//       log(e.message ?? "");
//
//       _isAuthenticating = false;
//       // _authorized = 'Error - ${e.message}';
//     }
//     // _authorized = authenticated ? 'Authorized' : 'Not Authorized';
//     return authenticated;
//   }
//
//   @override
//   Future<bool> authenticateWithBiometrics() async {
//     bool authenticated = false;
//     try {
//       _isAuthenticating = true;
//       // _authorized = 'Authenticating';
//
//       authenticated = await auth.authenticate(
//         localizedReason:
//             "Scan your fingerprint (or face or whatever) to authenticate",
//         options: const AuthenticationOptions(
//           stickyAuth: true,
//           biometricOnly: true,
//         ),
//       );
//       _isAuthenticating = false;
//       // _authorized = 'Authenticating';
//     } on PlatformException catch (e) {
//       log(e.message ?? "");
//
//       _isAuthenticating = false;
//       // _authorized = 'Error - ${e.message}';
//     }
//
//     // final String message = authenticated ? 'Authorized' : 'Not Authorized';
//
//     // _authorized = message;
//     return authenticated;
//   }
//
//   @override
//   Future<bool> cancelAuthentication() async {
//     await auth.stopAuthentication();
//     _isAuthenticating = false;
//     return _isAuthenticating;
//   }
// }
//
// enum _SupportState {
//   unknown,
//   supported,
//   unsupported,
// }
