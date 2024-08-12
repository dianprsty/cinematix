import 'package:cinematix/data/repositories/user_repository.dart';
import 'package:cinematix/domain/entities/result.dart';
import 'package:cinematix/domain/entities/user.dart';
import 'package:cinematix/domain/usecases/upload_profile_picture.dart/upload_profile_picture_param.dart';
import 'package:cinematix/domain/usecases/usecase.dart';

class UploadProfilePicture
    implements UseCase<Result<User>, UploadProfilePictureParam> {
  final UserRepository _userRepository;
  UploadProfilePicture({required UserRepository userRepository})
      : _userRepository = userRepository;

  @override
  Future<Result<User>> call(UploadProfilePictureParam params) =>
      _userRepository.uploadProfilePicture(
        user: params.user,
        imageFile: params.imageFile,
      );
}
