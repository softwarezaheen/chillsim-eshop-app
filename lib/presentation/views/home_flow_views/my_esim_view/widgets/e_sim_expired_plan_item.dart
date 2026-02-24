import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/di/locator.dart";
import "package:esim_open_source/domain/repository/services/connectivity_service.dart";
import "package:esim_open_source/presentation/extensions/shimmer_extensions.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/presentation/views/home_flow_views/my_esim_view/widgets/bundle_divider_view.dart";
import "package:esim_open_source/presentation/widgets/bundle_header_view.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

class ESimExpiredPlanItem extends StatelessWidget {
  const ESimExpiredPlanItem({
    required this.countryCode,
    required this.title,
    required this.subTitle,
    required this.dataValue,
    required this.price,
    required this.validity,
    required this.expiryDate,
    required this.isLoading,
    required this.onItemClick,
    required this.showUnlimitedData,
    this.iconPath,
    super.key,
  });

  final String countryCode;
  final String title;
  final String subTitle;
  final String dataValue;
  final String price;
  final String validity;
  final String expiryDate;
  final bool isLoading;
  final String? iconPath;
  final VoidCallback onItemClick;
  final bool showUnlimitedData;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (await locator<ConnectivityService>().isConnected()) {
          onItemClick.call();
        }
      },
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: mainBorderColor(context: context),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              //flag , countryName, 5GB
              BundleHeaderView(
                title: title,
                subTitle: subTitle,
                dataValue: dataValue,
                countryPrice: price,
                isLoading: isLoading,
                imagePath: iconPath,
                showUnlimitedData: showUnlimitedData,
                contentStyle: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  color: contentTextColor(context: context).withValues(alpha: 0.6),
                  fontFamily: Theme.of(context).textTheme.labelLarge?.fontFamily,
                ),
              ),
              const BundleDivider(),
              Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      LocaleKeys.last_purchase.tr(),
                      style: captionTwoBoldTextStyle(context: context),
                    ).applyShimmer(context: context, enable: isLoading),
                    horizontalSpaceSmall,
                    Text(
                      expiryDate,
                      style: captionTwoNormalTextStyle(context: context),
                    ).applyShimmer(context: context, enable: isLoading),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty("countryCode", countryCode))
      ..add(StringProperty("countryTitle", title))
      ..add(StringProperty("bundleName", subTitle))
      ..add(StringProperty("dataValue", dataValue))
      ..add(StringProperty("price", price))
      ..add(DiagnosticsProperty<String>("validity", validity))
      ..add(DiagnosticsProperty<String>("expiryDate", expiryDate))
      ..add(DiagnosticsProperty<bool>("isLoading", isLoading))
      ..add(StringProperty("iconPath", iconPath))
      ..add(ObjectFlagProperty<VoidCallback>.has("onItemClick", onItemClick))
      ..add(DiagnosticsProperty<bool>("showUnlimitedData", showUnlimitedData));
  }
}
