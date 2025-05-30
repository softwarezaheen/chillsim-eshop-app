import "dart:async";

import "package:esim_open_source/domain/util/pagination/paginated_data.dart";
import "package:esim_open_source/domain/util/pagination/pagination_state_mixin.dart";

abstract class UseCase<Type, Params> {
  FutureOr<Type> execute(Params params);
}

abstract class PaginatedUseCase<T, Params> with PaginationState<T> {
  Future<void> loadNextPage(Params params);
  Future<void> refreshData(Params params);
  abstract PaginationService<T> paginationService;
}

// Parameter classes
class NoParams {}
