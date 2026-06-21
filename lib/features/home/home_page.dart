import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/widgets/loading_view.dart';
import '../../core/widgets/error_view.dart';
import '../../core/widgets/gradient_background.dart';
import '../../data/models/article_model.dart';
import '../../data/services/api_service.dart';
import '../../data/services/auth_service.dart';
import 'widgets/headline_banner.dart';
import 'widgets/news_card.dart';
import '../detail/detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService _apiService = ApiService();
  final AuthService _authService = AuthService();
  late Future<List<ArticleModel>> _articlesFuture;

  @override
  void initState() {
    super.initState();
    _articlesFuture = _apiService.fetchArticles();
  }

  void _refresh() {
    setState(() {
      _articlesFuture = _apiService.fetchArticles();
    });
  }

  void _openDetail(ArticleModel article) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DetailPage(article: article)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = _authService.currentUser;
    final displayName = user?.email?.split('@').first ?? 'Explorer';

    return GradientBackground(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello, ${displayName[0].toUpperCase()}${displayName.substring(1)}',
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    AppStrings.exploreHeadlines,
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: FutureBuilder<List<ArticleModel>>(
              future: _articlesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: 300,
                    child: LoadingView(message: 'Loading headlines...'),
                  );
                }
                if (snapshot.hasError) {
                  return SizedBox(
                    height: 300,
                    child: ErrorView(
                      message: AppStrings.errorLoading,
                      onRetry: _refresh,
                    ),
                  );
                }
                final articles = snapshot.data ?? [];
                if (articles.isEmpty) {
                  return const SizedBox(
                    height: 300,
                    child: Center(child: Text('No articles available', style: TextStyle(color: AppColors.textSecondary))),
                  );
                }
                return HeadlineBanner(
                  article: articles.first,
                  onTap: () => _openDetail(articles.first),
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
              child: Row(
                children: [
                  const Text(
                    'Latest News',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: _refresh,
                    child: const Row(
                      children: [
                        Icon(Icons.refresh, color: AppColors.cyan, size: 18),
                        SizedBox(width: 4),
                        Text(
                          'Refresh',
                          style: TextStyle(color: AppColors.cyan, fontSize: 13, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          FutureBuilder<List<ArticleModel>>(
            future: _articlesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SliverFillRemaining(
                  child: LoadingView(message: 'Loading articles...'),
                );
              }
              if (snapshot.hasError) {
                return SliverFillRemaining(
                  child: ErrorView(
                    message: AppStrings.errorLoading,
                    onRetry: _refresh,
                  ),
                );
              }
              final articles = snapshot.data ?? [];
              if (articles.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(child: Text('No articles found', style: TextStyle(color: AppColors.textSecondary))),
                );
              }
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index == 0) return const SizedBox.shrink();
                    final article = articles[index];
                    return NewsCard(
                      article: article,
                      index: index,
                      onTap: () => _openDetail(article),
                    );
                  },
                  childCount: articles.length,
                ),
              );
            },
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
        ],
      ),
    );
  }
}
