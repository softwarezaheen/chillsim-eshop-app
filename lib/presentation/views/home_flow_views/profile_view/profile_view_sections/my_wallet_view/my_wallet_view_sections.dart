import "dart:developer";

import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/app/environment/environment_images.dart";
import "package:esim_open_source/presentation/enums/bottomsheet_type.dart";
import "package:esim_open_source/presentation/setup_bottom_sheet_ui.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/my_wallet_view/my_wallet_view_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/wallet_transactions_view/wallet_transactions_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/stories_view/cashback_stories_view.dart";
import "package:esim_open_source/presentation/widgets/stories_view/story_viewer.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/widgets.dart";
import "package:stacked_services/stacked_services.dart";

enum MyWalletViewSections {
  voucherCode,
  cashbackRewards,
  walletTransactions,
  upgradeWallet;

  bool get isSectionHidden => false;

  String get sectionTitle {
    switch (this) {
      case MyWalletViewSections.voucherCode:
        return LocaleKeys.myWallet_voucherSectionText.tr();
      case MyWalletViewSections.cashbackRewards:
        return LocaleKeys.myWallet_cashbackSectionText.tr();
      case MyWalletViewSections.walletTransactions:
        return LocaleKeys.myWallet_transactionsSectionText.tr();
      case MyWalletViewSections.upgradeWallet:
        return LocaleKeys.myWallet_upgradeSectionText.tr();
    }
  }

  String get sectionImagePath => EnvironmentImages.values
      .firstWhere(
        (EnvironmentImages e) => e.name == _sectionImage,
        orElse: () => EnvironmentImages.wallet,
      )
      .fullImagePath;
  //"assets/images/esim_wallet/$_sectionImage.png";

  String get _sectionImage {
    switch (this) {
      case MyWalletViewSections.voucherCode:
        return "walletVoucher";
      case MyWalletViewSections.cashbackRewards:
        return "walletCashback";
      case MyWalletViewSections.walletTransactions:
        return "wallet";
      case MyWalletViewSections.upgradeWallet:
        return "walletUpgrade";
    }
  }

  Future<void> tapAction(
      BuildContext context, MyWalletViewModel viewModel,) async {
    switch (this) {
      case MyWalletViewSections.voucherCode:
        SheetResponse<EmptyBottomSheetResponse>? voucherCodeResponse =
            await viewModel.bottomSheetService.showCustomSheet(
          enableDrag: false,
          isScrollControlled: true,
          variant: BottomSheetType.voucherCode,
        );
        if (voucherCodeResponse?.confirmed ?? false) {
          log("true");
        }
      case MyWalletViewSections.cashbackRewards:
        viewModel.navigationService.navigateTo(
          StoryViewer.routeName,
          arguments: CashbackStoriesView().storyViewerArgs,
        );
      case MyWalletViewSections.walletTransactions:
        viewModel.navigationService.navigateTo(WalletTransactionsView.routeName);
      case MyWalletViewSections.upgradeWallet:
        SheetResponse<EmptyBottomSheetResponse>? upgradeWalletResponse =
            await viewModel.bottomSheetService.showCustomSheet(
          enableDrag: false,
          isScrollControlled: true,
          variant: BottomSheetType.upgradeWallet,
        );
        if (upgradeWalletResponse?.confirmed ?? false) {
          log("true");
        }
    }
  }
}
