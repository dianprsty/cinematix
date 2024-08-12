import 'package:cinematix/data/repositories/movie_repository.dart';
import 'package:cinematix/domain/UseCases/UseCase.dart';
import 'package:cinematix/domain/entities/movie.dart';
import 'package:cinematix/domain/entities/result.dart';
import 'package:cinematix/domain/usecases/get_movie_list/get_movie_list_param.dart';

class GetMovieList implements UseCase<Result<List<Movie>>, GetMovieListParam> {
  final MovieRepository _movieRepository;

  GetMovieList({required MovieRepository movieRepository})
      : _movieRepository = movieRepository;
  @override
  Future<Result<List<Movie>>> call(GetMovieListParam params) async {
    var movieresult = switch (params.category) {
      MovieListCategory.nowPlaying => await _movieRepository.getNowPlaying(),
      MovieListCategory.upcoming => await _movieRepository.getUpcoming(),
    };

    return switch (movieresult) {
      Success(value: final movies) => Result.success(movies),
      Failed(:final message) => Result.failed(message)
    };
  }
}
