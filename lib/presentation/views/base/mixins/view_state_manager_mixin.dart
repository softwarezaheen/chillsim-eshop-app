import "package:esim_open_source/presentation/enums/view_state.dart";
import "package:stacked/stacked.dart";

mixin ViewStateManagerMixin on BaseViewModel {
  ViewState _viewState = ViewState.idle;

  ViewState get viewState => _viewState;

  double? shimmerHeight;

  bool _applyShimmer = false;

  bool get applyShimmer => _applyShimmer;

  set applyShimmer(bool value) {
    _applyShimmer = value;
    notifyListeners();
  }

  @override
  bool get isBusy => _viewState == ViewState.busy;

  void setViewState(ViewState state) {
    _viewState = state;
    notifyListeners();
  }

  // Handle loading state
  void handleLoading() {
    setViewState(ViewState.busy);
  }

  void setIdleState() {
    setViewState(ViewState.idle);
  }
}
