import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/presentation/widgets/main_button.dart";
import "package:esim_open_source/presentation/widgets/main_input_field.dart";
import "package:esim_open_source/presentation/widgets/padding_widget.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

class ApplyPromoCode extends StatelessWidget {
  const ApplyPromoCode({
    required this.controller,
    required this.buttonText,
    required this.message,
    required this.isFieldEnabled,
    required this.textFieldIcon,
    required this.textFieldBorderColor,
    required this.callback,
    required this.isExpanded,
    required this.expandedCallBack,
    super.key,
  });

  final String message;
  final bool isFieldEnabled;
  final IconData textFieldIcon;
  final Color textFieldBorderColor;
  final TextEditingController controller;
  final String buttonText;
  final bool isExpanded;
  final VoidCallback expandedCallBack;
  final Function(String callBack) callback;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: expandedCallBack.call,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: lightGreyBackGroundColor(context: context),
          border: Border.all(
            color: lightGreyBackGroundColor(context: context),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: PaddingWidget.applySymmetricPadding(
          horizontal: 12,
          vertical: 12,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    LocaleKeys.promoCodeView_titleText.tr(),
                    style: captionOneMediumTextStyle(
                      context: context,
                      fontColor: titleTextColor(context: context),
                    ),
                  ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 20,
                    color: mainTabBackGroundColor(
                      context: context,
                    ),
                  ),
                ],
              ),
              isExpanded
                  ? Column(
                      children: <Widget>[
                        verticalSpaceSmallMedium,
                        MainInputField.promoCode(
                          enabled: isFieldEnabled,
                          controller: controller,
                          themeColor: themeColor,
                          hintText: LocaleKeys.promoCodeView_titleText.tr(),
                          hintLabelStyle: captionOneNormalTextStyle(
                            context: context,
                            fontColor: secondaryTextColor(context: context),
                          ),
                          backGroundColor:
                              whiteBackGroundColor(context: context),
                          message: message,
                          icon: textFieldIcon,
                          color: textFieldBorderColor,
                        ),
                        //verticalSpaceSmall,
                        MainButton(
                          height: 38,
                          hideShadows: true,
                          title: buttonText,
                          onPressed: () => callback.call(controller.text),
                          isEnabled: controller.text.trim().isNotEmpty,
                          themeColor: themeColor,
                          enabledTextColor:
                              mainWhiteTextColor(context: context),
                          disabledTextColor:
                              disabledMainButtonTextColor(context: context),
                          disabledBackgroundColor:
                              disabledMainButtonColor(context: context),
                          enabledBackgroundColor:
                              promoCodeButtonColor(context: context),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
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
      ..add(
        ObjectFlagProperty<Function(String callBack)>.has(
          "callback",
          callback,
        ),
      )
      ..add(ColorProperty("textFieldBorderColor", textFieldBorderColor))
      ..add(DiagnosticsProperty<IconData>("textFieldIcon", textFieldIcon))
      ..add(DiagnosticsProperty<bool>("isFieldEnabled", isFieldEnabled))
      ..add(StringProperty("message", message))
      ..add(
        DiagnosticsProperty<TextEditingController>("controller", controller),
      )
      ..add(StringProperty("buttonText", buttonText))
      ..add(DiagnosticsProperty<bool>("isExpanded", isExpanded))
      ..add(
        DiagnosticsProperty<VoidCallback>(
          "expandedCallBack",
          expandedCallBack,
        ),
      );
  }
}
