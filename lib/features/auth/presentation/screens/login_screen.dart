import 'package:flutter/material.dart';
import 'package:flutter_experiment/features/auth/presentation/widgets/auth_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsetsGeometry.all(40),
        child: Column(
          mainAxisAlignment: .center,
          children: [
            const Text("Login"),
            AuthTextField(controller: _nameController, label: "Full Name"),
            AuthTextField(
              controller: _nameController,
              label: "Email",
              keyboardType: .emailAddress,
            ),
            AuthTextField(
              controller: _nameController,
              label: "Password",
              isPassword: true,
            ),
          ],
        ),
      ),
    );
  }
}
