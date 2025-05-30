import "package:esim_open_source/presentation/reactive_service/bundles_data_service.dart";
import "package:esim_open_source/presentation/reactive_service/user_authentication_service.dart";
import "package:esim_open_source/presentation/reactive_service/user_service.dart";
import "package:stacked/stacked_annotations.dart";

@StackedApp(
  routes: <StackedRoute<dynamic>>[],
  dependencies: <DependencyRegistration>[
    LazySingleton<UserService>(
      classType: UserService,
    ),
    LazySingleton<UserAuthenticationService>(
      classType: UserAuthenticationService,
    ),
    LazySingleton<BundlesDataService>(
      classType: BundlesDataService,
    ),
  ],
)
class AppSetup {}
