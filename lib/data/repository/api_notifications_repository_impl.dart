import "dart:async";

import "package:esim_open_source/data/remote/responses/empty_response.dart";
import "package:esim_open_source/domain/data/api_notifications.dart";
import "package:esim_open_source/domain/repository/api_notifications_repository.dart";
import "package:esim_open_source/domain/util/resource.dart";

class ApiNotificationsRepositoryImpl implements ApiNotificationsRepository {
  ApiNotificationsRepositoryImpl(this.apiNotifications);
  final APINotifications apiNotifications;

  @override
  FutureOr<Resource<EmptyResponse?>> getConsumptionLimit() {
    return responseToResource(
      apiNotifications.getConsumptionLimit(),
    );
  }
}
