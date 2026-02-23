import "package:esim_open_source/domain/repository/services/app_configuration_service.dart";
import "package:esim_open_source/presentation/views/base/base_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/help_view/help_view_sections.dart";

class HelpViewModel extends BaseModel {

  HelpViewModel(this.appConfigurationService);
  final AppConfigurationService appConfigurationService;

  List<HelpViewSections> helpSections = HelpViewSections.values;
}
