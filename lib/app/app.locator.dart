// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedLocatorGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs, implementation_imports, depend_on_referenced_packages

import 'package:stacked_shared/stacked_shared.dart';

import '../presentation/reactive_service/bundles_data_service.dart';
import '../presentation/reactive_service/user_authentication_service.dart';
import '../presentation/reactive_service/user_service.dart';

final locator = StackedLocator.instance;

Future<void> setupLocator({
  String? environment,
  EnvironmentFilter? environmentFilter,
}) async {
// Register environments
  locator.registerEnvironment(
      environment: environment, environmentFilter: environmentFilter);

// Register dependencies
  locator.registerLazySingleton(() => UserService());
  locator.registerLazySingleton(() => UserAuthenticationService());
  locator.registerLazySingleton(() => BundlesDataService());
}
