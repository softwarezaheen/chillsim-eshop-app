import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/data/remote/responses/bundles/bundle_response_model.dart";
import "package:esim_open_source/data/remote/responses/bundles/country_response_model.dart";
import "package:esim_open_source/presentation/extensions/shimmer_extensions.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/presentation/views/home_flow_views/data_plans_view/data_plans_components/esim_bundle_item_widget.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

class BundlesListView extends StatelessWidget {
  const BundlesListView({
    required this.bundles,
    required this.showShimmer,
    required this.onBundleSelected,
    this.lastItemBottomPadding = 0,
    super.key,
  });

  final bool showShimmer;
  final List<BundleResponseModel> bundles;
  final void Function(BundleResponseModel selectedBundle) onBundleSelected;
  final int lastItemBottomPadding;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: bundles.length + (lastItemBottomPadding > 0 ? 1 : 0),
      separatorBuilder: (BuildContext context, int index) =>
          verticalSpaceSmallMedium,
      itemBuilder: (BuildContext context, int index) {
        if (index == bundles.length) {
          //reach the end
          return const SizedBox(height: 90);
        }

        return EsimBundleWidget(
          icon: bundles[index].icon ?? "",
          title: bundles[index].bundleName ?? "",
          data: bundles[index].gprsLimitDisplay ?? "",
          showUnlimitedData: bundles[index].unlimited ?? false,
          validFor: bundles[index].validityDisplay ?? "",
          supportedCountries:
              bundles[index].countries ?? <CountryResponseModel>[],
          priceButtonText: LocaleKeys.bundleInfo_priceText_noPrice.tr(
            // namedArgs: <String, String>{
            //   "price": bundles[index].priceDisplay ?? "",
            // },
          ),
          priceInfo: bundles[index].priceDisplay ?? "",
          availableCountries: <CountryResponseModel>[],
          onPriceButtonClick: () => onBundleSelected.call(bundles[index]),
        ).applyShimmer(
          context: context,
          enable: showShimmer,
        );
      },
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        ObjectFlagProperty<Function(BundleResponseModel selectedBundle)>.has(
          "onBundleSelected",
          onBundleSelected,
        ),
      )
      ..add(IterableProperty<BundleResponseModel>("bundles", bundles))
      ..add(DiagnosticsProperty<bool>("showShimmer", showShimmer))
      ..add(IntProperty("lastItemBottomPadding", lastItemBottomPadding));
  }
}
