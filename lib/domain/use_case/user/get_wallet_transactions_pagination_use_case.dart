import "dart:async";
import "dart:developer";

import "package:esim_open_source/data/remote/responses/user/wallet_transaction_response.dart";
import "package:esim_open_source/domain/repository/api_user_repository.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/util/pagination/paginated_data.dart";
import "package:esim_open_source/domain/util/pagination/pagination_params.dart";
import "package:esim_open_source/domain/util/resource.dart";

class GetWalletTransactionsPaginationUseCase
    extends PaginatedUseCase<WalletTransactionResponse, NoParams> {
  GetWalletTransactionsPaginationUseCase(this.repository);

  final ApiUserRepository repository;

  @override
  PaginationService<WalletTransactionResponse> paginationService =
      PaginationService<WalletTransactionResponse>();

  @override
  Future<void> loadNextPage(
    NoParams params,
  ) async {
    log("wallet transactions: loadNextPage: start");
    if (state.isLoading || !state.hasMore) {
      return;
    }
    state = state.copyWith(isLoading: true);
    paginationService.changeValue(paginatedData: state);

    try {
      Resource<List<WalletTransactionResponse>?> resource =
          await repository.getWalletTransactions(
        pageIndex: state.currentPage,
        pageSize: defaultPageSize,
      );
      switch (resource.resourceType) {
        case ResourceType.success:
          final PaginatedData<WalletTransactionResponse> newState =
              paginateList(
            resource.data ?? <WalletTransactionResponse>[],
            PaginationParams(
              page: state.currentPage,
              pageSize: defaultPageSize,
            ),
          );
          state = newState.copyWith(isLoading: false);
          paginationService.changeValue(paginatedData: state);
        case ResourceType.error:
          final PaginatedData<WalletTransactionResponse> newState =
              state.copyWith(
            isLoading: false,
            error: resource.error.toString(),
          );
          paginationService.changeValue(paginatedData: newState);
        case ResourceType.loading:
      }
    } on Error catch (e) {
      final PaginatedData<WalletTransactionResponse> newState = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      paginationService.changeValue(paginatedData: newState);
    }
  }

  @override
  Future<void> refreshData(
    NoParams params,
  ) async {
    refresh();
    return loadNextPage(params);
  }
}