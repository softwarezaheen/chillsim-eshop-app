import "package:easy_localization/easy_localization.dart" as localization;
import "package:esim_open_source/presentation/enums/language_enum.dart";
import "package:flutter/material.dart";

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
    ).hasMatch(this);
  }
}

extension IndexedIterable<E> on Iterable<E> {
  Iterable<T> mapIndexed<T>(T Function(E e, int i) f) {
    int i = 0;
    return map((dynamic e) => f(e, i++));
  }
}

extension CompactMap<K, V> on Map<K, V> {
  Map<K2, V2> compactMap<K2, V2>(
    MapEntry<K2, V2>? Function(MapEntry<K, V>) f,
  ) {
    final Map<K2, V2> result = <K2, V2>{};
    for (final MapEntry<K, V> entry in entries) {
      final MapEntry<K2, V2>? newEntry = f(entry);
      if (newEntry != null) {
        result[newEntry.key] = newEntry.value;
      }
    }
    return result;
  }
}

extension RTLExtension on Widget {
  Widget imageSupportsRTL(BuildContext context) {
    final String langCode =
        localization.EasyLocalization.of(context)?.locale.languageCode ?? "en";

    final bool isRTL = LanguageEnum.fromCode(langCode).isRTL;

    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()..scale(isRTL ? -1.0 : 1.0, 1),
      child: this,
    );
  }

  Widget textSupportsRTL(BuildContext context) {
    final String langCode =
        localization.EasyLocalization.of(context)?.locale.languageCode ?? "en";

    final bool isRTL = LanguageEnum.fromCode(langCode).isRTL;

    return Align(
      alignment: isRTL ? Alignment.centerRight : Alignment.centerLeft,
      child: this,
    );
  }
}
