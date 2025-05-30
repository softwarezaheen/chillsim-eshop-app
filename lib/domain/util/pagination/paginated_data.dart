import "dart:developer";

import "package:stacked/stacked.dart";

class PaginationService<T> with ListenableServiceMixin {
  final ReactiveValue<PaginatedData<T>?> _notifier =
      ReactiveValue<PaginatedData<T>?>(null);
  PaginatedData<T> get notifier => _notifier.value ?? PaginatedData<T>();

  void changeValue({
    required PaginatedData<T> paginatedData,
  }) {
    _notifier.value = paginatedData;
    log("PaginationService, notify");
    notifyListeners();
  }
}

class PaginatedData<T> {
  PaginatedData({
    this.items = const <Never>[],
    this.hasMore = true,
    this.currentPage = 1,
    this.isLoading = false,
    this.error,
  });

  List<T> items;
  bool hasMore;
  int currentPage;
  bool isLoading;
  String? error;

  PaginatedData<T> copyWith({
    List<T>? items,
    bool? hasMore,
    int? currentPage,
    bool? isLoading,
    String? error,
  }) {
    return PaginatedData<T>(
      items: items ?? this.items,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  String toString() {
    return "PaginatedData{items length: ${items.length}, hasMore: $hasMore, currentPage: $currentPage, isLoading: $isLoading, error: $error}";
  }
}
