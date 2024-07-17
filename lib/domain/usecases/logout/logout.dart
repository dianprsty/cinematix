import 'package:cinematix/data/repositories/authentication.dart';
import 'package:cinematix/domain/entities/result.dart';
import 'package:cinematix/domain/usecases/usecase.dart';

class Logout implements Usecase<Result<void>, void> {
  final Authentication _authentication;

  Logout({required Authentication authentication})
      : _authentication = authentication;

  @override
  Future<Result<void>> call(void params) {
    return _authentication.logout();
  }
}
