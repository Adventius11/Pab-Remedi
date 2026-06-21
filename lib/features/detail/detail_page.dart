import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/gradient_background.dart';
import '../../core/utils/date_formatter.dart';
import '../../data/models/article_model.dart';
import '../../data/models/favorite_model.dart';
import '../../data/services/auth_service.dart';
import '../../data/services/firestore_service.dart';

class DetailPage extends StatefulWidget {
  final ArticleModel article;

  const DetailPage({super.key, required this.article});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final FirestoreService _firestoreService = FirestoreService();
  final AuthService _authService = AuthService();
  bool _isFavorite = false;
  bool _isLoadingFavorite = true;

  FavoriteModel? _existingFavorite;

  String get _favoriteId =>
      '${_authService.currentUser?.uid ?? ''}_${widget.article.id}';

  @override
  void initState() {
    super.initState();
    _checkFavorite();
  }

  Future<void> _checkFavorite() async {
    final userId = _authService.currentUser?.uid;
    if (userId == null) {
      if (mounted) setState(() => _isLoadingFavorite = false);
      return;
    }

    try {
      final favorite = await _firestoreService.getFavorite(_favoriteId);
      if (mounted) {
        setState(() {
          _existingFavorite = favorite;
          _isFavorite = favorite != null;
          _isLoadingFavorite = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoadingFavorite = false);
    }
  }

  Future<void> _toggleFavorite() async {
    final userId = _authService.currentUser?.uid;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please login to use favorites')),
      );
      return;
    }

    try {
      if (_isFavorite && _existingFavorite != null) {
        await _firestoreService.removeFavorite(_favoriteId);
        if (mounted) {
          setState(() {
            _isFavorite = false;
            _existingFavorite = null;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Removed from Favorite')),
          );
        }
      } else {
        final favorite = FavoriteModel(
          favoriteId: _favoriteId,
          articleId: widget.article.id,
          title: widget.article.title,
          imageUrl: widget.article.imageUrl,
          newsSite: widget.article.newsSite,
          summary: widget.article.summary,
          url: widget.article.url,
          publishedAt: widget.article.publishedAt,
          userId: userId,
        );
        await _firestoreService.addFavorite(favorite);
        if (mounted) {
          setState(() {
            _isFavorite = true;
            _existingFavorite = favorite;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Added to Favorite')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 320,
              pinned: true,
              backgroundColor: AppColors.background,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: widget.article.imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (_, _) => Container(
                        color: AppColors.surface,
                        child: const Center(
                          child: CircularProgressIndicator(color: AppColors.cyan, strokeWidth: 2),
                        ),
                      ),
                      errorWidget: (_, _, _) => Container(
                        color: AppColors.surface,
                        child: const Icon(Icons.broken_image_outlined, color: AppColors.textTertiary, size: 48),
                      ),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Color(0xCC050816),
                            Color(0xFF050816),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              leading: IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.glass,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back, color: AppColors.white, size: 22),
                ),
                onPressed: () => Navigator.pop(context),
              ),
              actions: [
                _isLoadingFavorite
                    ? const Padding(
                        padding: EdgeInsets.all(16),
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(color: AppColors.cyan, strokeWidth: 2),
                        ),
                      )
                    : IconButton(
                        onPressed: _toggleFavorite,
                        icon: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.glass,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: _isFavorite ? AppColors.favoriteRed : AppColors.white,
                            size: 22,
                          ),
                        ),
                      ),
                const SizedBox(width: 8),
              ],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.violet.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        widget.article.newsSite,
                        style: const TextStyle(
                          color: AppColors.violet,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.article.title,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        height: 1.3,
                      ),
                    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.1),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.schedule, size: 16, color: AppColors.textSecondary),
                        const SizedBox(width: 6),
                        Text(
                          DateFormatter.formatDateFull(widget.article.publishedAt),
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.glass,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.glassStroke),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Summary',
                            style: TextStyle(
                              color: AppColors.cyan,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            widget.article.summary.isNotEmpty
                                ? widget.article.summary
                                : 'No summary available for this article.',
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 15,
                              height: 1.7,
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(duration: 500.ms, delay: 200.ms).slideY(begin: 0.1),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Link: ${widget.article.url}'),
                            ),
                          );
                        },
                        icon: const Icon(Icons.open_in_new, color: AppColors.cyan, size: 18),
                        label: const Text(
                          'Read Original Article',
                          style: TextStyle(color: AppColors.cyan),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: const BorderSide(color: AppColors.cyan, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
