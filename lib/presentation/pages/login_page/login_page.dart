import 'package:cinematix/presentation/extensions/build_context_extension.dart';
import 'package:cinematix/presentation/misc/method.dart';
import 'package:cinematix/presentation/providers/router/router_provider.dart';
import 'package:cinematix/presentation/providers/user_data/user_data_provider.dart';
import 'package:cinematix/presentation/widgets/cinematix_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(userDataProvider, (previous, next) {
      if (next is AsyncData) {
        if (next.value != null) {
          ref.read(routerProvider).goNamed('main');
        }
      } else if (next is AsyncError) {
        context.showSnackBar(next.error.toString());
      }
    });

    return Scaffold(
      body: ListView(
        children: [
          verticalSpace(100),
          Center(
            child: Image.asset(
              'assets/images/cinematix_wide.png',
              width: 250,
            ),
          ),
          verticalSpace(72),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  CinematixTextField(
                    controller: _emailController,
                    labelText: 'Email',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Email harus diisi';
                      }
                      return null;
                    },
                  ),
                  verticalSpace(24),
                  CinematixTextField(
                    controller: _passwordController,
                    labelText: 'Password',
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Password harus diisi';
                      }
                      return null;
                    },
                  ),
                  verticalSpace(24),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text('Forgot Password?'),
                    ),
                  ),
                  verticalSpace(24),
                  switch (ref.watch(userDataProvider)) {
                    AsyncData(:final value) => value == null
                        ? SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  ref.read(userDataProvider.notifier).login(
                                        email: _emailController.text,
                                        password: _passwordController.text,
                                      );
                                }
                              },
                              child: const Text('Login'),
                            ),
                          )
                        : const CircularProgressIndicator(),
                    _ => const Center(
                        child: CircularProgressIndicator(),
                      ),
                  },
                  verticalSpace(24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Don\'t have an account?'),
                      TextButton(
                        onPressed: () {
                          ref.read(routerProvider).goNamed('register');
                        },
                        child: const Text('Register Here'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
