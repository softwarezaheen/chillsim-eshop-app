
import "package:easy_localization/easy_localization.dart";
import "package:flutter/material.dart";

import "package:esim_open_source/data/remote/responses/user/wallet_transaction_response.dart";

import "package:esim_open_source/app/environment/environment_images.dart";

import "package:esim_open_source/di/locator.dart";



import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/presentation/views/base/base_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/wallet_transactions_view/wallet_transaction_item_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/wallet_transactions_view/wallet_transactions_view_model.dart";
import "package:esim_open_source/presentation/widgets/common_navigation_title.dart";
import "package:esim_open_source/presentation/widgets/empty_paginated_state_list_view.dart";
import "package:esim_open_source/presentation/widgets/empty_state_widget.dart";
import "package:esim_open_source/presentation/widgets/main_button.dart";
import "package:esim_open_source/presentation/widgets/padding_widget.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";


class WalletTransactionsView extends StatelessWidget {
  const WalletTransactionsView({super.key});
  
  static const String routeName = "WalletTransactionsView";

  @override
  Widget build(BuildContext context) {
    final viewModel = locator<WalletTransactionsViewModel>();
    
    return BaseView<WalletTransactionsViewModel>(
      hideAppBar: true,
      routeName: routeName,
      viewModel: viewModel,
      builder: (
        BuildContext context,
        WalletTransactionsViewModel viewModel,
        Widget? childWidget,
        double screenHeight,
      ) =>
          SizedBox(
        height: double.infinity,
        child: PaddingWidget.applyPadding(
          top: 20,
          child: Column(
            children: <Widget>[
              CommonNavigationTitle(
                navigationTitle: LocaleKeys.walletTransactions_titleText.tr(),
                textStyle: headerTwoBoldTextStyle(
                  context: context,
                  fontColor: titleTextColor(context: context),
                ),
              ),
              verticalSpaceSmall,
              Expanded(
                child: PaddingWidget.applyPadding(
                  top: 20,
                  start: 15,
                  end: 15,
                  child: EmptyPaginatedStateListView<WalletTransactionResponse>(
                    emptyStateWidget: EmptyStateWidget(
                      title: LocaleKeys.walletTransactions_emptyTitleText.tr(), 
                      imagePath: EnvironmentImages.emptyRewardHistory.fullImagePath,
                      content: LocaleKeys.walletTransactions_emptyContentText.tr(),
                      button: MainButton.bannerButton(
                        title: LocaleKeys.walletTransactions_emptyButtonText.tr(),
                        action: () async => Navigator.of(context).pop(),
                        themeColor: themeColor,
                        textColor: enabledMainButtonTextColor(context: context),
                        buttonColor: enabledMainButtonColor(context: context),
                        titleTextStyle: captionOneBoldTextStyle(
                          context: context,
                        ),
                      ),
                    ),
                    paginationService: viewModel.walletTransactionsPaginationService,
                    onRefresh: viewModel.refreshTransactions,
                    onLoadItems: viewModel.getTransactions,
                    separatorBuilder: (BuildContext context, int index) =>
                        verticalSpaceSmallMedium,
                    builder: (WalletTransactionResponse response) {
                      WalletTransactionUiModel transactionModel = 
                          WalletTransactionUiModel.fromResponse(response);
                      return WalletTransactionItemView(
                        transactionModel: transactionModel,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }





}