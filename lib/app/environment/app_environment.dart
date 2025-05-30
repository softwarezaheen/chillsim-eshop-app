import "dart:developer";

import "package:esim_open_source/app/environment/app_environment_helper.dart";
import "package:esim_open_source/app/environment/envs/env_open_source_dev.dart";
import "package:esim_open_source/app/environment/envs/env_open_source_release.dart";
import "package:esim_open_source/app/environment/envs/env_open_source_staging.dart";
import "package:flutter/services.dart";

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
  static late Environment _environment;

  static Environment get environment => _environment;

  static late AppEnvironmentHelper appEnvironmentHelper;

  static void setupEnvironment() {
    String currentFlavor = appFlavor?.toLowerCase() ?? "";

    log("current flavor is $currentFlavor");

    appEnvironmentHelper = Environment.getAppEnvironmentHelper();
  }
}
