// import "dart:typed_data";
// import "dart:ui";
// import "package:flutter/material.dart";
// import "package:qr_flutter/qr_flutter.dart";
//
// Future<Uint8List> generateQrCode(String data) async {
//   final QrCode qrCode = QrCode.fromData(
//     data: data,
//     errorCorrectLevel: QrErrorCorrectLevel.L,
//   );
//   final QrPainter painter = QrPainter.withQr(
//     qr: qrCode,
//     dataModuleStyle: const QrDataModuleStyle(
//       dataModuleShape: QrDataModuleShape.square,
//       color: Colors.white,
//     ),
//     gapless: true,
//   );
//   final Image image = (await painter.toImage(600)) as Image;
//   final ByteData? byteData =
//       await image.toByteData(format: ImageByteFormat.png);
//   return byteData!.buffer.asUint8List();
// }
//
// extension on Image {
//   dynamic toByteData({required ImageByteFormat format}) {}
// }
