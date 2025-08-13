import "package:esim_open_source/app/environment/environment_images.dart";
import "package:esim_open_source/di/locator.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/presentation/views/base/base_view.dart";
import "package:esim_open_source/presentation/views/pre_sign_in/device_compability_check_view/device_compability_check_view_model.dart";
import "package:esim_open_source/presentation/widgets/padding_widget.dart";
import "package:flutter/material.dart";

class DeviceCompabilityCheckView extends StatelessWidget {
  const DeviceCompabilityCheckView({super.key});
  static const String routeName = "DeviceCompabilityView";

  @override
  Widget build(BuildContext context) {
    return BaseView<DeviceCompabilityCheckViewModel>(
      hideAppBar: true,
      routeName: routeName,
      viewModel: locator<DeviceCompabilityCheckViewModel>(),
      builder: (
        BuildContext context,
        DeviceCompabilityCheckViewModel viewModel,
        Widget? childWidget,
        double screenHeight,
      ) =>
          SizedBox.expand(
        child: PaddingWidget.applySymmetricPadding(
          vertical: 50,
          child: Column(
            children: <Widget>[
              Image.asset(
                EnvironmentImages.darkAppIcon.fullImagePath,
                width: screenWidth(context) / 2,
              ),
              verticalSpaceLarge,
              Text(
                viewModel.deviceCompatibleType.contentText,
                textAlign: TextAlign.center,
                style: captionOneNormalTextStyle(
                  context: context,
                  fontColor: mainDarkTextColor(context: context),
                ),
              ),
              const Spacer(),
              viewModel.deviceCompatibleType == DeviceCompatibleType.loading
                  ? Transform.scale(
                      scale: 0.8,
                      child: CircularProgressIndicator(
                        color: mainAppBackGroundColor(context: context),
                      ),
                    )
                  : Image.asset(
                      viewModel.deviceCompatibleType.contentImagePath,
                      width: 80,
                      height: 80,
                    ),
              verticalSpaceMassive,
            ],
          ),
        ),
      ),
    );
  }
}
