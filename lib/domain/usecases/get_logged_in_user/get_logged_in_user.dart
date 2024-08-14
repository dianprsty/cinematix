import 'package:cinematix/data/repositories/authentication.dart';
import 'package:cinematix/data/repositories/user_repository.dart';
import 'package:cinematix/domain/entities/result.dart';
import 'package:cinematix/domain/entities/user.dart';
import 'package:cinematix/domain/UseCases/UseCase.dart';

class GetLoggedInUser implements UseCase<Result<User>, void> {
  final Authentication _authentication;
  final UserRepository _userRepository;

  GetLoggedInUser(
      {required Authentication authentication,
      required UserRepository userRepository})
      : _authentication = authentication,
        _userRepository = userRepository;

  @override
  Future<Result<User>> call(void params) async {
    String? loggedId = _authentication.getLoggedInUserId();

    if (loggedId == null) {
      return const Result.failed("No user logged in");
    }

    var user = await _userRepository.getUser(uid: loggedId);

    if (user.isSuccess) {
      return Result.success(user.resultValue!);
    }
    return Result.failed(user.errorMessage!);
  }
}
