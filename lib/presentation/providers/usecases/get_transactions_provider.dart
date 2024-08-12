import 'package:cinematix/domain/usecases/get_transactions/get_transactions.dart';
import 'package:cinematix/presentation/providers/repositories/transaction_repository/transaction_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_transactions_provider.g.dart';

@riverpod
GetTransactions getTransactions(GetTransactionsRef ref) => GetTransactions(
    transactionRepository: ref.watch(transactionRepositoryProvider));
