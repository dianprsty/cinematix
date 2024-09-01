import 'package:cinematix/data/repositories/authentication.dart';
import 'package:cinematix/domain/entities/result.dart';

class DummyAuthentication implements Authentication {
  @override
  String? getLoggedInUserId() {
    return "ID-12345";
  }

  @override
  Future<Result<String>> login(
      {required String email, required String password}) async {
    await Future.delayed(const Duration(seconds: 1));
    return const Result.success("ID-12345");
  }

  @override
  Future<Result<void>> logout() async {
    await Future.delayed(const Duration(seconds: 1));
    return Result.success(dummyFunction());
  }

  @override
  Future<Result<String>> register(
      {required String email, required String password}) async {
    await Future.delayed(const Duration(seconds: 1));
    return const Result.success("ID-12345");
  }

  void dummyFunction() {}
}
