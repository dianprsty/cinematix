import 'dart:io';

import 'package:cinematix/domain/UseCases/login/login.dart';
import 'package:cinematix/domain/UseCases/register/register_param.dart';
import 'package:cinematix/domain/entities/result.dart';
import 'package:cinematix/domain/entities/user.dart';
import 'package:cinematix/domain/usecases/get_logged_in_user/get_logged_in_user.dart';
import 'package:cinematix/domain/usecases/logout/logout.dart';
import 'package:cinematix/domain/usecases/register/register.dart';
import 'package:cinematix/domain/usecases/top_up/top_up.dart';
import 'package:cinematix/domain/usecases/top_up/top_up_param.dart';
import 'package:cinematix/domain/usecases/upload_profile_picture.dart/upload_profile_picture.dart';
import 'package:cinematix/domain/usecases/upload_profile_picture.dart/upload_profile_picture_param.dart';

import 'package:cinematix/presentation/providers/movie/now_playing_provider.dart';
import 'package:cinematix/presentation/providers/movie/upcoming_provider.dart';
import 'package:cinematix/presentation/providers/transaction_data/transaction_data_provider.dart';
import 'package:cinematix/presentation/providers/usecases/get_logged_in_user_provider.dart';
import 'package:cinematix/presentation/providers/usecases/login_provider.dart';
import 'package:cinematix/presentation/providers/usecases/logout_provider.dart';
import 'package:cinematix/presentation/providers/usecases/register_provider.dart';
import 'package:cinematix/presentation/providers/usecases/top_up_provider.dart';
import 'package:cinematix/presentation/providers/usecases/upload_profile_picture_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_data_provider.g.dart';

@Riverpod(keepAlive: true)
class UserData extends _$UserData {
  @override
  Future<User?> build() async {
    GetLoggedInUser getLoggedInUser = ref.read(getLoggedInUserProvider);
    var userResult = await getLoggedInUser(null);

    switch (userResult) {
      case Success(value: final user):
        _getMovies();
        return user;
      case Failed(message: final _):
        return null;
    }
  }

  Future<void> login({required String email, required String password}) async {
    state = const AsyncLoading();

    Login login = ref.read(loginProvider);

    var result = await login(LoginParams(email: email, password: password));

    switch (result) {
      case Success(value: final user):
        _getMovies();
        state = AsyncData(user);
      case Failed(message: final message):
        state = AsyncError(FlutterError(message), StackTrace.current);
        state = const AsyncData(null);
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String name,
    String? imageUrl,
  }) async {
    state = const AsyncLoading();
    Register register = ref.read(registerProvider);

    var result = await register(RegisterParam(
      email: email,
      password: password,
      name: name,
      photoUrl: imageUrl,
    ));

    switch (result) {
      case Success(value: final user):
        _getMovies();
        state = AsyncData(user);
      case Failed(message: final message):
        state = AsyncError(FlutterError(message), StackTrace.current);
        state = const AsyncData(null);
    }
  }

  Future<void> refreshUserData() async {
    GetLoggedInUser getLoggedInUser = ref.read(getLoggedInUserProvider);
    var userResult = await getLoggedInUser(null);

    if (userResult case Success(value: final user)) {
      state = AsyncData(user);
    }
  }

  Future<void> logout() async {
    Logout logout = ref.read(logoutProvider);
    var result = await logout(null);

    switch (result) {
      case Success(value: final _):
        state = const AsyncData(null);
      case Failed(message: final message):
        state = AsyncError(FlutterError(message), StackTrace.current);
        state = AsyncData(state.valueOrNull);
    }
  }

  Future<void> topUp(int amount) async {
    TopUp topUp = ref.read(topUpProvider);

    String? userId = state.valueOrNull?.uid;

    if (userId != null) {
      var result = await topUp(TopUpParam(amount: amount, userId: userId));

      if (result.isSuccess) {
        refreshUserData();
        ref.read(transactionDataProvider.notifier).refreshTransactionData();
      }
    }
  }

  Future<void> uploadProfilePicture({
    required User user,
    required File imageFile,
  }) async {
    UploadProfilePicture uploadProfilePicture =
        ref.read(uploadProfilePictureProvider);

    var result = await uploadProfilePicture(UploadProfilePictureParam(
      user: user,
      imageFile: imageFile,
    ));

    if (result case Success(value: final user)) {
      state = AsyncData(user);
    }
  }

  void _getMovies() {
    ref.read(nowPlayingProvider.notifier).getMovies();
    ref.read(upcomingProvider.notifier).getUpcoming();
  }
}
