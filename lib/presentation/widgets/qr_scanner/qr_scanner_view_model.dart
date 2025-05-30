import "dart:async";

import "package:esim_open_source/presentation/views/base/base_model.dart";
import "package:flutter/material.dart";
import "package:qr_code_scanner/qr_code_scanner.dart";

class QrScannerViewModel extends BaseModel {
  late QRViewController _controller;
  final GlobalKey _qrKey = GlobalKey(debugLabel: "QR");
  bool _isFlashEnabled = false;

  bool get isFlashEnabled => _isFlashEnabled;

  QRViewController get controller => _controller;

  GlobalKey get qrKey => _qrKey;

  void onModelReady() {
    _listenToController();
  }

  void setController(QRViewController controller) {
    _controller = controller;
    _listenToController();
  }

  void onPermissionSet(
    BuildContext context,
    QRViewController ctrl, {
    required bool hasPermission,
  }) {
    if (!hasPermission) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("no Permission")),
      );
    }
  }

  void onBackPressed() {
    _controller.dispose();
    navigationService.back();
  }

  Future<void> toggleFlash() async {
    _controller.toggleFlash();
    bool? status = await _controller.getFlashStatus();
    _isFlashEnabled = status ?? false;
    notifyListeners();
  }

  Future<bool> isFlashTurnedOn() async {
    bool result = (await _controller.getFlashStatus())!;
    return result;
  }

  void _listenToController() {
    _controller.scannedDataStream.listen((Barcode scanData) {
      _controller.dispose();
      navigationService.back(result: scanData.code);
    });
  }
}
