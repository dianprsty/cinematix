import 'package:cinematix/presentation/misc/method.dart';
import 'package:cinematix/presentation/pages/movie_page/methods/movie_list.dart';
import 'package:cinematix/presentation/pages/movie_page/methods/promotion_list.dart';
import 'package:cinematix/presentation/pages/movie_page/methods/search_bar.dart';
import 'package:cinematix/presentation/pages/movie_page/methods/user_info.dart';
import 'package:cinematix/presentation/providers/movie/now_playing_provider.dart';
import 'package:cinematix/presentation/providers/movie/upcoming_provider.dart';
import 'package:cinematix/presentation/providers/router/router_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MoviePage extends ConsumerWidget {
  final List<String> promotionImageFileName = const [
    'popcorn.jpg',
    'buy1get1.jpg',
  ];

  const MoviePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            userInfo(ref),
            verticalSpace(40),
            searchBar(context),
            verticalSpace(20),
            ...movieList(
              title: 'NowPlaying',
              movies: ref.watch(nowPlayingProvider),
              onTap: (movie) {
                ref.read(routerProvider).pushNamed('detail', extra: movie);
              },
            ),
            verticalSpace(30),
            ...promotionList(promotionImageFileName),
            verticalSpace(30),
            ...movieList(
              title: 'Upcoming',
              movies: ref.watch(upcomingProvider),
            ),
            verticalSpace(100),
          ],
        )
      ],
    );
  }
}
