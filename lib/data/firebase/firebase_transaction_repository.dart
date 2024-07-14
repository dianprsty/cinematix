import 'package:cinematix/data/firebase/firebase_user_repository.dart';
import 'package:cinematix/data/repositories/transaction_repository.dart';
import 'package:cinematix/domain/entities/result.dart';
import 'package:cinematix/domain/entities/transaction.dart';

import 'package:cloud_firestore/cloud_firestore.dart' as firestore;

class FirebaseTransactionRepository implements TransactionRepository {
  final firestore.FirebaseFirestore _firebaseFirestore;

  FirebaseTransactionRepository(
      {firestore.FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore =
            firebaseFirestore ?? firestore.FirebaseFirestore.instance;

  @override
  Future<Result<Transaction>> createTransaction(
      {required Transaction transaction}) async {
    firestore.CollectionReference<Map<String, dynamic>> transactions =
        _firebaseFirestore.collection('transactions');
    try {
      var balanceResult =
          await FirebaseUserRepository().getUserBalance(uid: transaction.uid);

      if (balanceResult.isFailed) {
        return const Result.failed("Failed to create transaction data");
      }

      int previousBalance = balanceResult.resultValue!;
      int finalBalance = previousBalance - transaction.total;

      if (finalBalance < 0) {
        return const Result.failed("insufficient balance");
      }

      await transactions.doc(transaction.id).set(transaction.toJson());

      var result = await transactions.doc(transaction.id).get();

      if (!result.exists) {
        return const Result.failed("Failed to create transaction data");
      }

      await FirebaseUserRepository()
          .updateUserBalance(uid: transaction.uid, balance: finalBalance);

      return Result.success(Transaction.fromJson(result.data()!));
    } catch (e) {
      return const Result.failed("Failed to create transaction data");
    }
  }

  @override
  Future<Result<List<Transaction>>> getUserTransactions(
      {required String uid}) async {
    firestore.CollectionReference<Map<String, dynamic>> transactions =
        _firebaseFirestore.collection("transactions");

    try {
      var result = await transactions.where("uid", isEqualTo: uid).get();

      return result.docs.isNotEmpty
          ? Result.success(
              result.docs.map((e) => Transaction.fromJson(e.data())).toList())
          : const Result.success([]);
    } catch (e) {
      return const Result.failed("Failed to get user transaction");
    }
  }
}
