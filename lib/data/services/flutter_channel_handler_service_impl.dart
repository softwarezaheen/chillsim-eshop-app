import "dart:developer";

import "package:esim_open_source/domain/repository/services/flutter_channel_handler_service.dart";
import "package:flutter/services.dart";

class FlutterChannelHandlerServiceImpl implements FlutterChannelHandlerService {
  FlutterChannelHandlerServiceImpl.initialize();

  // Define the method channel
  static const MethodChannel flutterToNativePlatform =
      MethodChannel("com.luxe.esim/flutter_to_native");

  static FlutterChannelHandlerServiceImpl getInstance() {
    _instance ??= FlutterChannelHandlerServiceImpl.initialize();
    return _instance!;
  }

  static FlutterChannelHandlerServiceImpl? _instance;

  @override
  Future<void> openSimProfilesSettings() async {
    try {
      await flutterToNativePlatform.invokeMethod("openSimProfilesSettings");
    } on PlatformException catch (e) {
      log("openSimProfilesSettings Error : ${e.message}");
      rethrow;
    } on Object catch (e) {
      log("openSimProfilesSettings Error: $e");
      rethrow;
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
      rethrow;
    } on Object catch (e) {
      log("openEsimSetup Error: $e");
      rethrow;
    }
  }

  @override
  Future<bool> openEsimSetupForAndroid({
    required String smdpAddress,
    required String activationCode,
  }) async {
    try {
      String cardData = "LPA:1\$$smdpAddress\$$activationCode";
      bool result = await flutterToNativePlatform.invokeMethod(
        "openEsimSetup",
        <String, String>{"cardData": cardData},
      );
      if (!result) {
        throw Exception("eSIM installation not supported");
      }
      return result;
    } on PlatformException catch (e) {
      log("openEsimSetupForAndroid Error : ${e.message}");
      rethrow;
    } on Object catch (e) {
      log("openEsimSetupForAndroid Error: $e");
      rethrow;
    }
  }
}
