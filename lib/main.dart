import 'package:cinematix/firebase_options.dart';
import 'package:cinematix/presentation/providers/router/router_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(
    child: CinematixApp(),
  ));
}

class CinematixApp extends ConsumerWidget {
  const CinematixApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
        title: 'Cinematix',
        debugShowCheckedModeBanner: false,
        routeInformationParser:
            ref.watch(routerProvider).routeInformationParser,
        routeInformationProvider:
            ref.watch(routerProvider).routeInformationProvider,
        routerDelegate: ref.watch(routerProvider).routerDelegate);
  }
}
