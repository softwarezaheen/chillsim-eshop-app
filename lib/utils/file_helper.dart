import "dart:io";
import "dart:ui" as ui;

import "package:esim_open_source/utils/display_message_helper.dart";
import "package:flutter/material.dart";
import "package:flutter/rendering.dart";
import "package:flutter/services.dart";
import "package:path_provider/path_provider.dart";
import "package:pdf/pdf.dart";
import "package:pdf/widgets.dart" as pw;
import "package:share_plus/share_plus.dart";

Future<dynamic> loadJsonFromAssets(String filePath) async {
  return rootBundle.loadString(filePath);
}

Future<String> captureImage({
  required GlobalKey globalKey,
  String? fileName,
}) async {
  RenderRepaintBoundary boundary =
      globalKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;
  ui.Image image = await boundary.toImage();
  ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  if (byteData != null) {
    String newFileName =
        fileName ?? "image_${DateTime.now().millisecondsSinceEpoch}";
    Directory directory = await getApplicationDocumentsDirectory();
    File imagePath = await File("${directory.path}/$newFileName.png").create();
    await imagePath.writeAsBytes(byteData.buffer.asUint8List());
    return imagePath.path;
  }
  return "";
}

Future<void> capturePdfAndShare({
  required GlobalKey globalKey,
  String? pdfFileName,
}) async {
  try {
    // Capture the view as an image
    RenderRepaintBoundary boundary =
        globalKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 3);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();

    // Create a PDF document
    final pw.Document pdf = pw.Document();
    // Add the image to the PDF
    final pw.MemoryImage pdfImage = pw.MemoryImage(pngBytes);
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Image(pdfImage),
          );
        },
      ),
    );

    // Save the PDF to a temporary file
    String newPdfFileName =
        pdfFileName ?? "document_${DateTime.now().millisecondsSinceEpoch}";
    final Directory tempDir = await getTemporaryDirectory();
    final String tempPath = "${tempDir.path}/$newPdfFileName.pdf";
    final File file = File(tempPath);
    await file.writeAsBytes(await pdf.save());

    DisplayMessageHelper.toast("Pdf Saved");
    // Share the PDF file
    await Share.shareXFiles(
      <XFile>[XFile(tempPath)],
    );
  } on Object catch (_) {
    DisplayMessageHelper.toast("Something went wrong");
  }
}

// Add this to your pubspec.yaml:
/*
dependencies:
  flutter:
    sdk: flutter
  share_plus: ^7.0.0
  path_provider: ^2.1.0
  pdf: ^3.10.0
*/
