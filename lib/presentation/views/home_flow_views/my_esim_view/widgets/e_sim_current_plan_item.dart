import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/app/app.locator.dart";
import "package:esim_open_source/app/environment/app_environment.dart";
import "package:esim_open_source/data/remote/responses/bundles/country_response_model.dart";
import "package:esim_open_source/domain/repository/services/connectivity_service.dart";
import "package:esim_open_source/presentation/extensions/shimmer_extensions.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/presentation/views/home_flow_views/my_esim_view/widgets/bundle_divider_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/my_esim_view/widgets/bundle_info_row_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/my_esim_view/widgets/circular_icon_button.dart";
import "package:esim_open_source/presentation/views/home_flow_views/my_esim_view/widgets/esim_status_header_view.dart";
import "package:esim_open_source/presentation/widgets/bundle_header_view.dart";
import "package:esim_open_source/presentation/widgets/main_button.dart";
import "package:esim_open_source/presentation/widgets/supported_countries_widget.dart";
import "package:esim_open_source/presentation/widgets/top_up_button.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

class ESimCurrentPlanItem extends StatelessWidget {
  const ESimCurrentPlanItem({
    required this.status,
    required this.countryCode,
    required this.title,
    required this.subTitle,
    required this.dataValue,
    required this.price,
    required this.validity,
    required this.expiryDate,
    required this.supportedCountries,
    required this.onEditName,
    required this.statusTextColor,
    required this.statusBgColor,
    required this.onTopUpClick,
    required this.onConsumptionClick,
    required this.onInstallClick,
    required this.onItemClick,
    required this.onQrCodeClick,
    required this.showInstallButton,
    required this.isLoading,
    required this.iconPath,
    required this.showTopUpButton,
    required this.showUnlimitedData,
    this.isAutoTopupEnabled = false,
    this.onManageAutoTopupClick,
    super.key,
  });

  final String status;
  final Color statusTextColor;
  final Color statusBgColor;
  final String countryCode;
  final String title;
  final String subTitle;
  final String dataValue;
  final String price;
  final String validity;
  final String expiryDate;
  final List<CountryResponseModel> supportedCountries;
  final VoidCallback onEditName;
  final VoidCallback onTopUpClick;
  final VoidCallback onQrCodeClick;
  final VoidCallback onConsumptionClick;
  final VoidCallback onInstallClick;
  final VoidCallback onItemClick;
  final bool isLoading;
  final String iconPath;
  final bool showInstallButton;
  final bool showTopUpButton;
  final bool showUnlimitedData;
  final bool isAutoTopupEnabled;
  final VoidCallback? onManageAutoTopupClick;

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
              //inactive , editName
              ESimStatusHeader(
                status: status,
                statusTextColor: statusTextColor,
                statusBgColor: statusBgColor,
                onEditTap: onEditName,
                isLoading: isLoading,
                isAutoTopupEnabled: isAutoTopupEnabled,
              ),
              verticalSpaceSmall,
              //flag , countryName, 5GB
              BundleHeaderView(
                title: title,
                subTitle: subTitle,
                dataValue: dataValue,
                countryPrice: price,
                imagePath: iconPath,
                isLoading: isLoading,
                showUnlimitedData: showUnlimitedData,
              ),
              const BundleDivider(),
              //bundle validity, last purchased
              BundleInfoRow(
                validity: validity,
                expiryDate: expiryDate,
                isLoading: isLoading,
              ),
              verticalSpaceSmallMedium,
              !isLoading && supportedCountries.isNotEmpty
                  ? SupportedCountriesWidget(
                      countries: supportedCountries,
                      label: LocaleKeys.supportedCountries_tittleText.tr(),
                      backgroundColor: greyBackGroundColor(context: context),
                      isLoading: isLoading,
                    )
                  : Container(),
              verticalSpaceSmallMedium,
              buildBundleButtons(
                context: context,
                showInstallButton: showInstallButton,
                showTopUpButton: showTopUpButton && !isAutoTopupEnabled,
                onQrClick: onQrCodeClick,
                onConsumptionClick: onConsumptionClick,
                onTopUpClick: onTopUpClick,
                onInstallClick: onInstallClick,
                isLoading: isLoading,
              ),
              // Manage Auto Top-Up button
              if (isAutoTopupEnabled && onManageAutoTopupClick != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    children: <Widget>[
                      MainButton(
                        title: LocaleKeys.my_esim_manage_auto_topup.tr(),
                        onPressed: () async {
                          if (await locator<ConnectivityService>()
                              .isConnected()) {
                            onManageAutoTopupClick?.call();
                          }
                        },
                        hideShadows: true,
                        height: 40,
                        horizontalPadding: 15,
                        titleTextStyle:
                            captionOneMediumTextStyle(context: context),
                        leadingWidget: Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: Icon(
                            size: 20,
                            Icons.settings,
                            color: iconButtonColor(context: context),
                          ),
                        ),
                        borderColor: mainBorderColor(context: context),
                        enabledBackgroundColor:
                            mainWhiteTextColor(context: context),
                        themeColor: themeColor,
                        enabledTextColor: iconButtonColor(context: context),
                      ).applyShimmer(
                        enable: isLoading,
                        context: context,
                        height: 20,
                      ),
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
      ..add(StringProperty("status", status))
      ..add(
        StringProperty("countryCode", countryCode),
      )
      ..add(
        StringProperty("countryTitle", title),
      )
      ..add(
        StringProperty("bundleName", subTitle),
      )
      ..add(
        StringProperty("dataValue", dataValue),
      )
      ..add(
        StringProperty("price", price),
      )
      ..add(
        DiagnosticsProperty<String>("validity", validity),
      )
      ..add(
        DiagnosticsProperty<String>("expiryDate", expiryDate),
      )
      ..add(
        IterableProperty<CountryResponseModel>(
          "supportedCountries",
          supportedCountries,
        ),
      )
      ..add(
        ObjectFlagProperty<VoidCallback>.has("onEditName", onEditName),
      )
      ..add(ColorProperty("statusTextColor", statusTextColor))
      ..add(ColorProperty("statusBgColor", statusBgColor))
      ..add(ObjectFlagProperty<VoidCallback>.has("onTopUpClick", onTopUpClick))
      ..add(
        ObjectFlagProperty<VoidCallback>.has("onQrCodeClick", onQrCodeClick),
      )
      ..add(
        ObjectFlagProperty<VoidCallback>.has(
          "onConsumptionClick",
          onConsumptionClick,
        ),
      )
      ..add(
        ObjectFlagProperty<VoidCallback>.has(
          "onInstallClick",
          onInstallClick,
        ),
      )
      ..add(DiagnosticsProperty<bool>("isLoading", isLoading))
      ..add(ObjectFlagProperty<VoidCallback>.has("onItemClick", onItemClick))
      ..add(StringProperty("iconPath", iconPath))
      ..add(DiagnosticsProperty<bool>("showInstallButton", showInstallButton))
      ..add(DiagnosticsProperty<bool>("showTopUpButton", showTopUpButton))
      ..add(DiagnosticsProperty<bool>("showUnlimitedData", showUnlimitedData))
      ..add(DiagnosticsProperty<bool>("isAutoTopupEnabled", isAutoTopupEnabled))
      ..add(ObjectFlagProperty<VoidCallback?>.has("onManageAutoTopupClick", onManageAutoTopupClick));
  }
}

