import 'dart:io';

import 'package:cinematix/data/repositories/user_repository.dart';
import 'package:cinematix/domain/entities/result.dart';
import 'package:cinematix/domain/entities/user.dart';

class DummyUserRepository implements UserRepository {
  @override
  Future<Result<User>> createUser(
      {required String uid,
      required String email,
      required String name,
      String? photoUrl,
      int balance = 0}) async {
    await Future.delayed(const Duration(seconds: 1));
    return Result.success(
      User(uid: uid, email: "dummy@dummy.com", name: "Dummy Dummy"),
    );
  }

  @override
  Future<Result<User>> getUser({required String uid}) async {
    await Future.delayed(const Duration(seconds: 1));

    return Result.success(
      User(uid: uid, email: "dummy@dummy.com", name: "Dummy Dummy"),
    );
  }

  @override
  Future<Result<int>> getUserBalance({required String uid}) async {
    await Future.delayed(const Duration(seconds: 1));

    return const Result.success(0);
  }

  @override
  Future<Result<User>> updateUser({required User user}) async {
    await Future.delayed(const Duration(seconds: 1));
    return Result.success(
      User(uid: user.uid, email: "updated@dummy.com", name: "Updated Dummy"),
    );
  }

  @override
  Future<Result<User>> updateUserBalance(
      {required String uid, required int balance}) async {
    await Future.delayed(const Duration(seconds: 1));
    return Result.success(
      User(
          uid: uid,
          email: "dummy@dummy.com",
          name: "Dummy Dummy",
          balance: balance),
    );
  }

  @override
  Future<Result<User>> uploadProfilePicture(
      {required User user, required File imageFile}) async {
    await Future.delayed(const Duration(seconds: 1));

    return Result.success(
      User(uid: user.uid, email: "dummy@dummy.com", name: "Dummy Dummy"),
    );
  }
}
