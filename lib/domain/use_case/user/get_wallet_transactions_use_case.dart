import "dart:async";

import "package:esim_open_source/data/remote/responses/user/wallet_transaction_response.dart";
import "package:esim_open_source/domain/repository/api_user_repository.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";

class GetWalletTransactionsUseCase implements UseCase<Resource<List<WalletTransactionResponse>?>, NoParams> {
  GetWalletTransactionsUseCase(this.repository);
  final ApiUserRepository repository;

  @override
  FutureOr<Resource<List<WalletTransactionResponse>?>> execute(NoParams? params) async {
    return await repository.getWalletTransactions(pageIndex: 0, pageSize: 20);
  }
}