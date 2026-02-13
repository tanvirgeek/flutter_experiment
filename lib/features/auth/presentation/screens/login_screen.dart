import 'package:flutter/material.dart';
import 'package:flutter_experiment/features/auth/presentation/core/Theme/theme_text_extension.dart';
import 'package:flutter_experiment/features/auth/presentation/core/validator/validators.dart';
import 'package:flutter_experiment/features/auth/presentation/widgets/auth_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      debugPrint("Login Success");
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Container(
              decoration: BoxDecoration(borderRadius: .circular(15)),
              child: Form(
                key: _formKey,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 300),
                  child: Column(
                    children: [
                      const Icon(Icons.auto_graph),
                      const SizedBox(height: 12),
                      Text("Welcome Back", style: context.headlinePrimary()),
                      const SizedBox(height: 4),
                      Text(
                        "Login To The App",
                        style: context.bodyLargeOnSurface(),
                      ),
                      const SizedBox(height: 12),
                      AuthTextField(
                        controller: _nameController,
                        label: "Full Name",
                        validator: Validators.fullName,
                      ),
                      const SizedBox(height: 12),
                      AuthTextField(
                        controller: _emailController,
                        label: "Email",
                        validator: Validators.email,
                      ),
                      const SizedBox(height: 12),
                      AuthTextField(
                        controller: _passwordController,
                        label: "Password",
                        isPassword: true,
                        validator: Validators.password,
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () {
                          _onSubmit();
                        },
                        child: const Text("Sign Up"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
