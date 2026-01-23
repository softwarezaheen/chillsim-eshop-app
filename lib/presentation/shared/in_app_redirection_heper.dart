import "dart:convert";

import "package:esim_open_source/data/remote/request/related_search.dart";
import "package:esim_open_source/presentation/enums/bottomsheet_type.dart";
import "package:esim_open_source/presentation/setup_bottom_sheet_ui.dart";
import "package:esim_open_source/presentation/views/home_flow_views/stories_view/cashback_stories_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/stories_view/referal_stories_view.dart";
import "package:esim_open_source/presentation/widgets/stories_view/story_viewer.dart";
import "package:stacked_services/stacked_services.dart";

sealed class InAppRedirection {
  const InAppRedirection();
  factory InAppRedirection.cashback() = CashbackRedirection;
  factory InAppRedirection.referral() = ReferralRedirection;
  factory InAppRedirection.purchase(PurchaseBundleBottomSheetArgs data) =
      PurchaseRedirection;

  String get routeName;
  dynamic get arguments;
  BottomSheetType? get variant;
  
  // Serialization methods for storing redirection state
  Map<String, dynamic> toJson();
  
  static InAppRedirection? fromJson(String jsonString) {
    try {
      final Map<String, dynamic> json = jsonDecode(jsonString);
      final String type = json['type'] as String;
      
      switch (type) {
        case 'cashback':
          return InAppRedirection.cashback();
        case 'referral':
          return InAppRedirection.referral();
        case 'purchase':
          // Return a special marker that HomePagerViewModel will detect
          // and use to fetch bundle data and reconstruct purchase flow
          final Map<String, dynamic>? data = json['data'] as Map<String, dynamic>?;
          if (data != null && data['bundleCode'] != null) {
            // Store the bundle details for later fetching
            return PendingPurchaseRedirection(
              bundleCode: data['bundleCode'] as String,
              regionCode: data['regionCode'] as String?,
              countryIsoCodes: (data['countryIsoCodes'] as List<dynamic>?)?.cast<String>(),
            );
          }
          return null;
        default:
          return null;
      }
    } catch (e) {
      return null;
    }
  }
}

class CashbackRedirection extends InAppRedirection {
  @override
  String get routeName => StoryViewer.routeName;

  @override
  dynamic get arguments => CashbackStoriesView().storyViewerArgs;

  @override
  BottomSheetType? get variant => null;
  
  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'type': 'cashback',
    };
  }
}

class ReferralRedirection extends InAppRedirection {
  @override
  String get routeName => StoryViewer.routeName;

  @override
  dynamic get arguments =>
      ReferalStoriesView(StackedService.navigatorKey!.currentContext!)
          .storyViewerArgs;

  @override
  BottomSheetType? get variant => null;
  
  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'type': 'referral',
    };
  }
}

class PurchaseRedirection extends InAppRedirection {
  PurchaseRedirection(this.data);
  final PurchaseBundleBottomSheetArgs data;

  @override
  String get routeName => StoryViewer.routeName;

  @override
  dynamic get arguments => data;

  @override
  BottomSheetType? get variant => BottomSheetType.billingInfo;
  
  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'type': 'purchase',
      'data': <String, dynamic>{
        'bundleCode': data.bundleResponseModel?.bundleCode,
        'regionCode': data.region?.isoCode,
        'countryIsoCodes': data.countries?.map((CountriesRequestModel e) => e.isoCode).toList(),
      },
    };
  }
}

// Marker class for purchase redirection that needs bundle fetching
// Used when restoring from LocalStorage after social media login
class PendingPurchaseRedirection extends InAppRedirection {
  PendingPurchaseRedirection({
    required this.bundleCode,
    this.regionCode,
    this.countryIsoCodes,
  });
  
  final String bundleCode;
  final String? regionCode;
  final List<String>? countryIsoCodes;

  @override
  String get routeName => StoryViewer.routeName;

  @override
  dynamic get arguments => null;

  @override
  BottomSheetType? get variant => null; // Will be converted to full PurchaseRedirection after fetch
  
  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'type': 'purchase',
      'data': <String, dynamic>{
        'bundleCode': bundleCode,
        'regionCode': regionCode,
        'countryIsoCodes': countryIsoCodes,
      },
    };
  }
}
