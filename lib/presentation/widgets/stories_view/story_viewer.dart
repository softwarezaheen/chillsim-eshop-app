import "package:esim_open_source/presentation/widgets/padding_widget.dart";
import "package:esim_open_source/presentation/widgets/stories_view/story_item.dart";
import "package:esim_open_source/presentation/widgets/stories_view/story_viewer_model.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:stacked/stacked.dart";

//ignore: must_be_immutable
class StoryViewer extends StatelessWidget {
  StoryViewer({
    required this.storyViewerArgs,
    super.key,
  });

  final StoryViewerArgs storyViewerArgs;

  double _dragStartY = 0;
  bool _isHolding = false;
  bool _isDraggingDown = false;

  static const String routeName = "StoryView";

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<StoryViewerViewModel>.reactive(
      viewModelBuilder: () => StoryViewerViewModel(
        stories: storyViewerArgs.stories,
        autoClose: storyViewerArgs.autoClose,
        onComplete: storyViewerArgs.onComplete,
      ),
      onViewModelReady: (StoryViewerViewModel viewModel) =>
          viewModel.onViewModelReady(),
      onDispose: (StoryViewerViewModel viewModel) => viewModel.onDispose(),
      builder: (
        BuildContext context,
        StoryViewerViewModel viewModel,
        Widget? staticChild,
      ) =>
          storyView(context, viewModel),
    );
  }

  Widget storyView(
    BuildContext context,
    StoryViewerViewModel viewModel,
  ) =>
      Scaffold(
        body: GestureDetector(
          onTapDown: (TapDownDetails details) async {
            await Future<void>.delayed(const Duration(milliseconds: 400),
                () async {
              if (!_isHolding) {
                if (context.mounted) {
                  await viewModel.onTapDown(context, details);
                }
              }
            });
          },
          onLongPressStart: (_) {
            _isHolding = true;
            viewModel.pauseStory();
          },
          onLongPressEnd: (_) {
            _isHolding = false;
            viewModel.resumeStory();
          },
          onVerticalDragStart: (DragStartDetails details) {
            _dragStartY =
                details.localPosition.dy; // Store the starting Y position
            _isDraggingDown = false;
          },
          onVerticalDragUpdate: (DragUpdateDetails details) {
            if (details.localPosition.dy > _dragStartY) {
              _isDraggingDown = true;
            }
          },
          onVerticalDragEnd: (DragEndDetails details) {
            if (_isDraggingDown && details.primaryVelocity! > 0) {
              // If the drag was downward and the velocity is positive (downward drag)
              viewModel.closeView();
            }
          },
          child: Stack(
            children: <Widget>[
              PageView.builder(
                itemCount: viewModel.stories.length,
                controller: viewModel.pageController,
                onPageChanged: viewModel.onStoryChanged,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) =>
                    viewModel.stories[index].content,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: viewModel.stories[viewModel.currentIndex].buttons,
              ),
              SafeArea(
                child: PaddingWidget.applyPadding(
                  top: 20,
                  start: 10,
                  end: 10,
                  child: Row(
                    children: List<Widget>.generate(viewModel.stories.length,
                        (int index) {
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: LinearProgressIndicator(
                            value: index < viewModel.currentIndex
                                ? 1
                                : index == viewModel.currentIndex
                                    ? viewModel.progress
                                    : 0,
                            backgroundColor:
                                storyViewerArgs.indicatorBackgroundColor,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              storyViewerArgs.indicatorColor,
                            ),
                            borderRadius: BorderRadius.circular(
                              storyViewerArgs.indicatorBorderRadius,
                            ),
                            minHeight: storyViewerArgs.indicatorHeight,
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);

    properties.add(
      DiagnosticsProperty<StoryViewerArgs>(
        "storyViewerArgs",
        storyViewerArgs,
      ),
    );
  }
}
