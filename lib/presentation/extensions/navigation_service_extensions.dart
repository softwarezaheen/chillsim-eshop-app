import "package:stacked_services/stacked_services.dart";

class NavigationServiceRoute {
  NavigationServiceRoute({
    required this.routeName,
    this.arguments,
  });

  final String routeName;
  dynamic arguments;
}

extension NavigationServiceExtensions on NavigationService {
  Future<void> clearStackAndNavigate(
    List<NavigationServiceRoute> routes,
  ) async {
    if (routes.isEmpty) {
      return;
    }

    clearStackAndShow(routes.first.routeName);

    // Future<void>.delayed(Duration.zero, () {
    _navigateNext(1, routes);
    //});
  }

  Future<void> _navigateNext(
    int index,
    List<NavigationServiceRoute> routes,
  ) async {
    if (index < routes.length) {
      navigateTo(routes[index].routeName);
      _navigateNext(index + 1, routes);
    }
  }

  Future<void> clearStackAndNavigateWithArgs(
    List<NavigationServiceRoute> routes,
  ) async {
    if (routes.isEmpty) {
      return;
    }

    clearStackAndShow(
      routes.first.routeName,
      arguments: routes.first.arguments,
    );
    _navigateNextWithArgs(1, routes);
  }

  Future<void> _navigateNextWithArgs(
    int index,
    List<NavigationServiceRoute> routes,
  ) async {
    if (index < routes.length) {
      navigateTo(
        routes[index].routeName,
        arguments: routes[index].arguments,
      );

      _navigateNextWithArgs(index + 1, routes);
    }
  }
}
