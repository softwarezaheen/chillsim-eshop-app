enum UserGuideViewType {
  ios,
  android;

  String get titleHeader {
    switch (this) {
      case UserGuideViewType.ios:
        return "iOS";
      case UserGuideViewType.android:
        return "Android";
    }
  }
}
