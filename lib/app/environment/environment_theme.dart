enum EnvironmentTheme {
  openSource;

  String get directoryName {
    switch (this) {
      case EnvironmentTheme.openSource:
        return "open_source";
    }
  }
}
