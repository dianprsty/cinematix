import 'package:cinematix/data/repositories/movie_repository.dart';
import 'package:cinematix/domain/entities/actor.dart';
import 'package:cinematix/domain/entities/movie.dart';
import 'package:cinematix/domain/entities/movie_detail.dart';
import 'package:cinematix/domain/entities/result.dart';
import 'package:dio/dio.dart';

class TmdbMovieRepository implements MovieRepository {
  final Dio? _dio;
  final String _accessToken =
      "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI1NTFhYzM3NTVjMDJmN2IxOGY3NzU5YWI3OTUzZGNkZCIsIm5iZiI6MTcyMTAxMTA2MS43ODE1OTcsInN1YiI6IjY1ZTUyZjE1OTk3OWQyMDE3Y2IzN2U1YiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.8kQtFOwxtU-vYFZUezmEqwNIaJRcZpjcfGnCYhvtczU";

  late final Options _options = Options(headers: {
    "Authorization": "Bearer $_accessToken",
    "accept": "aplication/json",
  });

  TmdbMovieRepository({Dio? dio}) : _dio = dio ?? Dio();
  @override
  Future<Result<List<Actor>>> getActors({required int id}) async {
    try {
      final response = await _dio!.get(
        'https://api.themoviedb.org/3/movie/$id/credits',
        options: _options,
      );

      final result = List<Map<String, dynamic>>.from(response.data["cast"]);

      return Result.success(result.map((e) => Actor.fromJSON(e)).toList());
    } on DioException catch (e) {
      return Result.failed("${e.message}");
    }
  }

  @override
  Future<Result<MovieDetail>> getDetail({required int id}) async {
    try {
      final response = await _dio!.get(
        'https://api.themoviedb.org/3/movie/$id?language=en-US',
        options: _options,
      );

      final result = List<Map<String, dynamic>>.from(response.data["results"]);

      return Result.success(MovieDetail.fromJSON(response.data));
    } on DioException catch (e) {
      return Result.failed("${e.message}");
    }
  }

  @override
  Future<Result<List<Movie>>> getNowPlaying({int page = 1}) async =>
      _getMovies(_MovieCategry.nowPlaying.toString(), page: page);

  @override
  Future<Result<List<Movie>>> getUpcoming({int page = 1}) async =>
      _getMovies(_MovieCategry.upcoming.toString(), page: page);

  Future<Result<List<Movie>>> _getMovies(String category,
      {int page = 1}) async {
    try {
      final response = await _dio!.get(
        'https://api.themoviedb.org/3/movie/$category?language=en-US&page=$page',
        options: _options,
      );

      final result = List<Map<String, dynamic>>.from(response.data["results"]);

      return Result.success(result.map((e) => Movie.fromJSON(e)).toList());
    } on DioException catch (e) {
      return Result.failed("${e.message}");
    }
  }
}

enum _MovieCategry {
  nowPlaying("now_playing"),
  upcoming("upcoming");

  final String _inString;

  const _MovieCategry(String instring) : _inString = instring;

  @override
  String toString() => _inString;
}
