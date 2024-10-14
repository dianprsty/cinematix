import 'package:cinematix/presentation/misc/method.dart';
import 'package:cinematix/presentation/providers/transaction_data/transaction_data_provider.dart';
import 'package:cinematix/presentation/widgets/transaction_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

List<Widget> recentTransactions(WidgetRef ref) => [
      const Text(
        'Recent Transactions',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      verticalSpace(24),
      ...ref.watch(transactionDataProvider).when(
            data: (transactions) => (transactions.isNotEmpty
                    ? (transactions
                      ..sort((a, b) =>
                          -a.transactionTime!.compareTo(b.transactionTime!)))
                    : transactions)
                .map(
                    (transaction) => TransactionCard(transaction: transaction)),
            error: (error, stackTrace) => [],
            loading: () => [const CircularProgressIndicator()],
          )
    ];
