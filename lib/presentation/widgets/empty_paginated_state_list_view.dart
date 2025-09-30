import "dart:async";
import "dart:developer";

import "package:esim_open_source/domain/util/pagination/paginated_data.dart";
import "package:esim_open_source/presentation/helpers/view_state_utils.dart";
import "package:esim_open_source/presentation/widgets/empty_state_widget.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

typedef IndexedWidgetBuilder = Widget Function(BuildContext, int);

class EmptyPaginatedStateListView<T> extends StatefulWidget {
  const EmptyPaginatedStateListView({
    required this.emptyStateWidget,
    required this.paginationService,
    required this.builder,
    required this.onRefresh,
    required this.onLoadItems,
    required this.separatorBuilder,
    this.loadingWidget,
    super.key,
  });
  final Future<void> Function() onRefresh;
  final Future<void> Function() onLoadItems;
  final Function(T item) builder;
  final EmptyStateWidget emptyStateWidget;
  final IndexedWidgetBuilder separatorBuilder;
  final PaginationService<T> paginationService;
  final Widget? loadingWidget;

  @override
  State<EmptyPaginatedStateListView<T>> createState() =>
      _EmptyPaginatedStateListViewState<T>();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        ObjectFlagProperty<Future<void> Function()>.has("onRefresh", onRefresh),
      )
      ..add(
        ObjectFlagProperty<Future<void> Function()>.has(
          "onLoadItems",
          onLoadItems,
        ),
      )
      ..add(ObjectFlagProperty<Function(T item)>.has("builder", builder))
      ..add(
        ObjectFlagProperty<IndexedWidgetBuilder>.has(
          "separatorBuilder",
          separatorBuilder,
        ),
      )
      ..add(
        DiagnosticsProperty<PaginationService<T>>(
          "paginationService",
          paginationService,
        ),
      );
  }
}

class _EmptyPaginatedStateListViewState<T>
    extends State<EmptyPaginatedStateListView<T>> {
  VoidCallback? _listener;

  @override
  void initState() {
    super.initState();
    
    bool getDataFirstTime = widget.paginationService.notifier.items.isEmpty &&
        !widget.paginationService.notifier.isLoading &&
        widget.paginationService.notifier.currentPage == 1;

    if (getDataFirstTime) {
      unawaited(widget.onLoadItems());
    }

    log("EmptyPaginatedStateListView initState: start");
    
    // Store the listener so we can remove it later
    _listener = () {
      log(
        "EmptyPaginatedStateListView initState: start state: ${widget.paginationService.notifier}",
      );
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Check if widget is still mounted before calling setState
        if (mounted) {
          setState(() {
            // Update state safely
          });
        }
      });
    };
    
    widget.paginationService.addListener(_listener!);
  }

  @override
  void dispose() {
    // Remove listener safely
    if (_listener != null) {
      widget.paginationService.removeListener(_listener!);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log(
      "EmptyPaginatedStateListView: state: ${widget.paginationService.notifier}",
    );
    return widget.paginationService.notifier.items.isEmpty &&
            !widget.paginationService.notifier.isLoading
        ? RefreshIndicator(
            onRefresh: widget.onRefresh,
            child: Center(child: widget.emptyStateWidget),
          )
        : widget.paginationService.notifier.isLoading &&
                widget.paginationService.notifier.items.isEmpty
            ? widget.loadingWidget ??
                Center(
                  child: SizedBox(
                    width: 35,
                    height: 35,
                    child: getNativeIndicator(context),
                  ),
                )
            : RefreshIndicator(
                onRefresh: widget.onRefresh,
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: widget.paginationService.notifier.items.length +
                      (widget.paginationService.notifier.hasMore ? 1 : 0),
                  itemBuilder: (BuildContext context, int index) {
                    if (index ==
                            widget.paginationService.notifier.items.length &&
                        widget.paginationService.notifier.hasMore &&
                        !widget.paginationService.notifier.isLoading) {
                      // Trigger loading of next page
                      log("EmptyPaginatedStateListView load items");
                      unawaited(widget.onLoadItems());
                      // Return a loading indicator
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    if (index ==
                            widget.paginationService.notifier.items.length &&
                        widget.paginationService.notifier.hasMore &&
                        widget.paginationService.notifier.isLoading) {
                      // Trigger loading of next page
                      log("EmptyPaginatedStateListView load items");
                      unawaited(widget.onLoadItems());
                      // Return a loading indicator
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    T item = widget.paginationService.notifier.items[index];
                    return widget.builder(item);
                  },
                  separatorBuilder: widget.separatorBuilder,
                ),
              );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        ObjectFlagProperty<IndexedWidgetBuilder?>.has(
          "separatorBuilder",
          widget.separatorBuilder,
        ),
      )
      ..add(
        ObjectFlagProperty<Future<void> Function()>.has(
          "onRefresh",
          widget.onRefresh,
        ),
      )
      ..add(
        DiagnosticsProperty<PaginatedData<dynamic>>(
          "state",
          widget.paginationService.notifier,
        ),
      )
      ..add(
        ObjectFlagProperty<Future<void> Function()>.has(
          "onLoadItems",
          widget.onLoadItems,
        ),
      )
      ..add(
        ObjectFlagProperty<Function(T item)>.has("builder", widget.builder),
      );
  }
}
