import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/app/environment/environment_images.dart";
import "package:esim_open_source/data/services/consent_initializer.dart";
import "package:esim_open_source/presentation/enums/bottomsheet_type.dart";
import "package:esim_open_source/presentation/views/home_flow_views/main_page/home_pager.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/account_information_view/account_information_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/account_view/account_view_model.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/widgets.dart";
import "package:stacked_services/stacked_services.dart";

enum AccountViewSections {
  accountInformation,
  privacySettings,
  logout,
  deleteAccount;

  bool get isSectionHidden => false;

  String get sectionTitle {
    switch (this) {
      case AccountViewSections.accountInformation:
        return LocaleKeys.profile_accountInformation.tr();
      case AccountViewSections.privacySettings:
        return LocaleKeys.profile_privacySettings.tr();
      case AccountViewSections.logout:
        return LocaleKeys.profile_logout.tr();
      case AccountViewSections.deleteAccount:
        return LocaleKeys.profile_delete.tr();
    }
  }

  String get sectionImagePath => EnvironmentImages.values
      .firstWhere(
        (EnvironmentImages e) => e.name == _sectionImage,
        orElse: () => EnvironmentImages.profilePerson,
      )
      .fullImagePath;

  String get _sectionImage {
    switch (this) {
      case AccountViewSections.accountInformation:
        return "accountInformation";
      case AccountViewSections.privacySettings:
        return "language"; // Using language icon for privacy settings
      case AccountViewSections.logout:
        return "logout";
      case AccountViewSections.deleteAccount:
        return "deleteAccount";
    }
  }

  Future<void> tapAction(
      BuildContext context, AccountViewModel viewModel,) async {
    switch (this) {
      case AccountViewSections.accountInformation:
        viewModel.navigationService.navigateTo(AccountInformationView.routeName);
      case AccountViewSections.privacySettings:
        await ConsentInitializer.showConsentSettings(context);
      case AccountViewSections.logout:
        SheetResponse<dynamic>? logoutResponse =
            await viewModel.bottomSheetService.showCustomSheet(
          enableDrag: false,
          isScrollControlled: true,
          variant: BottomSheetType.logout,
        );
        if (logoutResponse?.confirmed ?? false) {
          await viewModel.logoutUser();
          await viewModel.navigationService.clearStackAndShow(
            HomePager.routeName,
          );
        }
      case AccountViewSections.deleteAccount:
        SheetResponse<dynamic>? deleteAccountResponse =
            await viewModel.bottomSheetService.showCustomSheet(
          enableDrag: false,
          isScrollControlled: true,
          variant: BottomSheetType.deleteAccount,
        );
        if (deleteAccountResponse?.confirmed ?? false) {
          await viewModel.logoutUser();
          await viewModel.navigationService.clearStackAndShow(
            HomePager.routeName,
          );
        }
    }
  }
}
