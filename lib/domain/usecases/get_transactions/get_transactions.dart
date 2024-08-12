import 'package:cinematix/data/repositories/transaction_repository.dart';
import 'package:cinematix/domain/entities/result.dart';
import 'package:cinematix/domain/entities/transaction.dart';
import 'package:cinematix/domain/usecases/get_transactions/get_transactions_param.dart';
import 'package:cinematix/domain/usecases/usecase.dart';

class GetTransactions
    implements UseCase<Result<List<Transaction>>, GetTransactionsParam> {
  final TransactionRepository _transactionRepository;
  GetTransactions({required TransactionRepository transactionRepository})
      : _transactionRepository = transactionRepository;

  @override
  Future<Result<List<Transaction>>> call(GetTransactionsParam params) async {
    var result =
        await _transactionRepository.getUserTransactions(uid: params.uid);
    return switch (result) {
      Success(value: final transactionList) => Result.success(transactionList),
      Failed(message: final message) => Result.failed(message),
    };
  }
}
