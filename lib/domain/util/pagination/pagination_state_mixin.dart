import "package:esim_open_source/domain/util/pagination/paginated_data.dart";
import "package:esim_open_source/domain/util/pagination/pagination_params.dart";
import "package:flutter/foundation.dart";

mixin PaginationState<T> {
  int defaultPageSize = 10;

  PaginatedData<T> _state = PaginatedData<T>(
    items: <T>[],
  );

  PaginatedData<T> get state => _state;

  @protected
  set state(PaginatedData<T> newState) {
    _state = newState;
  }

  void dispose() {
    _state = PaginatedData<T>(
      items: <T>[],
    );
  }

  @protected
  PaginatedData<T> paginateList(
    List<T> fullList,
    PaginationParams params,
  ) {
    bool hasMore = !(defaultPageSize > (fullList.length));

    return state = _state.copyWith(
      items: <T>[..._state.items, ...fullList],
      hasMore: hasMore,
      currentPage: params.page + 1,
    );
  }

  void refresh() {
    state = PaginatedData<T>(
      items: <T>[],
    );
  }
}
