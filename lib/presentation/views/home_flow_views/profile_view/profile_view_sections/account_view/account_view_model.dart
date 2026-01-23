import "package:esim_open_source/presentation/views/base/base_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/account_view/account_view_sections.dart";

class AccountViewModel extends BaseModel {
  List<AccountViewSections> accountSections = AccountViewSections.values;
}
