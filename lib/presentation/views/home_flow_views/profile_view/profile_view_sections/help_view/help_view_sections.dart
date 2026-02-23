import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/app/environment/environment_images.dart";
import "package:esim_open_source/presentation/shared/action_helpers.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/contact_us_view/contact_us_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/dynamic_data_view/dynamic_data_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/dynamic_data_view/dynamic_data_view_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/faq_view/faq_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/help_view/help_view_model.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/widgets.dart";

enum HelpViewSections {
  contactUs,
  whatsapp,
  faq,
  aboutUs;

  bool get isSectionHidden => false;

  String get sectionTitle {
    switch (this) {
      case HelpViewSections.contactUs:
        return LocaleKeys.profile_contactUs.tr();
      case HelpViewSections.whatsapp:
        return "WhatsApp";
      case HelpViewSections.faq:
        return LocaleKeys.profile_faq.tr();
      case HelpViewSections.aboutUs:
        return LocaleKeys.profile_aboutUs.tr();
    }
  }

  String get sectionImagePath => EnvironmentImages.values
      .firstWhere(
        (EnvironmentImages e) => e.name == _sectionImage,
        orElse: () => EnvironmentImages.faq,
      )
      .fullImagePath;

  String get _sectionImage {
    switch (this) {
      case HelpViewSections.contactUs:
        return "contactUs";
      case HelpViewSections.whatsapp:
        return "contactUs";
      case HelpViewSections.faq:
        return "faq";
      case HelpViewSections.aboutUs:
        return "aboutUs";
    }
  }

  Future<void> tapAction(
      BuildContext context, HelpViewModel viewModel,) async {
    switch (this) {
      case HelpViewSections.contactUs:
        viewModel.navigationService.navigateTo(ContactUsView.routeName);
      case HelpViewSections.whatsapp:
        await openWhatsApp(
          phoneNumber: await viewModel.appConfigurationService.getWhatsAppNumber,
          message: "", // Empty message, user will type
        );
      case HelpViewSections.faq:
        viewModel.navigationService.navigateTo(FaqView.routeName);
      case HelpViewSections.aboutUs:
        viewModel.navigationService.navigateTo(
          DynamicDataView.routeName,
          arguments: DynamicDataViewType.aboutUs,
        );
    }
  }
}
