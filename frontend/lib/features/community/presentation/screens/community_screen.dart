import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:krishios/shared/providers/auth_provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/models/community_post.dart';
import '../providers/community_provider.dart';
import '../widgets/community_post_card.dart';
import '../widgets/community_search_bar.dart';
import '../widgets/category_chips.dart';
import 'post_detail_screen.dart';
import 'package:krishios/shared/presentation/providers/language_provider.dart';
import 'package:krishios/shared/presentation/widgets/krishi_mobile_header.dart';
import 'package:krishios/shared/services/translation_service.dart';

class CommunityScreen extends ConsumerStatefulWidget {
  const CommunityScreen({super.key});

  @override
  ConsumerState<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends ConsumerState<CommunityScreen> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final List<String> _categories = [
    'Trending',
    'Rice Farmers',
    'Pest Control',
    'New Tech',
    'Soil Health',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;
    final postsAsync = ref.watch(postsProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final activeLang = ref.watch(languageProvider);

    return Stack(
      children: [
        ListView(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 100 + bottomInset),
          children: [
            KrishiMobileHeader(
              subtitle: TranslationService.translate('community_forum', activeLang),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  CommunitySearchBar(
                    controller: _searchController,
                    onChanged: (value) => setState(() => _searchQuery = value),
                  ),
                  const SizedBox(height: 16),
                  CategoryChips(
                    categories: _categories,
                    selected: selectedCategory,
                    onSelected: (cat) =>
                        ref.read(selectedCategoryProvider.notifier).state = cat,
                  ),
                  const SizedBox(height: 20),
                  postsAsync.when(
                    data: (posts) {
                      final filtered = _applySearch(posts);
                      if (filtered.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 48),
                          child: Center(
                            child: Column(
                              children: [
                                Icon(Icons.search_off,
                                    size: 48,
                                    color: AppColors.onSurfaceVariant
                                        .withValues(alpha: 0.5)),
                                const SizedBox(height: 12),
                                Text('No posts found',
                                    style: AppTextStyles.bodyMd.copyWith(
                                        color: AppColors.onSurfaceVariant)),
                              ],
                            ),
                          ),
                        );
                      }
                      return Column(
                        children: filtered
                            .map(
                              (post) => Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: PostCard(
                                  post: post,
                                  onTap: () => _openPostDetail(context, post),
                                ),
                              ),
                            )
                            .toList(),
                      );
                    },
                    loading: () => const Padding(
                      padding: EdgeInsets.only(top: 48),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (e, _) => Padding(
                      padding: const EdgeInsets.only(top: 48),
                      child: Center(
                        child: Text('Error loading posts: $e',
                            style: AppTextStyles.bodyMd
                                .copyWith(color: AppColors.error)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          bottom: 80 + bottomInset + 16,
          right: 16,
          child: SizedBox(
            width: 56,
            height: 56,
            child: FloatingActionButton(
              onPressed: () => _showCreatePost(context),
              backgroundColor: AppColors.primaryContainer,
              foregroundColor: AppColors.onPrimaryContainer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.edit, size: 28),
            ),
          ),
        ),
      ],
    );
  }

  List<CommunityPost> _applySearch(List<CommunityPost> posts) {
    if (_searchQuery.isEmpty) return posts;
    final query = _searchQuery.toLowerCase();
    return posts
        .where((p) =>
            p.title.toLowerCase().contains(query) ||
            p.body.toLowerCase().contains(query) ||
            p.authorName.toLowerCase().contains(query))
        .toList();
  }

  void _openPostDetail(BuildContext context, CommunityPost post) {
    final likedPosts = ref.read(likedPostsProvider);
    final isLiked = likedPosts.contains(post.id);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PostDetailScreen(
          post: post,
          isLiked: isLiked,
          onLike: () => ref
              .read(communityRepositoryProvider)
              .toggleLike(post.id, isLiked),
        ),
      ),
    );
  }

  void _showCreatePost(BuildContext context) {
    final titleController = TextEditingController();
    final bodyController = TextEditingController();
    String selectedCategory = _categories[0];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Create Post', style: AppTextStyles.headlineMd),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: selectedCategory,
              items: _categories
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (v) => selectedCategory = v ?? _categories[0],
              decoration: InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: 'Title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: bodyController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Share your thoughts...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  _addPost(
                    category: selectedCategory,
                    title: titleController.text,
                    body: bodyController.text,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text('Post'),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _addPost({
    required String category,
    required String title,
    required String body,
  }) {
    if (title.isEmpty || body.isEmpty) return;
    
    final profile = ref.read(userProfileProvider).value;
    final user = FirebaseAuth.instance.currentUser;
    
    final authorId = profile?.uid ?? user?.uid ?? 'guest-user';
    final authorName = profile?.name ?? user?.displayName ?? 'Farmer';
    final authorRole = profile?.role ?? 'Farmer';
    final authorAvatar = profile?.avatarUrl;

    final newPost = CommunityPost(
      id: '',
      authorId: authorId,
      authorName: authorName,
      authorRole: authorRole,
      authorAvatar: authorAvatar,
      title: title,
      body: body,
      category: category,
      createdAt: DateTime.now(),
    );
    unawaited(ref.read(communityRepositoryProvider).createPost(newPost));
  }
}
