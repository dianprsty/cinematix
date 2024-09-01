import 'package:cinematix/domain/entities/movie.dart';
import 'package:cinematix/domain/entities/movie_detail.dart';
import 'package:cinematix/domain/entities/result.dart';
import 'package:cinematix/domain/usecases/get_movie_detail/get_movie_detail.dart';
import 'package:cinematix/domain/usecases/get_movie_detail/get_movie_detail_param.dart';
import 'package:cinematix/presentation/providers/usecases/get_movie_detail_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'movie_detail_provider.g.dart';

@riverpod
Future<MovieDetail?> movieDetail(MovieDetailRef ref,
    {required Movie movie}) async {
  GetMovieDetail getMovieDetail = ref.watch(getMovieDetailProvider);

  var result = await getMovieDetail(GetMovieDetailParam(movie: movie));
  return switch (result) {
    Success(value: final movieDetail) => movieDetail,
    Failed(message: final _) => null
  };
}
