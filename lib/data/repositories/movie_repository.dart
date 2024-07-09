import 'package:cinematix/domain/entities/actor.dart';
import 'package:cinematix/domain/entities/movie.dart';
import 'package:cinematix/domain/entities/movie_detail.dart';
import 'package:cinematix/domain/entities/result.dart';

abstract interface class MovieRepository {
  Future<Result<List<Movie>>> getNowPlaying({int page = 1});

  Future<Result<List<Movie>>> getUpcoming({int page = 1});

  Future<Result<MovieDetail>> getDetail({required int id});

  Future<Result<Actor>> getActors({required int id});
}
