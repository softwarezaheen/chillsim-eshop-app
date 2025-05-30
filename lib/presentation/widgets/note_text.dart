import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

class NoteText extends StatelessWidget {
  const NoteText(this.text, {this.textAlign, this.color, super.key});
  final String text;
  final TextAlign? textAlign;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: color ?? Colors.grey[600],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty("text", text))
      ..add(EnumProperty<TextAlign?>("textAlign", textAlign))
      ..add(ColorProperty("color", color));
  }
}
