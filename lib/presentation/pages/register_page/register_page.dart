import 'package:cinematix/presentation/extensions/build_context_extension.dart';
import 'package:cinematix/presentation/misc/method.dart';
import 'package:cinematix/presentation/providers/router/router_provider.dart';
import 'package:cinematix/presentation/providers/user_data/user_data_provider.dart';
import 'package:cinematix/presentation/widgets/cinematix_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController retypePasswordController =
      TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    retypePasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(userDataProvider, (previous, next) {
      if (next is AsyncData && next.value != null) {
        ref.read(routerProvider).goNamed('main');
      } else if (next is AsyncError) {
        context.showSnackBar(next.error.toString());
      }
    });
    return Scaffold(
      body: ListView(
        children: [
          Column(
            children: [
              verticalSpace(50),
              Center(
                child: Image.asset(
                  'assets/images/cinematix_wide.png',
                  width: 250,
                ),
              ),
              verticalSpace(50),
              const CircleAvatar(
                radius: 50,
                child: Icon(
                  Icons.add_a_photo,
                  color: Colors.white,
                  size: 50,
                ),
              ),
              verticalSpace(24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  child: Column(
                    children: [
                      CinematixTextField(
                        labelText: 'Name',
                        controller: nameController,
                      ),
                      verticalSpace(24),
                      CinematixTextField(
                        labelText: 'Email',
                        controller: emailController,
                      ),
                      verticalSpace(24),
                      CinematixTextField(
                        labelText: 'Password   ',
                        controller: passwordController,
                        obscureText: true,
                      ),
                      verticalSpace(24),
                      CinematixTextField(
                        labelText: 'Retype Password',
                        controller: retypePasswordController,
                        obscureText: true,
                      ),
                      verticalSpace(24),
                      switch (ref.watch(userDataProvider)) {
                        AsyncData(:final value) => value == null
                            ? SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (passwordController.text ==
                                        retypePasswordController.text) {
                                      ref
                                          .read(userDataProvider.notifier)
                                          .register(
                                              email: emailController.text,
                                              password: passwordController.text,
                                              name: nameController.text);
                                    } else {
                                      context.showSnackBar(
                                          "Password and Retyped Password doesn't match");
                                    }
                                  },
                                  child: const Text('Register'),
                                ),
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              ),
                        _ => const Center(
                            child: CircularProgressIndicator(),
                          )
                      },
                      verticalSpace(24),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Already have an account?'),
                            TextButton(
                              onPressed: () {
                                ref.read(routerProvider).goNamed('login');
                              },
                              child: const Text('Login'),
                            ),
                          ])
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
