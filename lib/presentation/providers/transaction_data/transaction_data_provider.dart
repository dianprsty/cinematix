import 'package:cinematix/domain/entities/result.dart';
import 'package:cinematix/domain/entities/transaction.dart';
import 'package:cinematix/domain/entities/user.dart';
import 'package:cinematix/domain/usecases/get_transactions/get_transactions.dart';
import 'package:cinematix/domain/usecases/get_transactions/get_transactions_param.dart';
import 'package:cinematix/presentation/providers/usecases/get_transactions_provider.dart';
import 'package:cinematix/presentation/providers/user_data/user_data_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'transaction_data_provider.g.dart';

@Riverpod(keepAlive: true)
class TransactionData extends _$TransactionData {
  @override
  Future<List<Transaction>> build() async {
    User? user = ref.read(userDataProvider).valueOrNull;

    if (user != null) {
      GetTransactions getTransactions = ref.read(getTransactionsProvider);
      var result = await getTransactions(GetTransactionsParam(uid: user.uid));

      if (result case Success(value: final transactionList)) {
        return transactionList;
      }
    }
    return const [];
  }

  Future<void> refreshTransactionData() async {
    User? user = ref.read(userDataProvider).valueOrNull;

    if (user != null) {
      GetTransactions getTransactions = ref.read(getTransactionsProvider);
      var result = await getTransactions(GetTransactionsParam(uid: user.uid));

      switch (result) {
        case Success(value: final transactionList):
          state = AsyncData(transactionList);
        case Failed(message: final message):
          state = AsyncError(FlutterError(message), StackTrace.current);
          state = AsyncData(state.valueOrNull ?? const []);
      }
    }
  }
}
