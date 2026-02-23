import "dart:async";

import "package:esim_open_source/presentation/setup_bottom_sheet_ui.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/views/bottom_sheet/searchable_selection_bottom_sheet/searchable_selection_bottom_sheet_view.dart";
import "package:esim_open_source/presentation/views/bottom_sheet/searchable_selection_bottom_sheet/searchable_selection_bottom_sheet_view_model.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:stacked_services/stacked_services.dart";

/// A dropdown field that opens a searchable bottom sheet for selection
class SearchableDropdownField<T extends Object> extends StatelessWidget {
  const SearchableDropdownField({
    required this.labelText,
    required this.items,
    required this.onChanged,
    required this.displayTextExtractor,
    this.value,
    this.enabled = true,
    super.key,
  });

  final String labelText;
  final List<T> items;
  final T? value;
  final ValueChanged<T?> onChanged;
  final String Function(T item) displayTextExtractor;
  final bool enabled;

  String _getDisplayText() {
    if (value == null) {
      return "";
    }
    return displayTextExtractor(value!);
  }

  Future<void> _showSearchBottomSheet(BuildContext context) async {
    if (!enabled) {
      return;
    }

    // Use showModalBottomSheet directly to preserve type safety
    final SheetResponse<T>? result = await showModalBottomSheet<SheetResponse<T>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext sheetContext) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          builder: (BuildContext context, ScrollController scrollController) {
            return DecoratedBox(
              decoration: BoxDecoration(
                color: whiteBackGroundColor(context: context),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: SearchableSelectionBottomSheetViewContent<T>(
                title: labelText,
                items: items,
                displayTextExtractor: displayTextExtractor,
                currentValue: value,
              ),
            );
          },
        );
      },
    );

    if (result?.confirmed ?? false) {
      onChanged(result!.data);
    }
  }

  @override
  Widget build(BuildContext context) {
    final String displayText = _getDisplayText();
    final bool hasValue = displayText.isNotEmpty;
    
    return GestureDetector(
      onTap: enabled ? () => _showSearchBottomSheet(context) : null,
      child: Container(
        decoration: BoxDecoration(
          color: enabled
              ? whiteBackGroundColor(context: context)
              : Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: enabled
                ? secondaryTextColor(context: context).withValues(alpha: 0.3)
                : Colors.grey[300]!,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              labelText,
              style: captionOneNormalTextStyle(
                context: context,
                fontColor: secondaryTextColor(context: context),
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    hasValue ? displayText : "",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: enabled
                          ? Colors.black87
                          : Colors.grey[600],
                      fontFamily: Theme.of(context).textTheme.bodyLarge?.fontFamily,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: enabled
                      ? Colors.grey[700]
                      : Colors.grey[400],
                  size: 24,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties..add(StringProperty("labelText", labelText))
    ..add(IterableProperty<T>("items", items))
    ..add(DiagnosticsProperty<T?>("value", value))
    ..add(ObjectFlagProperty<ValueChanged<T?>>.has("onChanged", onChanged))
    ..add(ObjectFlagProperty<String Function(T item)>.has("displayTextExtractor", displayTextExtractor))
    ..add(DiagnosticsProperty<bool>("enabled", enabled));
  }
}

/// Content widget that maintains type safety
class SearchableSelectionBottomSheetViewContent<T> extends StatefulWidget {
  const SearchableSelectionBottomSheetViewContent({
    required this.title,
    required this.items,
    required this.displayTextExtractor,
    this.currentValue,
    super.key,
  });

  final String title;
  final List<T> items;
  final String Function(T item) displayTextExtractor;
  final T? currentValue;

  @override
  State<SearchableSelectionBottomSheetViewContent<T>> createState() =>
      _SearchableSelectionBottomSheetViewContentState<T>();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties..add(StringProperty("title", title))
    ..add(IterableProperty<T>("items", items))
    ..add(ObjectFlagProperty<String Function(T item)>.has("displayTextExtractor", displayTextExtractor))
    ..add(DiagnosticsProperty<T?>("currentValue", currentValue));
  }
}

class _SearchableSelectionBottomSheetViewContentState<T>
    extends State<SearchableSelectionBottomSheetViewContent<T>> {
  late SearchableSelectionBottomSheetViewModel<T> viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = SearchableSelectionBottomSheetViewModel<T>(
      items: widget.items,
      displayTextExtractor: widget.displayTextExtractor,
      completer: (SheetResponse<T> response) {
        Navigator.of(context).pop(response);
      },
      currentValue: widget.currentValue,
    );
    unawaited(viewModel.onViewModelReady());
  }

  @override
  void dispose() {
    viewModel.onDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SearchableSelectionBottomSheetView<T>(
      request: SheetRequest<SearchableSelectionSheetRequest<T>>(
        data: SearchableSelectionSheetRequest<T>(
          title: widget.title,
          items: widget.items,
          displayTextExtractor: widget.displayTextExtractor,
          currentValue: widget.currentValue,
        ),
      ),
      completer: viewModel.completer,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<SearchableSelectionBottomSheetViewModel<T>>("viewModel", viewModel));
  }
}
