// library flutter_otp_text_field; 1.1.3+2
import "dart:developer" as dev;
import "dart:io";
import "dart:math";

import "package:esim_open_source/presentation/utils/extensions.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";

typedef OnCodeEnteredCompletion = void Function(String value);
typedef OnCodeChanged = void Function(String value);
typedef HandleControllers = void Function(
  List<TextEditingController?> controllers,
);

// ignore: must_be_immutable
class OtpTextField extends StatefulWidget {
  OtpTextField({
    required this.initialCode,
    super.key,
    this.showCursor = true,
    this.numberOfFields = 4,
    this.fieldWidth = 40.0,
    this.fieldHeight,
    this.alignment,
    this.margin = const EdgeInsets.only(right: 8),
    this.textStyle,
    this.clearText = false,
    this.styles = const <TextStyle?>[],
    this.keyboardType = TextInputType.number,
    this.borderWidth = 2.0,
    this.cursorColor,
    this.disabledBorderColor = const Color(0xFFE7E7E7),
    this.enabledBorderColor = const Color(0xFFE7E7E7),
    this.borderColor = const Color(0xFFE7E7E7),
    this.focusedBorderColor = const Color(0xFF4F44FF),
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.handleControllers,
    this.onSubmit,
    this.obscureText = false,
    this.showFieldAsBox = false,
    this.enabled = true,
    this.autoFocus = false,
    this.hasCustomInputDecoration = false,
    this.filled = false,
    this.fillColor = const Color(0xFFFFFFFF),
    this.readOnly = false,
    this.decoration,
    this.onCodeChanged,
    this.borderRadius = const BorderRadius.all(Radius.circular(4)),
    this.inputFormatters,
    this.contentPadding,
  })  : assert(numberOfFields > 0),
        assert(
          styles.isNotEmpty ? styles.length == numberOfFields : styles.isEmpty,
        );
  final bool showCursor;
  final int numberOfFields;
  final double fieldWidth;
  final double? fieldHeight;
  final double borderWidth;
  final Alignment? alignment;
  final Color enabledBorderColor;
  final Color focusedBorderColor;
  final Color disabledBorderColor;
  final Color borderColor;
  final Color? cursorColor;
  final EdgeInsetsGeometry margin;
  final TextInputType keyboardType;
  final TextStyle? textStyle;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final OnCodeEnteredCompletion? onSubmit;
  final OnCodeEnteredCompletion? onCodeChanged;
  final HandleControllers? handleControllers;
  final bool obscureText;
  final bool showFieldAsBox;
  final bool enabled;
  final bool filled;
  final bool autoFocus;
  final bool readOnly;
  bool clearText;
  final bool hasCustomInputDecoration;
  final Color fillColor;
  final BorderRadius borderRadius;
  final InputDecoration? decoration;
  final List<TextStyle?> styles;
  final List<TextInputFormatter>? inputFormatters;
  final EdgeInsetsGeometry? contentPadding;
  final List<String> initialCode;

  Widget? generateTextFields;

