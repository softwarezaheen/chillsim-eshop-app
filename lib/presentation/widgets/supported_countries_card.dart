import "dart:math";

import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/data/remote/responses/bundles/country_response_model.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/widgets/country_flag_image.dart";
import "package:esim_open_source/presentation/widgets/info_row_view.dart";
import "package:esim_open_source/presentation/widgets/padding_widget.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

class SupportedCountriesCard extends StatefulWidget {
  const SupportedCountriesCard({required this.countries, super.key});

  final List<CountryResponseModel> countries;

  @override
  State<SupportedCountriesCard> createState() => _SupportedCountriesCardState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(IterableProperty<CountryResponseModel>("countries", countries));
  }
}

class _SupportedCountriesCardState extends State<SupportedCountriesCard> {
  bool _isExpanded = false;

  List<CountryResponseModel> get sortedCountries {
    final countries = List<CountryResponseModel>.from(widget.countries);
    countries.sort((a, b) => (a.country ?? '').compareTo(b.country ?? ''));
    return countries;
  }

  double getHeight() {
    double maxHeight = 180;
    double cellHeight = _isExpanded ? 40 + 40 : 40;
    double allHeight = widget.countries.length * cellHeight;
    return min(maxHeight, allHeight);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      color: lightGreyBackGroundColor(context: context),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          PaddingWidget.applySymmetricPadding(
            vertical: 12,
            horizontal: 12,
            child: Text(
              LocaleKeys.supportedCountries_card_tittleText.tr(
                namedArgs: <String, String>{
                  "countries": "(${widget.countries.length})",
                },
              ),
              style: captionTwoMediumTextStyle(
                context: context,
                fontColor: bundleDataPriceTextColor(context: context),
              ),
            ),
          ),
          //verticalSpaceSmall,
          SizedBox(
            height: getHeight(),
            child: Scrollbar(
              thickness: 4,
              radius: const Radius.circular(2),
              child: ListView.builder(
                itemCount: sortedCountries.length,
                itemBuilder: (BuildContext context, int index) {
                  final CountryResponseModel country = sortedCountries[index];
                  return ExpansionTile(
                    collapsedIconColor:
                        mainTabBackGroundColor(context: context),
                    iconColor: mainTabBackGroundColor(context: context),
                    minTileHeight: 0,
                    shape: const Border(),
                    onExpansionChanged: (bool isExpanded) {
                      setState(() {
                        _isExpanded = isExpanded;
                      });
                    },
                    trailing: Icon(
                      _isExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      size: 20,
                    ),
                    tilePadding: const EdgeInsets.symmetric(horizontal: 12),
                    title: Row(
                      children: <Widget>[
                        CountryFlagImage(
                          icon: sortedCountries[index].icon ?? "",
                          height: 20,
                          width: 20,
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Text(
                          country.country ?? "",
                          style: captionTwoMediumTextStyle(
                            context: context,
                            fontColor: bubbleCountryTextColor(
                              context: context,
                            ),
                          ),
                        ),
                      ],
                    ),
                    children: <Widget>[
                      (country.operatorList?.isNotEmpty ?? false)
                          ? InfoRow(
                              title: country.operatorList?.join(",") ??
                                  LocaleKeys.supportedCountries_noNetworks.tr(),
                              message: LocaleKeys
                                  .supportedCountries_availableNetworks
                                  .tr(),
                            )
                          : Container(),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
