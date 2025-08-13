// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedLocatorGenerator
// **************************************************************************

// ignore_for_file: type=lint

import "package:esim_open_source/presentation/reactive_service/bundles_data_service.dart";
import "package:esim_open_source/presentation/reactive_service/user_authentication_service.dart";
import "package:esim_open_source/presentation/reactive_service/user_service.dart";
import "package:stacked_shared/stacked_shared.dart";

final StackedLocator locator = StackedLocator.instance;

Future<void> setupLocator({
  String? environment,
  EnvironmentFilter? environmentFilter,
}) async {
// Register environments
  locator.registerEnvironment(
    environment: environment,
    environmentFilter: environmentFilter,
  );

// Register dependencies
  locator.registerLazySingleton(UserService.new);
  locator.registerLazySingleton(UserAuthenticationService.new);
  locator.registerLazySingleton(BundlesDataService.new);
}
