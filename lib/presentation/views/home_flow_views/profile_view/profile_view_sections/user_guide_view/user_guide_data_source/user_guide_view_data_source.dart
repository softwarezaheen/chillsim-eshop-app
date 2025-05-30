abstract interface class UserGuideViewDataSource {
  String get title;
  String get imageName;
  String get description;
  String get stepNumberLabel;
  bool get isImageGIF;
  String get fullImagePath;

  bool isPreviousEnabled();
  bool isNextEnabled();

  UserGuideViewDataSource nextStepTapped();
  UserGuideViewDataSource previousStepTapped();
}
