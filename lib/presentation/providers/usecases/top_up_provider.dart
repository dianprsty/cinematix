import 'package:cinematix/domain/usecases/top_up/top_up.dart';
import 'package:cinematix/presentation/providers/repositories/transaction_repository/transaction_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'top_up_provider.g.dart';

@riverpod
TopUp topUp(TopUpRef ref) =>
    TopUp(transactionRepository: ref.watch(transactionRepositoryProvider));
