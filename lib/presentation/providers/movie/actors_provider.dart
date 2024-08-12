import 'package:cinematix/domain/entities/actor.dart';
import 'package:cinematix/domain/entities/result.dart';
import 'package:cinematix/domain/usecases/get_actors/get_actors.dart';
import 'package:cinematix/domain/usecases/get_actors/get_actors_param.dart';
import 'package:cinematix/presentation/providers/usecases/get_actors_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'actors_provider.g.dart';

@riverpod
Future<List<Actor>> actors(ActorsRef ref, {required int movieId}) async {
  GetActors getActors = ref.read(getActorsProvider);

  final result = await getActors(GetActorsParam(movieId: movieId));

  return switch (result) {
    Success(value: final actors) => actors,
    Failed(message: final _) => []
  };
}
