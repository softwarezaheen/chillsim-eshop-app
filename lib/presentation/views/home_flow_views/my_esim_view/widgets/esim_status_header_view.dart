import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/app/app.locator.dart";
import "package:esim_open_source/domain/repository/services/connectivity_service.dart";
import "package:esim_open_source/presentation/extensions/shimmer_extensions.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/widgets/main_button.dart";
import "package:esim_open_source/presentation/widgets/my_card_wrap.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

class ESimStatusHeader extends StatelessWidget {
  const ESimStatusHeader({
    required this.status,
    required this.statusTextColor,
    required this.statusBgColor,
    required this.onEditTap,
    required this.isLoading,
    super.key,
  });

  final String status;
  final Color statusTextColor;
  final Color statusBgColor;
  final VoidCallback onEditTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        MyCardWrap(
          borderRadius: 30,
          enableBorder: false,
          color: isLoading ? Colors.transparent : statusBgColor,
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Text(
            status,
            style: captionOneMediumTextStyle(context: context)
                .copyWith(color: statusTextColor, fontSize: 11),
          ).applyShimmer(enable: isLoading, context: context, width: 50),
        ),
        MainButton(
          height: 30,
          hideShadows: true,
          enabledBackgroundColor: enabledMainButtonColor(context: context),
          horizontalPadding: 12,
          leadingWidget: Icon(
            Icons.edit,
            size: 16,
            color: mainWhiteTextColor(context: context),
          ),
          enabledTextColor: mainWhiteTextColor(context: context),
          titleHorizontalPadding: 3,
          title: LocaleKeys.edit_name.tr(),
          titleTextStyle: captionOneMediumTextStyle(context: context)
              .copyWith(fontSize: 11),
          onPressed: () async {
            if (await locator<ConnectivityService>().isConnected()) {
              onEditTap.call();
            }
          },
          themeColor: themeColor,
        ).applyShimmer(enable: isLoading, context: context, height: 20),
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty("status", status))
      ..add(
        ObjectFlagProperty<VoidCallback>.has("onEditTap", onEditTap),
      )
      ..add(ColorProperty("statusTextColor", statusTextColor))
      ..add(ColorProperty("statusBgColor", statusBgColor))
      ..add(DiagnosticsProperty<bool>("isLoading", isLoading));
  }
}
