import "package:easy_localization/easy_localization.dart" as lc;
import "package:esim_open_source/app/environment/environment_images.dart";
import "package:esim_open_source/presentation/extensions/helper_extensions.dart";
import "package:esim_open_source/presentation/shared/haptic_feedback.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/theme/theme_setup.dart";
import "package:esim_open_source/presentation/widgets/padding_widget.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";

class MainInputField extends StatefulWidget {
  const MainInputField({
    required this.controller,
    required this.themeColor,
    super.key,
    this.backgroundColor,
    this.borderRadius = 12,
    this.cursorColor,
    this.initialValue,
    this.maxLength,
    this.leadingIcon,
    this.inputBorder,
    this.hintText,
    this.labelText,
    this.helperText,
    this.labelStyle,
    this.suffixIcon,
    this.prefixIcon,
    this.focusColor,
    this.enabledBorder,
    this.disabledBorder,
    this.errorBorder,
    this.focusedBorder,
    this.focusedErrorBorder,
    this.textInputType,
    this.password = false,
    this.isReadOnly = false,
    this.fieldFocusNode,
    this.nextFocusNode,
    this.textInputAction,
    this.onChanged,
    this.formatter,
    this.enterPressed,
    this.forceSuffixDirection = false,
    this.autofillHints,
    this.autofocus = false,
    this.isObscure,
    this.onObscureChange,
    this.hideInternalObfuscator = false,
    this.prefixText,
    this.prefixStyle,
    this.removeBorder = false,
    this.inputTextStyle,
    this.textAlign,
    this.maxLines = 1,
    this.labelTitleText,
    this.errorIcon,
    this.errorMessage,
    this.errorBorderColor,
    this.textFieldHeight = 55,
    this.hintTextStyle,
    this.onTap,
  });
  final TextEditingController controller;
  final TextInputType? textInputType;
  final bool password;
  final bool? isObscure;
  final bool isReadOnly;
  final bool hideInternalObfuscator;

  // final String placeholder;
  // final String? validationMessage;
  final void Function()? enterPressed;

  // final bool smallVersion;
  final FocusNode? fieldFocusNode;
  final FocusNode? nextFocusNode;
  final TextInputAction? textInputAction;

  // final String? additionalNote;
  final VoidCallback? onTap;
  final void Function({required String text})? onChanged;
  final void Function({required bool value})? onObscureChange;
  final TextInputFormatter? formatter;
  final Color themeColor;
  final Color? backgroundColor;
  final Color? cursorColor;
  final Color? focusColor;
  final double borderRadius;
  final String? initialValue;
  final int? maxLength;
  final Widget? leadingIcon;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final InputBorder? inputBorder;
  final InputBorder? enabledBorder;
  final InputBorder? disabledBorder;
  final InputBorder? errorBorder;
  final InputBorder? focusedBorder;
  final InputBorder? focusedErrorBorder;
  final String? hintText;
  final String? labelText;
  final String? helperText;
  final String? prefixText;
  final TextStyle? labelStyle;
  final TextStyle? prefixStyle;
  final bool forceSuffixDirection;
  final Iterable<String>? autofillHints;
  final bool autofocus;
  final bool removeBorder;
  final TextStyle? inputTextStyle;
  final TextAlign? textAlign;
  final int? maxLines;
  final String? labelTitleText;
  final String? errorMessage;
  final Color? errorBorderColor;
  final IconData? errorIcon;
  final double textFieldHeight;
  final TextStyle? hintTextStyle;

  static MainInputField securedPassword({
    required TextEditingController controller,
    required Color themeColor,
    bool isReadOnly = false,
    bool autofocus = false,
    String? initialValue,
    bool? isObscure,
    void Function({required bool value})? onObscureChange,
    bool? hideInternalObfuscator,
    void Function()? enterPressed,
    TextInputFormatter? formatter,
    TextInputType? textInputType,
    Iterable<String>? autofillHints,
    bool? removeBorder,
    TextStyle? inputTextStyle,
    TextAlign? textAlign,
    String? labelText,
    TextStyle? labelStyle,
  }) {
    return MainInputField(
      controller: controller,
      hintText: LocaleKeys.password.tr(),
      password: true,
      isReadOnly: isReadOnly,
      themeColor: themeColor,
      autofocus: autofocus,
      isObscure: isObscure,
      onObscureChange: onObscureChange,
      hideInternalObfuscator: hideInternalObfuscator ?? false,
      initialValue: initialValue,
      enterPressed: enterPressed,
      formatter: formatter,
      autofillHints: autofillHints,
      textInputType: textInputType,
      removeBorder: removeBorder ?? false,
      inputTextStyle: inputTextStyle,
      textAlign: textAlign,
      labelText: labelText,
      labelStyle: labelStyle,
    );
  }

