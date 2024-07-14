import 'dart:io';

import 'package:cinematix/data/repositories/user_repository.dart';
import 'package:cinematix/domain/entities/result.dart';
import 'package:cinematix/domain/entities/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class FirebaseUserRepository implements UserRepository {
  final FirebaseFirestore _firebaseFirestore;

  FirebaseUserRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Future<Result<User>> createUser({
    required String uid,
    required String email,
    required String name,
    String? photoUrl,
    int balance = 0,
  }) async {
    CollectionReference<Map<String, dynamic>> users =
        _firebaseFirestore.collection("users");

    await users.doc(uid).set({
      'uid': uid,
      'email': email,
      'name': name,
      'photoUrl': photoUrl,
      'balance': balance,
    });

    DocumentSnapshot<Map<String, dynamic>> result = await users.doc(uid).get();

    return result.exists
        ? Result.success(User.fromJson(result.data()!))
        : const Result.failed('failed to create user');
  }

  @override
  Future<Result<User>> getUser({required String uid}) async {
    DocumentReference<Map<String, dynamic>> documentReference =
        _firebaseFirestore.doc('users/$uid');

    DocumentSnapshot<Map<String, dynamic>> result =
        await documentReference.get();

    if (result.exists) {
      return Result.success(User.fromJson(result.data()!));
    } else {
      return const Result.failed("user not found");
    }
  }

  @override
  Future<Result<int>> getUserBalance({required String uid}) async {
    try {
      DocumentReference<Map<String, dynamic>> documentReference =
          _firebaseFirestore.doc('user/$uid');

      DocumentSnapshot<Map<String, dynamic>> result =
          await documentReference.get();

      return result.exists
          ? Result.success(result.data()!['balance'])
          : const Result.failed("User not found");
    } on FirebaseException catch (e) {
      return Result.failed(e.message ?? 'Failed to get user balance');
    }
  }

  @override
  Future<Result<User>> updateUser({required User user}) async {
    try {
      DocumentReference<Map<String, dynamic>> documentReference =
          _firebaseFirestore.doc('user/${user.uid}');

      await documentReference.update(user.toJson());

      DocumentSnapshot<Map<String, dynamic>> result =
          await documentReference.get();

      if (!result.exists) {
        return const Result.failed('Failed to update user sata');
      }

      User updateUser = User.fromJson(result.data()!);
      return updateUser == user
          ? Result.success(updateUser)
          : const Result.failed('Failed to update user sata');
    } on FirebaseException catch (e) {
      return Result.failed(e.message ?? 'Failed to update user sata');
    }
  }

  @override
  Future<Result<User>> updateUserBalance(
      {required String uid, required int balance}) async {
    DocumentReference<Map<String, dynamic>> documentReference =
        _firebaseFirestore.doc('user/$uid');

    DocumentSnapshot<Map<String, dynamic>> result =
        await documentReference.get();

    if (!result.exists) {
      return const Result.failed("User not found");
    }

    DocumentSnapshot<Map<String, dynamic>> updatedResult =
        await documentReference.get();

    if (!updatedResult.exists) {
      return const Result.failed("Failed to retrieve updated user balance");
    }

    User updatedUser = User.fromJson(updatedResult.data()!);

    return updatedUser.balance == balance
        ? Result.success(updatedUser)
        : const Result.failed("Failed to retrieve user balance");
  }

  @override
  Future<Result<User>> uploadProfilePicture(
      {required User user, required File imageFile}) async {
    String filename = basename(imageFile.path);

    Reference reference = FirebaseStorage.instance.ref().child(filename);

    try {
      await reference.putFile(imageFile);

      String downloadUrl = await reference.getDownloadURL();

      var updateResult =
          await updateUser(user: user.copyWith(photoUrl: downloadUrl));

      return updateResult.isSuccess
          ? Result.success(updateResult.resultValue!)
          : Result.failed(updateResult.errorMessage!);
    } catch (e) {
      return const Result.failed('Failed to upload profile picture');
    }
  }
}
