import "package:esim_open_source/presentation/enums/bottomsheet_type.dart";
import "package:esim_open_source/presentation/setup_bottom_sheet_ui.dart";
import "package:esim_open_source/presentation/views/home_flow_views/stories_view/cashback_stories_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/stories_view/referal_stories_view.dart";
import "package:esim_open_source/presentation/widgets/stories_view/story_viewer.dart";

sealed class InAppRedirection {
  const InAppRedirection();
  factory InAppRedirection.cashback() = CashbackRedirection;
  factory InAppRedirection.referral() = ReferralRedirection;
  factory InAppRedirection.purchase(PurchaseBundleBottomSheetArgs data) =
      PurchaseRedirection;

  String get routeName;
  dynamic get arguments;
  BottomSheetType? get variant;
}

class CashbackRedirection extends InAppRedirection {
  @override
  String get routeName => StoryViewer.routeName;

  @override
  dynamic get arguments => CashbackStoriesView().storyViewerArgs;

  @override
  BottomSheetType? get variant => null;
}

class ReferralRedirection extends InAppRedirection {
  @override
  String get routeName => StoryViewer.routeName;

  @override
  dynamic get arguments => ReferalStoriesView().storyViewerArgs;

  @override
  BottomSheetType? get variant => null;
}

class PurchaseRedirection extends InAppRedirection {
  PurchaseRedirection(this.data);
  final PurchaseBundleBottomSheetArgs data;

  @override
  String get routeName => StoryViewer.routeName;

  @override
  dynamic get arguments => data;

  @override
  BottomSheetType? get variant => BottomSheetType.bundleDetails;
}
