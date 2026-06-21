import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/loading_view.dart';
import '../../core/widgets/gradient_background.dart';
import '../../core/utils/date_formatter.dart';
import '../../data/models/article_model.dart';
import '../../data/models/favorite_model.dart';
import '../../data/services/auth_service.dart';
import '../../data/services/firestore_service.dart';
import '../detail/detail_page.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final firestoreService = FirestoreService();
    final userId = authService.currentUser?.uid;

    return GradientBackground(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'My Favorites',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Your saved space articles',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                ),
              ],
            ),
          ),
          if (userId == null)
            const Expanded(
              child: Center(
                child: Text(
                  'Please login to see favorites',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
            )
          else
            Expanded(
              child: StreamBuilder(
                stream: firestoreService.getUserFavorites(userId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const LoadingView(message: 'Loading favorites...');
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: const TextStyle(color: AppColors.error),
                      ),
                    );
                  }
                  final docs = snapshot.data?.docs ?? [];
                  if (docs.isEmpty) {
                    return const EmptyState(
                      icon: Icons.favorite_border,
                      title: AppStrings.noFavorites,
                      subtitle: AppStrings.noFavoritesSubtitle,
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final data = docs[index].data() as Map<String, dynamic>;
                      final favorite = FavoriteModel.fromMap(data);
                      final article = ArticleModel(
                        id: favorite.articleId,
                        title: favorite.title,
                        url: favorite.url,
                        imageUrl: favorite.imageUrl,
                        newsSite: favorite.newsSite,
                        summary: favorite.summary,
                        publishedAt: favorite.publishedAt,
                        updatedAt: favorite.publishedAt,
                      );
                      return _FavoriteCard(
                        favorite: favorite,
                        article: article,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => DetailPage(article: article)),
                          );
                        },
                        onDelete: () async {
                          await firestoreService.removeFavorite(favorite.favoriteId);
                        },
                      );
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _FavoriteCard extends StatelessWidget {
  final FavoriteModel favorite;
  final ArticleModel article;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _FavoriteCard({
    required this.favorite,
    required this.article,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.glass,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.glassStroke),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(20)),
              child: CachedNetworkImage(
                imageUrl: favorite.imageUrl,
                width: 120,
                height: 120,
                fit: BoxFit.cover,
                placeholder: (_, _) => Container(
                  width: 120,
                  height: 120,
                  color: AppColors.surface,
                  child: const Center(
                    child: CircularProgressIndicator(color: AppColors.cyan, strokeWidth: 2),
                  ),
                ),
                errorWidget: (_, _, _) => Container(
                  width: 120,
                  height: 120,
                  color: AppColors.surface,
                  child: const Icon(Icons.broken_image_outlined, color: AppColors.textTertiary),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      favorite.newsSite,
                      style: const TextStyle(
                        color: AppColors.violet,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      favorite.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(
                          DateFormatter.timeAgo(favorite.publishedAt),
                          style: const TextStyle(color: AppColors.textTertiary, fontSize: 11),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: onDelete,
                          child: const Icon(Icons.favorite, color: AppColors.favoriteRed, size: 20),
                        ),
                      ],
                    ),
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
