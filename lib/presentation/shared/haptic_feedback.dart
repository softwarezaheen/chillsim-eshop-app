import "package:flutter_vibrate/flutter_vibrate.dart";

enum HapticFeedbackType {
  mainButtonTapped,
  secondaryButtonTapped,
  tabBarSelectionChange,
  pagerSelectionChange,
  validationError,
  apiError,
  apiSuccess,
  majorEvents;
}

void playHapticFeedback(HapticFeedbackType hapticFeedbackType) {
  switch (hapticFeedbackType) {
    case HapticFeedbackType.mainButtonTapped:
      FeedbackType type = FeedbackType.selection;
      Vibrate.feedback(type);
    case HapticFeedbackType.secondaryButtonTapped:
      FeedbackType type = FeedbackType.selection;
      Vibrate.feedback(type);
    case HapticFeedbackType.tabBarSelectionChange:
      FeedbackType type = FeedbackType.medium;
      Vibrate.feedback(type);
    case HapticFeedbackType.pagerSelectionChange:
      FeedbackType type = FeedbackType.light;
      Vibrate.feedback(type);
    case HapticFeedbackType.validationError:
      FeedbackType type = FeedbackType.impact;
      Vibrate.feedback(type);
    case HapticFeedbackType.apiError:
      FeedbackType type = FeedbackType.impact;
      Vibrate.feedback(type);
    case HapticFeedbackType.apiSuccess:
      FeedbackType type = FeedbackType.selection;
      Vibrate.feedback(type);
    case HapticFeedbackType.majorEvents:
      FeedbackType type = FeedbackType.heavy;
      Vibrate.feedback(type);
  }
}
