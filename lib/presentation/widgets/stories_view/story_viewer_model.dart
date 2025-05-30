import "dart:async";
import "dart:developer";

import "package:esim_open_source/presentation/helpers/view_state_utils.dart";
import "package:esim_open_source/presentation/views/base/base_model.dart";
import "package:esim_open_source/presentation/widgets/stories_view/story_item.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";

class StoryViewerViewModel extends BaseModel {
  StoryViewerViewModel({
    required this.stories,
    required this.autoClose,
    required this.onComplete,
  });

  Timer? _timer;
  double progress = 0;
  int currentIndex = 0;
  DateTime? _startTime;
  bool _isDisposed = false;
  bool _hasCompleted = false;
  Duration _elapsed = Duration.zero;
  Duration _elapsedBeforePause = Duration.zero;
  final PageController pageController = PageController();

  final bool autoClose;
  final Function()? onComplete;
  final List<StoryItem> stories;

  @override
  void onViewModelReady() {
    super.onViewModelReady();
    _startTimer();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.light,
    );
  }

  @override
  void onDispose() {
    super.onDispose();
    _isDisposed = true;
    _timer?.cancel();
    pageController.dispose();
    setDefaultStatusBarColor();
  }

  void closeView() {
    navigationService.back();
  }

  //Page controller
  void onStoryChanged(int newIndex) {
    currentIndex = newIndex;
    notifyListeners();
  }

  //Timer function
  void _startTimer() {
    _timer?.cancel();
    _startTime = DateTime.now();

    const Duration tick = Duration(milliseconds: 50);
    _timer = Timer.periodic(tick, (Timer timer) async {
      if (_isDisposed) {
        timer.cancel();
        return;
      }

      final DateTime now = DateTime.now();
      final Duration totalElapsed =
          _elapsedBeforePause + now.difference(_startTime!);
      final Duration totalDuration = stories[currentIndex].duration;

      _elapsed = totalElapsed;
      progress = totalElapsed.inMilliseconds / totalDuration.inMilliseconds;

      if (progress >= 1) {
        _elapsedBeforePause = Duration.zero;
        _nextStory();
      }

      notifyListeners();
    });
  }

  //Stories function
  void pauseStory() {
    _timer?.cancel();
    final DateTime now = DateTime.now();
    if (_startTime != null) {
      _elapsedBeforePause += now.difference(_startTime!);
    }
  }

  void resumeStory() {
    _timer?.cancel(); // Cancel any existing timer

    // Reset _startTime so it continues smoothly
    _startTime = DateTime.now().subtract(_elapsed);

    const Duration tick = Duration(milliseconds: 50);
    _timer = Timer.periodic(tick, (Timer timer) async {
      if (_isDisposed) {
        timer.cancel();
        return;
      }

      final DateTime now = DateTime.now();
      final Duration totalDuration = stories[currentIndex].duration;
      final Duration newElapsed = now.difference(_startTime!);
      final double newProgress =
          newElapsed.inMilliseconds / totalDuration.inMilliseconds;

      if (newProgress >= 1) {
        _timer?.cancel();
        _nextStory();
      } else {
        _elapsed = newElapsed;
        progress = newProgress;
        notifyListeners();
      }
    });
  }

  Future<void> _nextStory() async {
    if (_isDisposed || _hasCompleted) {
      return;
    }

    if (currentIndex < stories.length - 1) {
      _advanceStory();
    } else {
      _hasCompleted = true;

      onComplete?.call();

      if (autoClose) {
        closeView();
      }
    }
  }

  Future<void> _advanceStory() async {
    if (currentIndex >= stories.length - 1) {
      return;
    }

    currentIndex++;
    _elapsed = Duration.zero;
    progress = 0;
    _elapsedBeforePause = Duration.zero;
    _startTime = DateTime.now(); // This is fine because _startTimer uses it

    if (stories[currentIndex].useSplitTransition) {
      pageController.animateToPage(
        currentIndex,
        duration: const Duration(milliseconds: 500),
        curve: Curves.linear,
      );
    } else {
      pageController.jumpToPage(currentIndex);
    }

    _startTimer();
    notifyListeners();
  }

  Future<void> _goToPreviousOrRestart() async {
    if (currentIndex == 0) {
      _restartStory();
    } else {
      currentIndex--;
      _elapsed = Duration.zero;
      progress = 0;
      _elapsedBeforePause = Duration.zero;

      _startTime = DateTime.now(); // This is fine because _startTimer uses it
      _hasCompleted = false;

      if (stories[currentIndex + 1].useSplitTransition) {
        pageController.animateToPage(
          currentIndex,
          duration: const Duration(milliseconds: 500),
          curve: Curves.linear,
        );
      } else {
        pageController.jumpToPage(currentIndex);
      }

      _startTimer();
      notifyListeners();
    }
  }

  void _restartStory() {
    _elapsed = Duration.zero;
    progress = 0;
    _startTimer();
    notifyListeners();
  }

  //Gestures
  Future<void> onTapDown(
    BuildContext context,
    TapDownDetails details,
  ) async {
    try {
      final double width = MediaQuery.of(context).size.width;
      final double dx = details.globalPosition.dx;

      if (dx < width / 3) {
        _goToPreviousOrRestart();
      } else {
        _nextStory();
      }
    } on Object catch (exception) {
      log("Exception with message: $exception");
    }
  }
}
