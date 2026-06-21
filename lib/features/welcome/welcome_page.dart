import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/gradient_background.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../home/main_navigation_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const Spacer(),
                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.network(
                    'https://images.unsplash.com/photo-1446776877081-d282a0f896e2?w=800&q=80',
                    width: double.infinity,
                    height: 280,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Container(
                      width: double.infinity,
                      height: 280,
                      decoration: BoxDecoration(
                        color: AppColors.glass,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Icon(
                        Icons.image_outlined,
                        size: 64,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ),
                ).animate().fadeIn(duration: 600.ms).scale(begin: const Offset(0.9, 0.9)),
                const SizedBox(height: 40),
                const Text(
                  AppStrings.welcomeTitle,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: AppColors.white,
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(duration: 600.ms, delay: 200.ms).slideY(begin: 0.2),
                const SizedBox(height: 16),
                Text(
                  AppStrings.welcomeSubtitle,
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(duration: 600.ms, delay: 400.ms).slideY(begin: 0.2),
                const Spacer(),
                PrimaryButton(
                  text: AppStrings.exploreNews,
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const MainNavigationPage()),
                      (route) => false,
                    );
                  },
                  icon: Icons.rocket_launch_outlined,
                ).animate().fadeIn(duration: 600.ms, delay: 600.ms).slideY(begin: 0.2),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
