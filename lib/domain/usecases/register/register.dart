import 'package:cinematix/data/repositories/authentication.dart';
import 'package:cinematix/data/repositories/user_repository.dart';
import 'package:cinematix/domain/entities/result.dart';
import 'package:cinematix/domain/entities/user.dart';
import 'package:cinematix/domain/UseCases/register/register_param.dart';
import 'package:cinematix/domain/UseCases/UseCase.dart';

class Register implements UseCase<Result<User>, RegisterParam> {
  final Authentication _authentication;
  final UserRepository _userRepository;

  Register(
      {required Authentication authentication,
      required UserRepository userRepository})
      : _authentication = authentication,
        _userRepository = userRepository;

  @override
  Future<Result<User>> call(RegisterParam params) async {
    var uidResult = await _authentication.register(
        email: params.email, password: params.password);

    if (uidResult.isSuccess) {
      var userResult = await _userRepository.createUser(
        uid: uidResult.resultValue!,
        email: params.email,
        name: params.name,
        photoUrl: params.photoUrl,
      );

      if (userResult.isSuccess) {
        return Result.success(userResult.resultValue!);
      } else {
        return Result.failed(userResult.errorMessage!);
      }
    } else {
      return Result.failed(uidResult.errorMessage!);
    }
  }
}
