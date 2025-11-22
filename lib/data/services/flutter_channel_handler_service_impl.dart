import "dart:developer";

import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/domain/repository/services/flutter_channel_handler_service.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/services.dart";

class FlutterChannelHandlerServiceImpl implements FlutterChannelHandlerService {
  FlutterChannelHandlerServiceImpl.initialize();

  // Define the method channel
  static const MethodChannel flutterToNativePlatform =
      MethodChannel("zaheen.esim.chillsim/flutter_to_native");

  static FlutterChannelHandlerServiceImpl getInstance() {
    _instance ??= FlutterChannelHandlerServiceImpl.initialize();
    return _instance!;
  }

  String errorMessage = LocaleKeys.eSim_installation_error_message.tr();

  static FlutterChannelHandlerServiceImpl? _instance;

  @override
  Future<void> openSimProfilesSettings() async {
    try {
      await flutterToNativePlatform.invokeMethod("openSimProfilesSettings");
    } on PlatformException catch (e) {
      log("openSimProfilesSettings Error : ${e.message}");
      throw Exception(errorMessage);
    } on Object catch (e) {
      log("openSimProfilesSettings Error: $e");
      throw Exception(errorMessage);
    }
  }

  @override
  Future<void> openEsimSetupForIOS({
    required String smdpAddress,
    required String activationCode,
  }) async {
    try {
      String cardData = "LPA:1\$$smdpAddress\$$activationCode";
      await flutterToNativePlatform.invokeMethod(
        "openEsimSetup",
        <String, String>{"cardData": cardData},
      );
    } on PlatformException catch (e) {
      log("openEsimSetup Error : ${e.message}");
      throw Exception(errorMessage);
    } on Object catch (e) {
      log("openEsimSetup Error: $e");
      throw Exception(errorMessage);
    }
  }

  @override
  Future<bool> openEsimSetupForAndroid({
    required String smdpAddress,
    required String activationCode,
    bool isSHAExist = false,
  }) async {
    try {
      // Check if activation code already contains full LPA string
      String cardData;
      if (activationCode.toUpperCase().startsWith("LPA:1\$")) {
        // Backend sent full LPA string, use it directly
        cardData = activationCode;
        log("Using full LPA string from backend: $cardData");
      } else {
        // Backend sent just the matching ID, construct full LPA string
        cardData = "LPA:1\$$smdpAddress\$$activationCode";
        log("Constructed LPA string: $cardData");
      }
      
      bool result = await flutterToNativePlatform.invokeMethod(
        "openEsimSetup",
        <String, String>{
          "cardData": cardData,
          "isSHAExist": "$isSHAExist",
        },
      );
      if (!result) {
        throw Exception("eSIM installation is not supported on this Android version. Please upgrade to Android 9 or higher.");
      }
      return result;
    } on PlatformException catch (e) {
      log("openEsimSetupForAndroid Error : ${e.message}");
      // Provide more helpful error messages
      if (e.message?.contains("not supported") ?? false) {
        throw Exception("eSIM is not supported on this device");
      }
      throw Exception(e.message ?? errorMessage);
    } on Object catch (e) {
      log("openEsimSetupForAndroid Error: $e");
      throw Exception(errorMessage);
    }
  }
}