  static MainInputField text({
    required TextEditingController controller,
    required Color themeColor,
    String? hintText,
    String? initialValue,
    bool isReadOnly = false,
    void Function()? enterPressed,
    TextInputFormatter? formatter,
    TextInputType? textInputType,
    Iterable<String>? autofillHints,
    bool autofocus = false,
    bool? removeBorder,
    TextStyle? inputTextStyle,
    TextAlign? textAlign,
    String? labelText,
    TextStyle? labelStyle,
  }) {
    return MainInputField(
      autofocus: autofocus,
      controller: controller,
      textInputType: textInputType,
      hintText: hintText,
      isReadOnly: isReadOnly,
      initialValue: initialValue,
      enterPressed: enterPressed,
      formatter: formatter,
      themeColor: themeColor,
      autofillHints: autofillHints,
      removeBorder: removeBorder ?? false,
      inputTextStyle: inputTextStyle,
      textAlign: textAlign,
      labelText: labelText,
      labelStyle: labelStyle,
    );
  }

  static MainInputField multiline({
    required TextEditingController controller,
    required Color themeColor,
    String? hintText,
    String? initialValue,
    bool isReadOnly = false,
    void Function()? enterPressed,
    TextInputFormatter? formatter,
    TextInputType? textInputType,
    Iterable<String>? autofillHints,
    bool autofocus = false,
    bool? removeBorder,
    TextStyle? inputTextStyle,
    TextAlign? textAlign,
    int? maxLines = 1,
  }) {
    return MainInputField(
      autofocus: autofocus,
      controller: controller,
      textInputType: textInputType ?? TextInputType.multiline,
      hintText: hintText,
      isReadOnly: isReadOnly,
      initialValue: initialValue,
      enterPressed: enterPressed,
      formatter: formatter,
      themeColor: themeColor,
      autofillHints: autofillHints,
      removeBorder: removeBorder ?? false,
      inputTextStyle: inputTextStyle,
      textAlign: textAlign,
      maxLines: maxLines,
    );
  }

  static MainInputField formField({
    required TextEditingController controller,
    required Color themeColor,
    String? labelTitleText,
    String? hintText,
    Color? backGroundColor,
    String? errorMessage,
    TextStyle? labelStyle,
    TextStyle? hintLabelStyle,
    TextInputType? textInputType,
    int? maxLines,
    double textFieldHeight = 55,
  }) =>
      MainInputField(
        themeColor: themeColor,
        labelTitleText: labelTitleText,
        hintText: hintText,
        controller: controller,
        backgroundColor: backGroundColor,
        errorMessage: errorMessage,
        labelStyle: labelStyle,
        enterPressed: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        textInputType: textInputType,
        hintTextStyle: hintLabelStyle,
        maxLines: maxLines ?? 1,
        textFieldHeight: textFieldHeight,
      );

  static MainInputField promoCode({
    required TextEditingController controller,
    required Color themeColor,
    required bool enabled,
    String? hintText,
    Color? backGroundColor,
    String? message,
    IconData? icon,
    Color? color,
    TextStyle? labelStyle,
    TextStyle? hintLabelStyle,
    TextInputType? textInputType,
    double textFieldHeight = 45,
    void Function({required String text})? onChanged,
  }) =>
      MainInputField(
        isReadOnly: !enabled,
        themeColor: themeColor,
        hintText: hintText,
        controller: controller,
        backgroundColor: backGroundColor,
        errorMessage: message,
        errorBorderColor: color,
        errorIcon: icon,
        labelStyle: labelStyle,
        inputTextStyle: labelStyle,
        enterPressed: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        onChanged: onChanged,
        textInputType: textInputType,
        hintTextStyle: hintLabelStyle,
        textFieldHeight: textFieldHeight,
      );

