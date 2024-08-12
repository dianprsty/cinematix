enum MovieListCategory { nowPlaying, upcoming }

class GetMovieListParam {
  final MovieListCategory category;
  final int page;
  const GetMovieListParam({required this.category, this.page = 1});
}
