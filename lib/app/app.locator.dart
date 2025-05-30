// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedLocatorGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs, implementation_imports, depend_on_referenced_packages

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
  locator..registerEnvironment(
      environment: environment, environmentFilter: environmentFilter,)

// Register dependencies
  ..registerLazySingleton(UserService.new)
  ..registerLazySingleton(UserAuthenticationService.new)
  ..registerLazySingleton(BundlesDataService.new);
}