  static MainInputField searchField({
    required TextEditingController controller,
    required Color themeColor,
    VoidCallback? onTap,
    String? hintText,
    Color? backGroundColor,
    TextStyle? labelStyle,
    VoidCallback? enterPressed,
  }) =>
      MainInputField(
        themeColor: themeColor,
        controller: controller,
        backgroundColor: backGroundColor,
        onTap: onTap,
        prefixIcon: PaddingWidget.applyPadding(
          end: 10,
          child: Image.asset(
            EnvironmentImages.searchIcon.fullImagePath,
            width: 15,
            height: 15,
          ),
        ),
        hintText: hintText,
        enterPressed: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        labelStyle: labelStyle,
      );

  @override
  State<MainInputField> createState() => _MainInputFieldState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        DiagnosticsProperty<TextEditingController>("controller", controller),
      )
      ..add(DiagnosticsProperty<TextInputType?>("textInputType", textInputType))
      ..add(DiagnosticsProperty<bool>("password", password))
      ..add(DiagnosticsProperty<bool?>("isObscure", isObscure))
      ..add(DiagnosticsProperty<bool>("isReadOnly", isReadOnly))
      ..add(
        DiagnosticsProperty<bool>(
          "hideInternalObfuscator",
          hideInternalObfuscator,
        ),
      )
      ..add(
        ObjectFlagProperty<void Function()?>.has(
          "enterPressed",
          enterPressed,
        ),
      )
      ..add(DiagnosticsProperty<FocusNode?>("fieldFocusNode", fieldFocusNode))
      ..add(DiagnosticsProperty<FocusNode?>("nextFocusNode", nextFocusNode))
      ..add(EnumProperty<TextInputAction?>("textInputAction", textInputAction))
      ..add(
        ObjectFlagProperty<void Function({required String text})?>.has(
          "onChanged",
          onChanged,
        ),
      )
      ..add(
        ObjectFlagProperty<void Function({required bool value})?>.has(
          "onObscureChange",
          onObscureChange,
        ),
      )
      ..add(DiagnosticsProperty<TextInputFormatter?>("formatter", formatter))
      ..add(ColorProperty("themeColor", themeColor))
      ..add(ColorProperty("backgroundColor", backgroundColor))
      ..add(ColorProperty("cursorColor", cursorColor))
      ..add(ColorProperty("focusColor", focusColor))
      ..add(DoubleProperty("borderRadius", borderRadius))
      ..add(StringProperty("initialValue", initialValue))
      ..add(IntProperty("maxLength", maxLength))
      ..add(DiagnosticsProperty<InputBorder?>("inputBorder", inputBorder))
      ..add(DiagnosticsProperty<InputBorder?>("enabledBorder", enabledBorder))
      ..add(DiagnosticsProperty<InputBorder?>("disabledBorder", disabledBorder))
      ..add(DiagnosticsProperty<InputBorder?>("errorBorder", errorBorder))
      ..add(DiagnosticsProperty<InputBorder?>("focusedBorder", focusedBorder))
      ..add(
        DiagnosticsProperty<InputBorder?>(
          "focusedErrorBorder",
          focusedErrorBorder,
        ),
      )
      ..add(StringProperty("hintText", hintText))
      ..add(StringProperty("labelText", labelText))
      ..add(StringProperty("helperText", helperText))
      ..add(StringProperty("prefixText", prefixText))
      ..add(DiagnosticsProperty<TextStyle?>("labelStyle", labelStyle))
      ..add(DiagnosticsProperty<TextStyle?>("prefixStyle", prefixStyle))
      ..add(
        DiagnosticsProperty<bool>(
          "forceSuffixDirection",
          forceSuffixDirection,
        ),
      )
      ..add(IterableProperty<String>("autofillHints", autofillHints))
      ..add(DiagnosticsProperty<bool>("autofocus", autofocus))
      ..add(DiagnosticsProperty<bool>("removeBorder", removeBorder))
      ..add(DiagnosticsProperty<TextStyle?>("inputTextStyle", inputTextStyle))
      ..add(EnumProperty<TextAlign?>("textAlign", textAlign))
      ..add(IntProperty("maxLines", maxLines))
      ..add(StringProperty("placeHolderText", labelTitleText))
      ..add(StringProperty("errorMessage", errorMessage))
      ..add(DoubleProperty("textFieldHeight", textFieldHeight))
      ..add(DiagnosticsProperty<TextStyle?>("hintTextStyle", hintTextStyle))
      ..add(ObjectFlagProperty<VoidCallback?>.has("onTap", onTap))
      ..add(ColorProperty("errorBorderColor", errorBorderColor))
      ..add(DiagnosticsProperty<IconData?>("errorIcon", errorIcon));
  }
}

