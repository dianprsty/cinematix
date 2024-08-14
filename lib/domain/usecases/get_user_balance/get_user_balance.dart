import 'package:cinematix/data/repositories/user_repository.dart';
import 'package:cinematix/domain/entities/result.dart';
import 'package:cinematix/domain/usecases/get_user_balance/get_user_balance_param.dart';
import 'package:cinematix/domain/usecases/usecase.dart';

class GetUserBalance implements UseCase<Result<int>, GetUserBalanceParam> {
  final UserRepository _userRepository;

  GetUserBalance({required UserRepository userRepository})
      : _userRepository = userRepository;

  @override
  Future<Result<int>> call(GetUserBalanceParam params) =>
      _userRepository.getUserBalance(uid: params.uid);
}
