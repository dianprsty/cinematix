import 'package:cinematix/data/repositories/transaction_repository.dart';
import 'package:cinematix/domain/entities/result.dart';
import 'package:cinematix/domain/entities/transaction.dart';
import 'package:cinematix/domain/usecases/create_trasaction/create_transaction.dart';
import 'package:cinematix/domain/usecases/create_trasaction/create_transaction_param.dart';
import 'package:cinematix/domain/usecases/top_up/top_up_param.dart';
import 'package:cinematix/domain/usecases/usecase.dart';

class TopUp implements UseCase<Result<void>, TopUpParam> {
  final TransactionRepository _transactionRepository;

  TopUp({required TransactionRepository transactionRepository})
      : _transactionRepository = transactionRepository;

  @override
  Future<Result<void>> call(TopUpParam params) async {
    CreateTransaction createTransaction =
        CreateTransaction(transactionRepository: _transactionRepository);

    int transactionTime = DateTime.now().millisecondsSinceEpoch;

    var createTransactionResult = await createTransaction(
        CreateTransactionParam(
            transaction: Transaction(
                id: 'ctxtp-$transactionTime-${params.userId}',
                uid: params.userId,
                title: 'Top Up',
                adminFee: 0,
                total: -params.amount,
                transactionTime: transactionTime)));

    return switch (createTransactionResult) {
      Success(value: final _) => const Result.success(null),
      Failed(message: final message) => Result.failed(message),
    };
  }
}
