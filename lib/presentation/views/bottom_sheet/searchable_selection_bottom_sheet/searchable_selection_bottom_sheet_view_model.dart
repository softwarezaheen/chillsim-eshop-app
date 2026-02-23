import "package:esim_open_source/presentation/views/base/base_model.dart";
import "package:flutter/material.dart";
import "package:stacked_services/stacked_services.dart";

class SearchableSelectionBottomSheetViewModel<T> extends BaseModel {
  SearchableSelectionBottomSheetViewModel({
    required this.items,
    required this.displayTextExtractor,
    required this.completer,
    this.currentValue,
  });

  final List<T> items;
  final String Function(T item) displayTextExtractor;
  final T? currentValue;
  final Function(SheetResponse<T>) completer;

  final TextEditingController searchController = TextEditingController();
  List<T> _filteredItems = <T>[];
  
  List<T> get filteredItems => _filteredItems;

  @override
  Future<void> onViewModelReady() async {
    super.onViewModelReady();
    _filteredItems = items;
    searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final String query = searchController.text.toLowerCase();
    if (query.isEmpty) {
      _filteredItems = items;
    } else {
      _filteredItems = items
          .where((T item) => displayTextExtractor(item).toLowerCase().contains(query))
          .toList();
    }
    notifyListeners();
  }

  void onItemSelected(T item) {
    completer(
      SheetResponse<T>(
        confirmed: true,
        data: item,
      ),
    );
  }

  void onCloseClick() {
    completer(SheetResponse<T>());
  }

  @override
  void onDispose() {
    searchController
      ..removeListener(_onSearchChanged)
      ..dispose();
    super.onDispose();
  }
}
