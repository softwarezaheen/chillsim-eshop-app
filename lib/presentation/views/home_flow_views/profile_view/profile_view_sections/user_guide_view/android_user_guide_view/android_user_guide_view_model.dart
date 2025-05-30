import "package:esim_open_source/presentation/views/base/base_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/user_guide_view/android_user_guide_view/android_gallery_user_guide_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/user_guide_view/user_guide_detailed_view/user_guide_detailed_view.dart";

class AndroidUserGuideViewModel extends BaseModel {
  Future<void> scanFromQr() async {
    navigationService.navigateTo(
      UserGuideDetailedView.routeName,
    );
  }

  Future<void> scanFromGallery() async {
    navigationService.navigateTo(
      AndroidGalleryUserGuideView.routeName,
    );
  }
}
