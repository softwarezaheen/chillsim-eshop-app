import "dart:developer";

import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";

class DateTimeUtils {
  static const String ddMmYyyy = "dd/MM/yyyy";

  static String getRelativeTime({String? dateString}) {
    if (dateString == null || dateString.isEmpty) {
      return "";
    }

    DateTime inputDate = DateTime.parse(dateString);
    DateTime now = DateTime.now();
    Duration difference = now.difference(inputDate);

    if (difference.inSeconds < 60) {
      return "${difference.inSeconds} ${difference.inSeconds == 1 ? LocaleKeys.second.tr() : LocaleKeys.seconds.tr()} ${LocaleKeys.ago.tr()}";
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes} ${difference.inMinutes == 1 ? LocaleKeys.minute.tr() : LocaleKeys.minutes.tr()} ${LocaleKeys.ago.tr()}";
    } else if (difference.inHours < 24) {
      return "${difference.inHours} ${difference.inHours == 1 ? LocaleKeys.hour.tr() : LocaleKeys.hours.tr()} ${LocaleKeys.ago.tr()}";
    } else if (difference.inDays == 1) {
      return LocaleKeys.yesterday.tr();
    } else if (difference.inDays < 7) {
      return "${difference.inDays} ${LocaleKeys.days.tr()} ${LocaleKeys.ago.tr()}";
    } else if (difference.inDays <= 7) {
      return LocaleKeys.one_week_ago.tr();
    } else {
      return DateFormat("yyyy-MM-dd HH:mm:ss").format(inputDate);
    }
  }

  static String getBundleDate({required DateTime date}) {
    return "${date.day}/${date.month}/${date.year}";
  }

  static String formatTimestampToDate({
    required int timestamp,
    required String format,
  }) {
    try {
      log("formatTimestampToDate timestamp: $timestamp");
      final DateTime dateTime =
          DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
      final DateFormat formatter = DateFormat(format);
      log("formatTimestampToDate return: ${formatter.format(dateTime)}");
      return formatter.format(dateTime);
    } on Error catch (e) {
      log("formatTimestampToDate error: $e");

      return "";
    }
  }
}
