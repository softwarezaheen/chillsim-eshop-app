import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/presentation/extensions/context_extension.dart";
import "package:esim_open_source/presentation/setup_bottom_sheet_ui.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/presentation/views/base/base_view.dart";
import "package:esim_open_source/presentation/views/bottom_sheet/tax_bottom_sheet/tax_bottom_sheet_view_model.dart";
import "package:esim_open_source/presentation/widgets/bottom_sheet_container.dart";
import "package:esim_open_source/presentation/widgets/main_button.dart";
import "package:esim_open_source/presentation/widgets/my_card_wrap.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:stacked_services/stacked_services.dart";

class TaxBottomSheet extends StatelessWidget {
  const TaxBottomSheet({
    required this.request,
    required this.completer,
    super.key,
  });

  final SheetRequest<TaxBottomRequest> request;
  final Function(SheetResponse<EmptyBottomSheetResponse>) completer;

  @override
  Widget build(BuildContext context) {
    return BaseView.bottomSheetBuilder<TaxBottomSheetViewModel>(
      viewModel: TaxBottomSheetViewModel(
        request: request,
        completer: completer,
      ),
      builder: (
        BuildContext context,
        TaxBottomSheetViewModel viewModel,
        Widget? childWidget,
        double screenHeight,
      ) {
        return BottomSheetContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            spacing: 5,
            children: <Widget>[
              Text(
                LocaleKeys.summary_of_payment.tr(),
                style: headerThreeMediumTextStyle(
                  context: context,
                  fontColor: context.appColors.primary_900,
                ),
              ),
              verticalSpaceSmall,
              MyCardWrap(
                padding: const EdgeInsets.all(14),
                color: context.appColors.grey_100,
                enableBorder: false,
                child: Column(
                  children: <Widget>[
                    rowItem(
                      context,
                      LocaleKeys.subtotal.tr(),
                      request.data?.subTotal ?? "",
                    ),
                    verticalSpaceSmall,
                    rowItem(
                      context,
                      LocaleKeys.estimated_tax.tr(),
                      request.data?.estimatedTax ?? "",
                    ),
                    Divider(
                      color: context.appColors.grey_200,
                      height: 25,
                    ),
                    rowItem(
                      context,
                      LocaleKeys.total.tr(),
                      request.data?.total ?? "",
                    ),
                  ],
                ),
              ),
              verticalSpaceSmall,
              MainButton(
                title: LocaleKeys.confirm.tr(),
                titleTextStyle: bodyBoldTextStyle(context: context),
                onPressed: () async {
                  completer(
                    SheetResponse<EmptyBottomSheetResponse>(
                      confirmed: true,
                    ),
                  );
                },
                themeColor: themeColor,
                height: 53,
                hideShadows: true,
                enabledTextColor: enabledMainButtonTextColor(context: context),
              ),
            ],
          ),
          onCloseTap: () => completer(
            SheetResponse<EmptyBottomSheetResponse>(),
          ),
        );
      },
    );
  }

  Widget rowItem(BuildContext context, String title, String subtitle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          title,
          style: captionOneNormalTextStyle(
            context: context,
            fontColor: context.appColors.primary_900,
          ),
        ),
        Text(
          subtitle,
          style: captionOneBoldTextStyle(
            context: context,
            fontColor: context.appColors.grey_500,
          ),
        ),
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        DiagnosticsProperty<SheetRequest<TaxBottomRequest>>(
          "request",
          request,
        ),
      )
      ..add(
        ObjectFlagProperty<
            Function(SheetResponse<EmptyBottomSheetResponse> p1)>.has(
          "completer",
          completer,
        ),
      );
  }
}