  @override
  OtpTextFieldState createState() => OtpTextFieldState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<bool>("showCursor", showCursor))
      ..add(IntProperty("numberOfFields", numberOfFields))
      ..add(DoubleProperty("fieldWidth", fieldWidth))
      ..add(DoubleProperty("fieldHeight", fieldHeight))
      ..add(DoubleProperty("borderWidth", borderWidth))
      ..add(DiagnosticsProperty<Alignment?>("alignment", alignment))
      ..add(ColorProperty("enabledBorderColor", enabledBorderColor))
      ..add(ColorProperty("focusedBorderColor", focusedBorderColor))
      ..add(ColorProperty("disabledBorderColor", disabledBorderColor))
      ..add(ColorProperty("borderColor", borderColor))
      ..add(ColorProperty("cursorColor", cursorColor))
      ..add(DiagnosticsProperty<EdgeInsetsGeometry>("margin", margin))
      ..add(DiagnosticsProperty<TextInputType>("keyboardType", keyboardType))
      ..add(DiagnosticsProperty<TextStyle?>("textStyle", textStyle))
      ..add(
        EnumProperty<MainAxisAlignment>(
          "mainAxisAlignment",
          mainAxisAlignment,
        ),
      )
      ..add(
        EnumProperty<CrossAxisAlignment>(
          "crossAxisAlignment",
          crossAxisAlignment,
        ),
      )
      ..add(
        ObjectFlagProperty<OnCodeEnteredCompletion?>.has(
          "onSubmit",
          onSubmit,
        ),
      )
      ..add(
        ObjectFlagProperty<OnCodeEnteredCompletion?>.has(
          "onCodeChanged",
          onCodeChanged,
        ),
      )
      ..add(
        ObjectFlagProperty<HandleControllers?>.has(
          "handleControllers",
          handleControllers,
        ),
      )
      ..add(DiagnosticsProperty<bool>("obscureText", obscureText))
      ..add(DiagnosticsProperty<bool>("showFieldAsBox", showFieldAsBox))
      ..add(DiagnosticsProperty<bool>("enabled", enabled))
      ..add(DiagnosticsProperty<bool>("filled", filled))
      ..add(DiagnosticsProperty<bool>("autoFocus", autoFocus))
      ..add(DiagnosticsProperty<bool>("readOnly", readOnly))
      ..add(DiagnosticsProperty<bool>("clearText", clearText))
      ..add(
        DiagnosticsProperty<bool>(
          "hasCustomInputDecoration",
          hasCustomInputDecoration,
        ),
      )
      ..add(ColorProperty("fillColor", fillColor))
      ..add(DiagnosticsProperty<BorderRadius>("borderRadius", borderRadius))
      ..add(DiagnosticsProperty<InputDecoration?>("decoration", decoration))
      ..add(IterableProperty<TextStyle?>("styles", styles))
      ..add(
        IterableProperty<TextInputFormatter>(
          "inputFormatters",
          inputFormatters,
        ),
      )
      ..add(
        DiagnosticsProperty<EdgeInsetsGeometry?>(
          "contentPadding",
          contentPadding,
        ),
      )
      ..add(IterableProperty<String>("initialCode", initialCode));
  }
}

class OtpTextFieldState extends State<OtpTextField> {
  late List<String?> _verificationCode;
  late List<FocusNode?> _focusNodes;
  late List<TextEditingController?> _textControllers;

  @override
  void initState() {
    super.initState();

    _verificationCode = List<String?>.filled(widget.numberOfFields, null);
    _focusNodes = List<FocusNode?>.filled(widget.numberOfFields, null);

    _textControllers = List<TextEditingController?>.generate(
      widget.numberOfFields,
      (int index) => TextEditingController(
        text: widget.initialCode[index],
      ),
    );
    //     .filled(
    //   widget.numberOfFields,
    //   null,
    // );
  }

