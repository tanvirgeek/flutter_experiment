import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_experiment/core/Theme/theme_text_extension.dart';
import 'package:flutter_experiment/core/validator/validators.dart';
import 'package:flutter_experiment/features/auth/presentation/screens/register_screen.dart';
import 'package:flutter_experiment/features/auth/presentation/widgets/auth_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loignFormKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  void _onLoginSubmit() {
    if (_loignFormKey.currentState!.validate()) {
      debugPrint("Login Success");
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsetsGeometry.all(32),
            child: Form(
              key: _loignFormKey,
              child: Column(
                mainAxisAlignment: .center,
                mainAxisSize: .min,
                children: [
                  Text("Login To Continue", style: context.headlinePrimary()),
                  const SizedBox(height: 24),
                  AuthTextField(
                    controller: _emailController,
                    label: "Email",
                    keyboardType: .emailAddress,
                    validator: Validators.email,
                  ),
                  const SizedBox(height: 24),
                  AuthTextField(
                    controller: _passwordController,
                    label: "Password",
                    isPassword: true,
                    validator: Validators.password,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      _onLoginSubmit();
                    },
                    child: const Text("Login"),
                  ),

                  const SizedBox(height: 24),

                  RichText(
                    text: TextSpan(
                      style: context.bodyLargeOnSurface(),
                      children: [
                        const TextSpan(text: "Don't have an account? "),
                        TextSpan(
                          text: "Register",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RegisterScreen(),
                                ),
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
