import 'package:flutter/material.dart';

import '../theme.dart';

/// Blue rounded-square brand mark with a white check.
class LogoMark extends StatelessWidget {
  const LogoMark({super.key, this.size = 56});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(size * 0.28),
        boxShadow: const [
          BoxShadow(
            color: Color(0x402F6BFF),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Icon(Icons.check_rounded, color: Colors.white, size: size * 0.52),
    );
  }
}
