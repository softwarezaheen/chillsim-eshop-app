import "dart:developer";

import "package:esim_open_source/app/environment/app_environment_helper.dart";
import "package:esim_open_source/app/environment/envs/env_open_source_dev.dart";
import "package:esim_open_source/app/environment/envs/env_open_source_release.dart";
import "package:esim_open_source/app/environment/envs/env_open_source_staging.dart";
import "package:flutter/services.dart";
import "package:package_info_plus/package_info_plus.dart";

enum Environment {
  openSourceDev,
  openSourceStaging,
  openSourceProd;

  static Environment get currentEnvironment {
    String currentFlavor = appFlavor?.toLowerCase() ?? "";

    log("current flavor is $currentFlavor");

    if (currentFlavor == Environment.openSourceDev.name.toLowerCase()) {
      return Environment.openSourceDev;
    } else if (currentFlavor ==
        Environment.openSourceStaging.name.toLowerCase()) {
      return Environment.openSourceStaging;
    } else {
      return Environment.openSourceProd;
    }
  }

  static bool get isProdEnv {
    return currentEnvironment == Environment.openSourceProd;
    // ||
    // currentEnvironment == Environment.openSourceProd ||
    // currentEnvironment == Environment.openSourceProd;
  }

  static AppEnvironmentHelper getAppEnvironmentHelper() {
    switch (currentEnvironment) {
      case Environment.openSourceDev:
        return openSourceDebugEnvInstance;
      case Environment.openSourceStaging:
        return openSourceStagingEnvInstance;
      case Environment.openSourceProd:
        return openSourceProdEnvInstance;
    }
  }
}

abstract class AppEnvironment {
  static late bool isFromAppClip;

  static late Environment _environment;

  static Environment get environment => _environment;

  static late AppEnvironmentHelper appEnvironmentHelper;

  static Future<void> setupEnvironment() async {
    String currentFlavor = appFlavor?.toLowerCase() ?? "";

    log("current flavor is $currentFlavor");

    appEnvironmentHelper = Environment.getAppEnvironmentHelper();
    isFromAppClip = await isAppClip();
  }

  static Future<bool> isAppClip() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    log("Package Name: ${info.packageName}");

    if (info.packageName.contains(".Clip")) {
      log("Likely running as App Clip");
      return true;
    } else {
      log("Running as full app");
      return false;
    }
  }
}
