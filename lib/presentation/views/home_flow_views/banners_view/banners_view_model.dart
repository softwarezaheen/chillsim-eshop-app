import "dart:async";

import "package:esim_open_source/app/environment/app_environment.dart";
import "package:esim_open_source/presentation/extensions/context_extension.dart";
import "package:esim_open_source/presentation/views/base/base_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/banners_view/banners_view_types.dart";
import "package:flutter/material.dart";

class BannersViewModel extends BaseModel {
  Timer? _timer;
  Timer? _buttonTimer;
  int _currentPage = 0;
  PageController bannersPageController = PageController(viewportFraction: 0.9);
  List<BannersViewTypes> banners = BannersViewTypes.values
      .where((element) {
        if (element == BannersViewTypes.bannersReferral) {
          return AppEnvironment.appEnvironmentHelper.enableReferral;
        }
        return true;
      })
      .toList();

  Color? _textColor;
  Color? _buttonColor;

  int get currentPage => _currentPage;

  Color? get textColor => _textColor;
  Color? get buttonColor => _buttonColor;

  @override
  void onDispose() {
    super.onDispose();
    _timer?.cancel();
    _buttonTimer?.cancel();
  }

  void startAnimatingView(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setUpBannersAnimation();
      setupButtonColorAnimation(context);
    });
  }

  void setUpBannersAnimation() {
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) async {
      if (_currentPage < BannersViewTypes.values.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      bannersPageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeIn,
      );
    });
  }

  void setupButtonColorAnimation(BuildContext context) {
    Color redColor = context.appColors.error_500!;
    Color greyColor = context.appColors.primary_800!;
    Color whiteColor = context.appColors.baseWhite!;

    _textColor = whiteColor;
    _buttonColor = redColor;
    _buttonTimer =
        Timer.periodic(const Duration(milliseconds: 500), (Timer timer) {
      _textColor = (_textColor == whiteColor) ? greyColor : whiteColor;
      _buttonColor = (_buttonColor == redColor) ? whiteColor : redColor;
      notifyListeners();
    });
  }
}
