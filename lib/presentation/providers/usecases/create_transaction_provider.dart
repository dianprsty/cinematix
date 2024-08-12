import 'package:cinematix/domain/usecases/create_trasaction/create_transaction.dart';
import 'package:cinematix/presentation/providers/repositories/transaction_repository/transaction_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_transaction_provider.g.dart';

@riverpod
CreateTransaction createTransaction(CreateTransactionRef ref) =>
    CreateTransaction(
        transactionRepository: ref.watch(transactionRepositoryProvider));
