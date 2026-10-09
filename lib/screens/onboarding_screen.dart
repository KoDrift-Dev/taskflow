import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme.dart';
import '../widgets/logo_mark.dart';
import '../widgets/primary_button.dart';

/// First-run screen: brand mark, tagline, vector-style illustration, CTA.
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              const SizedBox(height: 48),
              const LogoMark(size: 64),
              const SizedBox(height: 18),
              const Text(
                'TaskFlow',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Manage tasks, achieve goals,\nbe more productive every day.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.5,
                  height: 1.55,
                  color: AppColors.grey,
                ),
              ),
              const SizedBox(height: 24),
              const Expanded(child: Center(child: _Illustration())),
              const SizedBox(height: 16),
              PrimaryButton(
                label: 'Get Started',
                icon: Icons.chevron_right_rounded,
                onPressed: () => context.go('/login'),
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account? ',
                    style: TextStyle(color: AppColors.grey, fontSize: 13.5),
                  ),
                  GestureDetector(
                    onTap: () => context.go('/login'),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }
}

/// Clean vector-style illustration built from shapes and icons (no assets).
class _Illustration extends StatelessWidget {
  const _Illustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 250,
            height: 210,
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: BorderRadius.circular(32),
            ),
          ),
          // Laptop
          Container(
            padding: const EdgeInsets.all(26),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                    color: Color(0x142F6BFF), blurRadius: 24, offset: Offset(0, 8))
              ],
            ),
            child: const Icon(Icons.laptop_mac_rounded,
                size: 64, color: AppColors.primary),
          ),
          // Floating checklist card
          Positioned(
            left: 8,
            top: 26,
            child: _floatCard(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  _MiniCheck(done: true, label: 'Design'),
                  SizedBox(height: 7),
                  _MiniCheck(done: true, label: 'Meeting'),
                  SizedBox(height: 7),
                  _MiniCheck(done: false, label: 'Report'),
                ],
              ),
            ),
          ),
          // Floating clock badge
          Positioned(
            right: 12,
            top: 40,
            child: _floatCard(
              padding: 12,
              child: const Icon(Icons.schedule_rounded,
                  size: 30, color: AppColors.primary),
            ),
          ),
          // Floating check badge
          Positioned(
            right: 34,
            bottom: 30,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Color(0xFF22C55E),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                      color: Color(0x4022C55E),
                      blurRadius: 14,
                      offset: Offset(0, 5))
                ],
              ),
              child: const Icon(Icons.check_rounded,
                  color: Colors.white, size: 22),
            ),
          ),
        ],
      ),
    );
  }

  Widget _floatCard({required Widget child, double padding = 14}) {
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
              color: Color(0x141B2340), blurRadius: 18, offset: Offset(0, 6))
        ],
      ),
      child: child,
    );
  }
}

class _MiniCheck extends StatelessWidget {
  const _MiniCheck({required this.done, required this.label});

  final bool done;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: done ? AppColors.primary : Colors.white,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
                color: done ? AppColors.primary : AppColors.line, width: 1.4),
          ),
          child: done
              ? const Icon(Icons.check_rounded, size: 11, color: Colors.white)
              : null,
        ),
        const SizedBox(width: 8),
        Container(
          width: 52,
          height: 8,
          decoration: BoxDecoration(
            color: done ? AppColors.line : AppColors.primarySoft,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }
}
