import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme.dart';
import '../widgets/logo_mark.dart';
import '../widgets/primary_button.dart';

/// Login screen — front-end only demo auth.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _login() => context.go('/home');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              const SizedBox(height: 56),
              const LogoMark(size: 60),
              const SizedBox(height: 18),
              const Text(
                'TaskFlow',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Login to Your Account',
                style: TextStyle(fontSize: 14, color: AppColors.grey),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'Email or username',
                  prefixIcon: Icon(Icons.person_outline_rounded,
                      color: AppColors.grey, size: 21),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _passCtrl,
                obscureText: _obscure,
                decoration: InputDecoration(
                  hintText: 'Password',
                  prefixIcon: const Icon(Icons.lock_outline_rounded,
                      color: AppColors.grey, size: 21),
                  suffixIcon: IconButton(
                    onPressed: () => setState(() => _obscure = !_obscure),
                    icon: Icon(
                      _obscure
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: AppColors.grey,
                      size: 21,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              PrimaryButton(label: 'Login', onPressed: _login),
              const SizedBox(height: 14),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Forgot password?',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              const Row(
                children: [
                  Expanded(child: Divider(color: AppColors.line)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14),
                    child: Text('or',
                        style:
                            TextStyle(color: AppColors.grey, fontSize: 13)),
                  ),
                  Expanded(child: Divider(color: AppColors.line)),
                ],
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: OutlinedButton(
                  onPressed: _login,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.ink,
                    side: const BorderSide(color: AppColors.line),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'G',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Continue with Google',
                        style: TextStyle(
                            fontSize: 14.5, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account? ",
                    style: TextStyle(color: AppColors.grey, fontSize: 13.5),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: const Text(
                      'Sign up',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