  @override
  void didUpdateWidget(covariant OtpTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.clearText != widget.clearText && widget.clearText) {
      for (TextEditingController? controller in _textControllers) {
        controller?.clear();
      }
      _verificationCode = List<String?>.filled(widget.numberOfFields, null);
      setState(() {
        widget.clearText = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    for (TextEditingController? controller in _textControllers) {
      controller?.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listens for backspace key event when textField is empty. Moves to previous node if possible.
    return KeyboardListener(
      focusNode: FocusNode(),
      onKeyEvent: (KeyEvent value) async {
        if (value.logicalKey.keyLabel == "Backspace" && value is KeyUpEvent) {
          await changeFocusToPreviousNodeWhenTapBackspace();
        }
      },
      child: generateTextFields(context),
    );
  }

  Widget _buildTextField({
    required BuildContext context,
    required int index,
    TextStyle? style,
  }) {
    return Container(
      width: widget.fieldWidth,
      height: widget.fieldHeight,
      alignment: widget.alignment,
      margin: widget.margin,
      child: TextFormField(
        showCursor: widget.showCursor,
        keyboardType: widget.keyboardType,
        textAlign: TextAlign.center,
        // maxLength: 1,
        readOnly: widget.readOnly,
        style: style ?? widget.textStyle,
        autofocus: widget.autoFocus,
        cursorColor: widget.cursorColor,
        controller: _textControllers[index],
        focusNode: _focusNodes[index],
        enabled: widget.enabled,
        inputFormatters: widget.inputFormatters,
        decoration: widget.hasCustomInputDecoration
            ? widget.decoration
            : InputDecoration(
                counterText: "",
                filled: widget.filled,
                fillColor: widget.fillColor,
                focusedBorder: widget.showFieldAsBox
                    ? outlineBorder(widget.focusedBorderColor)
                    : underlineInputBorder(widget.focusedBorderColor),
                enabledBorder: widget.showFieldAsBox
                    ? outlineBorder(widget.enabledBorderColor)
                    : underlineInputBorder(widget.enabledBorderColor),
                disabledBorder: widget.showFieldAsBox
                    ? outlineBorder(widget.disabledBorderColor)
                    : underlineInputBorder(widget.disabledBorderColor),
                border: widget.showFieldAsBox
                    ? outlineBorder(widget.borderColor)
                    : underlineInputBorder(widget.borderColor),
                contentPadding: widget.contentPadding,
              ),

        obscureText: widget.obscureText,
        onChanged: (String value1) {
          String value2 = value1;
          if (value1.length > 1) {
            value2 = _verificationCode[index] == value1.characters.first
                ? value1.characters.last
                : value1.characters.first;
          }
          //save entered value in a list
          String value = value2.keepOnlyDigits();
          _verificationCode[index] = value;
          onCodeChanged(verificationCode: value);
          changeFocusToNextNodeWhenValueIsEntered(
            value: value,
            indexOfTextField: index,
          );
          if (value2 == value) {
            changeFocusToPreviousNodeWhenValueIsRemoved(
              value: value,
              indexOfTextField: index,
            );
          }
          onSubmit(verificationCode: _verificationCode);
          if (_textControllers[index]?.text != value && value1.isNotEmpty) {
            _textControllers[index]?.text = value;
          }
        },
        contextMenuBuilder:
            (BuildContext context, EditableTextState editableTextState) {
          final List<ContextMenuButtonItem> buttonItems =
              editableTextState.contextMenuButtonItems;
          final ContextMenuButtonItem? old = buttonItems
              .where(
                (ContextMenuButtonItem e) =>
                    e.type == ContextMenuButtonType.paste,
              )
              .firstOrNull;
          if (old == null) {
            return AdaptiveTextSelectionToolbar.editableText(
              editableTextState: editableTextState,
            );
          }
          final ContextMenuButtonItem current = old.copyWith(
            onPressed: () async {
              final ClipboardData? data =
                  await Clipboard.getData(Clipboard.kTextPlain);
              if (data == null) {
                return;
              }
              handlePasteLogic(data.text?.keepOnlyDigits() ?? "");
              editableTextState.hideToolbar();
            },
          );
          buttonItems
            ..remove(old)
            ..add(current);
          return AdaptiveTextSelectionToolbar.buttonItems(
            anchors: editableTextState.contextMenuAnchors,
            buttonItems: buttonItems,
          );
        },
      ),
    );
  }

  OutlineInputBorder outlineBorder(Color color) {
    return OutlineInputBorder(
      borderSide: BorderSide(
        width: widget.borderWidth,
        color: color,
      ),
      borderRadius: widget.borderRadius,
    );
  }

  UnderlineInputBorder underlineInputBorder(Color color) {
    return UnderlineInputBorder(
      borderSide: BorderSide(
        color: color,
        width: widget.borderWidth,
      ),
    );
  }

  Widget generateTextFields(BuildContext context) {
    if (widget.generateTextFields != null) {
      return widget.generateTextFields!;
    }

    List<Widget> textFields =
        List<Widget>.generate(widget.numberOfFields, (int i) {
      addFocusNodeToEachTextField(index: i);
      addTextEditingControllerToEachTextField(index: i);

      if (widget.styles.isNotEmpty) {
        return _buildTextField(
          context: context,
          index: i,
          style: widget.styles[i],
        );
      }
      if (widget.handleControllers != null) {
        widget.handleControllers?.call(_textControllers);
      }
      return _buildTextField(context: context, index: i);
    });

    widget.generateTextFields = Row(
      mainAxisAlignment: widget.mainAxisAlignment,
      crossAxisAlignment: widget.crossAxisAlignment,
      children: textFields,
    );
    return widget.generateTextFields!;
  }

  void addFocusNodeToEachTextField({required int index}) {
    if (_focusNodes[index] == null) {
      _focusNodes[index] = FocusNode();

      if (Platform.isIOS) {
        _focusNodes[index]?.addListener(() {
          // Check if the node has lost focus
          if (!(_focusNodes[index]?.hasFocus ?? true)) {
            dev.log("Field $index lost focus");
            // Here you can add your logic for when focus is lost
          }

          // Check if the node gained focus
          if (_focusNodes[index]?.hasFocus ?? false) {
            dev.log("Field $index gained focus");
            if (_verificationCode[index] == null ||
                (_verificationCode[index]?.isEmpty ?? true)) {
              String newVal = " ";
              _verificationCode[index] = newVal;
              _textControllers[index]?.text = newVal;
            }
            // Here you can add your logic for when focus is gained
          }
        });
      }
    }
  }

  void addTextEditingControllerToEachTextField({required int index}) {
    if (_textControllers[index] == null) {
      _textControllers[index] = TextEditingController();
    }
  }

  void changeFocusToNextNodeWhenValueIsEntered({
    required String value,
    required int indexOfTextField,
  }) {
    //only change focus to the next textField if the value entered has a length greater than one
    if (value.isNotEmpty) {
      //if the textField in focus is not the last textField,
      // change focus to the next textField
      if (indexOfTextField + 1 != widget.numberOfFields) {
        //change focus to the next textField
        FocusScope.of(context).requestFocus(_focusNodes[indexOfTextField + 1]);
      } else {
        //if the textField in focus is the last textField, unFocus after text changed
        _focusNodes[indexOfTextField]?.unfocus();
      }
    }
  }

  // A flag to eliminate race condition between [changeFocusToPreviousNodeWhenValueIsRemoved] and [changeFocusToPreviousNodeWhenTapBackspace]
  bool _backspaceHandled = false;

  void changeFocusToPreviousNodeWhenValueIsRemoved({
    required String value,
    required int indexOfTextField,
  }) {
    // Race condition eliminator
    _backspaceHandled = true;
    Future<void>.delayed(
      const Duration(milliseconds: 200),
      () {
        _backspaceHandled = false;
      },
    );
    //only change focus to the previous textField if the value entered has a length zero
    if (value.isEmpty) {
      //if the textField in focus is not the first textField,
      // change focus to the previous textField
      if (indexOfTextField != 0) {
        //change focus to the next textField
        FocusScope.of(context).requestFocus(_focusNodes[indexOfTextField - 1]);
      }
    }
  }

  Future<void> changeFocusToPreviousNodeWhenTapBackspace() async {
    // Wait because this is running before [changeFocusToPreviousNodeWhenValueIsRemoved]
    await Future<void>.delayed(const Duration(milliseconds: 50));
    if (_backspaceHandled) {
      return;
    }
    try {
      final int index = _focusNodes
          .indexWhere((FocusNode? element) => element?.hasFocus ?? false);
      if (index > 0) {
        if (context.mounted) {
          // ignore: use_build_context_synchronously
          FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
        }
      }
    } on Exception catch (e) {
      dev.log("Cannot focus on the previous field $e");
    }
  }

  void onSubmit({required List<String?> verificationCode}) {
    if (verificationCode.every((String? code) => code != null && code != "")) {
      widget.onSubmit?.call(verificationCode.join());
    }
  }

  void onCodeChanged({required String verificationCode}) {
    widget.onCodeChanged?.call(verificationCode);
  }

  void handlePasteLogic(String newText) {
    int numberOfValues = min(newText.length, widget.numberOfFields);

    for (int index = 0; index < numberOfValues; index++) {
      _verificationCode[index] = newText.characters.elementAt(index);
      _textControllers[index]?.text = newText.characters.elementAt(index);
    }
    onSubmit(verificationCode: _verificationCode);
    FocusScope.of(context).unfocus();
    setState(() {});
  }
}
