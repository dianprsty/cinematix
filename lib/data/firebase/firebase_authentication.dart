import 'package:cinematix/data/repositories/authentication.dart';
import 'package:cinematix/domain/entities/result.dart';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class FirebaseAuthentication implements Authentication {
  final firebase_auth.FirebaseAuth _firebaseAuth;

  FirebaseAuthentication({firebase_auth.FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance;
  @override
  String? getLoggedInUserId() => _firebaseAuth.currentUser?.uid;

  @override
  Future<Result<String>> login(
      {required String email, required String password}) async {
    try {
      var userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return Result.success(userCredential.user!.uid);
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Result.failed(e.message ?? 'Failed to sign in');
    }
  }

  @override
  Future<Result<void>> logout() async {
    await _firebaseAuth.signOut();
    return _firebaseAuth.currentUser == null
        ? const Result.success(null)
        : const Result.failed("Failed to sign out");
  }

  @override
  Future<Result<String>> register({
    required String email,
    required String password,
  }) async {
    try {
      var userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      return Result.success(userCredential.user!.uid);
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Result.failed('${e.message}');
    }
  }
}
