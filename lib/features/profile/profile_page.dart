import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/gradient_background.dart';
import '../../core/widgets/loading_view.dart';
import '../../data/services/auth_service.dart';
import '../../data/services/firestore_service.dart';
import '../../data/services/local_storage_service.dart';
import '../../data/models/user_model.dart';
import '../auth/register_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();
  final LocalStorageService _localStorageService = LocalStorageService();
  UserModel? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final uid = _authService.currentUser?.uid;
    if (uid == null) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }
    try {
      final user = await _firestoreService.getUser(uid);
      if (mounted) {
        setState(() {
          _user = user;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _logout() async {
    await _authService.signOut();
    await _localStorageService.clearSession();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const RegisterPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: _isLoading
          ? const LoadingView(message: 'Loading profile...')
          : _user == null
              ? const Center(
                  child: Text('User not found', style: TextStyle(color: AppColors.textSecondary)),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Center(
                        child: Column(
                          children: [
                            Container(
                              width: 100,
                              height: 100,
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
                                    blurRadius: 25,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: _user!.photoUrl.isNotEmpty
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: CachedNetworkImage(
                                        imageUrl: _user!.photoUrl,
                                        fit: BoxFit.cover,
                                        placeholder: (_, _) => const Center(
                                          child: CircularProgressIndicator(color: AppColors.cyan, strokeWidth: 2),
                                        ),
                                        errorWidget: (_, _, _) => const Icon(
                                          Icons.person,
                                          size: 48,
                                          color: AppColors.white,
                                        ),
                                      ),
                                    )
                                  : const Icon(Icons.person, size: 48, color: AppColors.white),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _user!.name,
                              style: const TextStyle(
                                color: AppColors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _user!.email,
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.glass,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.glassStroke),
                        ),
                        child: Column(
                          children: [
                            _ProfileInfoTile(
                              icon: Icons.person_outline,
                              label: 'Full Name',
                              value: _user!.name,
                            ),
                            const Divider(color: AppColors.glassStroke, height: 32),
                            _ProfileInfoTile(
                              icon: Icons.email_outlined,
                              label: 'Email',
                              value: _user!.email,
                            ),
                            const Divider(color: AppColors.glassStroke, height: 32),
                            _ProfileInfoTile(
                              icon: Icons.camera_alt_outlined,
                              label: 'Instagram',
                              value: _user!.instagram,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: PrimaryButton(
                          text: AppStrings.logout,
                          onPressed: _logout,
                          gradientStart: AppColors.error,
                          gradientEnd: AppColors.error.withValues(alpha: 0.7),
                          icon: Icons.logout_outlined,
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
    );
  }
}

class _ProfileInfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ProfileInfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.cyan.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.cyan, size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.textTertiary,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
