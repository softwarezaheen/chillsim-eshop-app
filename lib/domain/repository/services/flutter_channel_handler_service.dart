abstract class FlutterChannelHandlerService {
  Future<void> openSimProfilesSettings();
  Future<void> openEsimSetupForIOS({
    required String smdpAddress,
    required String activationCode,
  });
  Future<void> openEsimSetupForAndroid({
    required String smdpAddress,
    required String activationCode,
    bool isSHAExist = false,
  });
}