Widget buildBundleButtons({
  required BuildContext context,
  required void Function() onQrClick,
  required void Function() onConsumptionClick,
  required void Function() onTopUpClick,
  required void Function() onInstallClick,
  required bool isLoading,
  required bool showInstallButton,
  required bool showTopUpButton,
}) {
  if (showInstallButton) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        showTopUpButton
            ? TopUpButton(
                onClick: () async {
                  if (await locator<ConnectivityService>().isConnected()) {
                    onTopUpClick.call();
                  }
                },
                isLoading: isLoading,
              )
            : Container(),
        MainButton(
          title: LocaleKeys.install.tr(),
          onPressed: onInstallClick,
          hideShadows: true,
          height: 40,
          horizontalPadding: 15,
          enabledTextColor: mainWhiteTextColor(context: context),
          titleTextStyle: captionOneMediumTextStyle(context: context)
              .copyWith(color: mainWhiteTextColor(context: context)),
          leadingWidget: Padding(
            padding: const EdgeInsets.only(right: 4),
            child: Icon(
              size: 20,
              Icons.install_mobile,
              color: mainWhiteTextColor(context: context),
            ),
          ),
          themeColor: themeColor,
        ).applyShimmer(enable: isLoading, context: context, height: 20),
        CircularIconButton(
          icon: Icons.bar_chart,
          borderRadius:
              AppEnvironment.appEnvironmentHelper.environmentCornerRadius,
          iconColor: iconButtonColor(context: context),
          onPressed: () async {
            if (await locator<ConnectivityService>().isConnected()) {
              onConsumptionClick.call();
            }
          },
        ).applyShimmer(enable: isLoading, context: context),
        CircularIconButton(
          icon: Icons.qr_code,
          borderRadius:
              AppEnvironment.appEnvironmentHelper.environmentCornerRadius,
          onPressed: onQrClick,
          iconColor: iconButtonColor(context: context),
        ).applyShimmer(enable: isLoading, context: context),
      ],
    );
  } else {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            MainButton(
              title: LocaleKeys.qr_code.tr(),
              onPressed: onQrClick,
              hideShadows: true,
              height: 40,
              horizontalPadding: 15,
              titleTextStyle: captionOneMediumTextStyle(context: context),
              leadingWidget: Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Icon(
                  size: 20,
                  Icons.qr_code,
                  color: iconButtonColor(context: context),
                ),
              ),
              borderColor: mainBorderColor(context: context),
              enabledBackgroundColor: mainWhiteTextColor(context: context),
              themeColor: themeColor,
              enabledTextColor: iconButtonColor(context: context),
            ).applyShimmer(enable: isLoading, context: context, height: 20),
            horizontalSpaceSmallMedium,
            MainButton(
              title: LocaleKeys.consumption.tr(),
              onPressed: () async {
                if (await locator<ConnectivityService>().isConnected()) {
                  onConsumptionClick.call();
                }
              },
              hideShadows: true,
              height: 40,
              horizontalPadding: 15,
              titleTextStyle: captionOneMediumTextStyle(
                context: context,
              ),
              leadingWidget: Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Icon(
                  size: 20,
                  Icons.bar_chart,
                  color: iconButtonColor(context: context),
                ),
              ),
              borderColor: mainBorderColor(context: context),
              enabledBackgroundColor: mainWhiteTextColor(context: context),
              themeColor: themeColor,
              enabledTextColor: iconButtonColor(context: context),
            ).applyShimmer(enable: isLoading, context: context, height: 20),
          ],
        ),
        verticalSpaceSmall,
        isLoading ? verticalSpaceSmall : Container(),
        showTopUpButton
            ? Row(
                children: <Widget>[
                  TopUpButton(
                    isLoading: isLoading,
                    onClick: () async {
                      if (await locator<ConnectivityService>().isConnected()) {
                        onTopUpClick.call();
                      }
                    },
                  ),
                  const Spacer(),
                ],
              )
            : Container(),
      ],
    );
  }
}
