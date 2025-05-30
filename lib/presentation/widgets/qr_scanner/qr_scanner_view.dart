import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/presentation/views/base/base_view.dart";
import "package:esim_open_source/presentation/widgets/qr_scanner/qr_scanner_view_model.dart";
import "package:flutter/material.dart";
import "package:qr_code_scanner/qr_code_scanner.dart";

class QrScannerView extends StatelessWidget {
  const QrScannerView({super.key});
  static const String routeName = "QrScannerViewRoute";

  @override
  Widget build(BuildContext context) {
    double scanArea = screenWidthFraction(context, dividedBy: 1.2);

    return BaseView<QrScannerViewModel>(
      viewModel: QrScannerViewModel(),
      hideAppBar: true,
      routeName: routeName,
      builder: (
        BuildContext context,
        QrScannerViewModel model,
        Widget? child,
        double screenHeight,
      ) {
        return getBodyPage(context, model, scanArea);
      },
    );
  }

  Stack getBodyPage(
    BuildContext context,
    QrScannerViewModel model,
    double scanArea,
  ) {
    return Stack(
      children: <Widget>[
        Align(child: _buildQrView(context, model, scanArea)),
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      model.onBackPressed();
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () async {
                      model.toggleFlash();
                    },
                    icon: Icon(
                      model.isFlashEnabled
                          ? Icons.flash_off
                          : Icons.flash_on_outlined,
                      color:
                          model.isFlashEnabled ? Colors.yellow : Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(bottom: scanArea - scanArea / 2 - 20),
          ),
        ),
      ],
    );
  }

  Widget _buildQrView(
    BuildContext context,
    QrScannerViewModel model,
    double scanArea,
  ) {
    return QRView(
      key: model.qrKey,
      onQRViewCreated: (QRViewController controller) {
        model.setController(controller);
      },
      overlay: QrScannerOverlayShape(
        borderColor: mainBorderColor(context: context),
        borderRadius: 20,
        borderLength: 50,
        cutOutSize: scanArea,
      ),
      onPermissionSet: (QRViewController ctrl, bool p) => model.onPermissionSet(
        context,
        ctrl,
        hasPermission: p,
      ),
    );
  }
}