class _MainInputFieldState extends State<MainInputField> {
  bool isPassword = false;

  @override
  void initState() {
    super.initState();
    isPassword = widget.password;
    if (widget.initialValue != null) {
      widget.controller.text = widget.initialValue!;
    }
  }

  @override
  void didUpdateWidget(covariant MainInputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if ((oldWidget.errorMessage != null ||
            (oldWidget.errorMessage?.isEmpty ?? true)) &&
        oldWidget.errorMessage != widget.errorMessage) {
      playHapticFeedback(HapticFeedbackType.validationError);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        widget.labelTitleText != null
            ? PaddingWidget.applySymmetricPadding(
                vertical: 5,
                child: Text(
                  widget.labelTitleText ?? "",
                  style: captionOneMediumTextStyle(
                    context: context,
                    fontColor: secondaryTextColor(context: context),
                  ),
                ).textSupportsRTL(context),
              )
            : const SizedBox.shrink(),
        SizedBox(
          height: widget.maxLines == 1 ? widget.textFieldHeight : null,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              color: widget.backgroundColor ??
                  Theme.of(context).colorScheme.cBackground(context),
              boxShadow: widget.removeBorder
                  ? null
                  : <BoxShadow>[
                      BoxShadow(
                        color: (widget.errorMessage == null ||
                                widget.errorMessage == "")
                            ? greyBackGroundColor(context: context)
                            : widget.errorBorderColor ??
                                errorTextColor(context: context),
                        spreadRadius: 1,
                      ),
                    ],
              // boxShadow: [
              //   BoxShadow(
              //       color: Theme.of(context).colorScheme.cHintTextColor(context).withAlpha(20), spreadRadius: 2, blurRadius: 1, offset: const Offset(0, 2)),
              //   BoxShadow(
              //       color: Theme.of(context).colorScheme.cHintTextColor(context).withAlpha(20), spreadRadius: 2, blurRadius: 1, offset: const Offset(0, -1)),
              // ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: <Widget>[
                  getPrefixIcon(context) ?? Container(),
                  Expanded(
                    child: TextFormField(
                      enabled: !widget.isReadOnly,
                      autofocus: widget.autofocus,
                      autofillHints: widget.autofillHints,
                      controller: widget.controller,
                      keyboardType: widget.textInputType,
                      focusNode: widget.fieldFocusNode,
                      textInputAction: widget.textInputAction,
                      onTap: widget.onTap,
                      onChanged: (String value) =>
                          widget.onChanged?.call(text: value),
                      inputFormatters: widget.formatter != null
                          ? <TextInputFormatter>[widget.formatter!]
                          : null,
                      style: widget.inputTextStyle,
                      onEditingComplete: () {
                        if (widget.enterPressed != null) {
                          FocusScope.of(context).requestFocus(FocusNode());
                          widget.enterPressed?.call();
                        }
                      },
                      onFieldSubmitted: (String value) {
                        if (widget.nextFocusNode != null) {
                          widget.nextFocusNode?.requestFocus();
                        }
                      },
                      obscureText: widget.isObscure ?? isPassword,
                      readOnly: widget.isReadOnly,
                      cursorColor: widget.cursorColor ??
                          Theme.of(context).colorScheme.cHintTextColor(context),
                      // initialValue: widget.initialValue,
                      maxLines: widget.maxLines,
                      maxLength: widget.maxLength,
                      textAlign: widget.textAlign ?? TextAlign.start,
                      decoration: InputDecoration(
                        icon: widget.leadingIcon,
                        isDense: true,
                        //IconButton(icon: Icon(Icons.favorite),onPressed: () {}),
                        border: widget.inputBorder ?? InputBorder.none,
                        hintText: widget.hintText,
                        hintStyle: widget.hintTextStyle ?? widget.labelStyle,
                        labelText: widget.labelText,
                        labelStyle: widget.labelStyle,
                        helperText: widget.helperText,
                        prefixText: widget.prefixText,
                        prefixStyle: widget.prefixStyle,
                        // prefixIconConstraints: BoxConstraints(minWidth: 10, minHeight: 28),
                        // prefixIcon: getPrefixIcon(context),
                        // suffixIcon: getSuffixIcon(context),
                        enabledBorder: widget.enabledBorder,
                        disabledBorder: widget.disabledBorder,
                        errorBorder: widget.errorBorder,
                        focusedBorder: widget.focusedBorder,
                        focusedErrorBorder: widget.focusedErrorBorder,
                        focusColor: widget.focusColor,
                      ),
                    ),
                  ),
                  getSuffixIcon(context) ?? Container(),
                ],
              ),
            ),
          ),
        ),
        widget.errorMessage == null
            ? const SizedBox.shrink()
            : widget.errorMessage!.isEmpty
                ? const SizedBox(
                    height: 30,
                  )
                : SizedBox(
                    height: 30,
                    child: PaddingWidget.applySymmetricPadding(
                      vertical: 5,
                      child: Text(
                        widget.errorMessage!,
                        style: captionOneNormalTextStyle(
                          context: context,
                          fontColor: widget.errorBorderColor ??
                              errorTextColor(context: context),
                        ),
                      ).textSupportsRTL(context),
                    ),
                  ),
      ],
    );
  }

  Widget? usePrefixIconWidget(BuildContext context) {
    return widget.prefixIcon;
  }

  Widget? getSuffixIcon(BuildContext context) {
    return widget.forceSuffixDirection
        ? (Directionality.of(context) != TextDirection.rtl
            ? (((widget.password && !widget.hideInternalObfuscator) ||
                    (widget.isObscure != null &&
                        !widget.hideInternalObfuscator))
                ? IconButton(
                    icon: Icon(
                      (widget.isObscure ?? !isPassword)
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: widget.themeColor,
                    ),
                    onPressed: () => setState(() {
                      isPassword = !isPassword;
                      widget.onObscureChange
                          ?.call(value: !(widget.isObscure ?? false));
                    }),
                  )
                : widget.suffixIcon)
            : usePrefixIconWidget(context))
        : (((widget.password && !widget.hideInternalObfuscator) ||
                (widget.isObscure != null && !widget.hideInternalObfuscator))
            ? IconButton(
                icon: Icon(
                  (widget.isObscure ?? !isPassword)
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: widget.themeColor,
                ),
                onPressed: () => setState(() {
                  isPassword = !isPassword;
                  widget.onObscureChange
                      ?.call(value: !(widget.isObscure ?? false));
                }),
              )
            : widget.errorMessage != null
                ? widget.errorMessage != ""
                    ? Icon(
                        widget.errorIcon ?? Icons.error_outline,
                        color: widget.errorBorderColor ??
                            errorTextColor(context: context),
                        size: 16,
                      )
                    : widget.suffixIcon
                : widget.suffixIcon);
  }

  Widget? getPrefixIcon(BuildContext context) {
    return widget.forceSuffixDirection
        ? (Directionality.of(context) == TextDirection.rtl
            ? (((widget.password && !widget.hideInternalObfuscator) ||
                    (widget.isObscure != null &&
                        !widget.hideInternalObfuscator))
                ? IconButton(
                    icon: Icon(
                      (widget.isObscure ?? !isPassword)
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: widget.themeColor,
                    ),
                    onPressed: () => setState(() {
                      isPassword = !isPassword;
                      widget.onObscureChange
                          ?.call(value: !(widget.isObscure ?? false));
                    }),
                  )
                : widget.suffixIcon)
            : usePrefixIconWidget(context))
        : usePrefixIconWidget(context);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>("isPassword", isPassword));
  }
}
