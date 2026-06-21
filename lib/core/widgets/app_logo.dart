import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final bool showText;

  const AppLogo({super.key, this.size = 80, this.showText = true});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: AppColors.primaryGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.cyan.withValues(alpha: 0.3),
                blurRadius: 30,
                spreadRadius: 5,
              ),
              BoxShadow(
                color: AppColors.violet.withValues(alpha: 0.2),
                blurRadius: 60,
                spreadRadius: 10,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(size / 2),
            child: Image.asset(
              'assets/images/ecommerce.jpg',
              width: size,
              height: size,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => const Icon(
                Icons.public,
                size: 40,
                color: AppColors.white,
              ),
            ),
          ),
        ),
        if (showText) ...[
          const SizedBox(height: 16),
          Text(
            'SpaceNews',
            style: TextStyle(
              fontSize: size * 0.35,
              fontWeight: FontWeight.w800,
              color: AppColors.white,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'CORE',
            style: TextStyle(
              fontSize: size * 0.18,
              fontWeight: FontWeight.w400,
              color: AppColors.cyan,
              letterSpacing: 6,
            ),
          ),
        ],
      ],
    );
  }
}
