import "dart:async";

abstract class PaginatedRepository<T> {
  FutureOr<void> getItems();
}
