import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:krishios/core/theme/app_theme.dart';
import 'package:krishios/core/utils/formatters.dart';
import 'package:krishios/shared/models/community_post.dart';
import 'package:krishios/shared/providers/auth_provider.dart';
import '../providers/community_provider.dart';

class PostCard extends ConsumerWidget {
  final CommunityPost post;
  final VoidCallback onTap;

  const PostCard({super.key, required this.post, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final likedPosts = ref.watch(likedPostsProvider);
    final isLiked = likedPosts.contains(post.id);
    final authState = ref.watch(authStateProvider);
    final currentUserId = authState.value?.uid ?? 'guest-user';
    final isAuthor = post.authorId == currentUserId;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.surfaceVariant),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.secondaryContainer,
                  child: post.authorAvatar != null
                      ? ClipOval(
                          child: Image.network(
                            post.authorAvatar!,
                            width: 40,
                            height: 40,
                          ),
                        )
                      : Text(
                          post.authorName.isNotEmpty
                              ? post.authorName[0]
                              : '?',
                          style: AppTextStyles.labelMd,
                        ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(post.authorName, style: AppTextStyles.labelMd),
                      Text(
                        '${post.authorRole} • ${Formatters.relativeTime(post.createdAt)}',
                        style: AppTextStyles.bodySm,
                      ),
                    ],
                  ),
                ),
                if (post.isExpert)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.tertiaryContainer,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Expert',
                      style: AppTextStyles.labelSm.copyWith(
                        color: AppColors.onTertiaryContainer,
                      ),
                    ),
                  ),
                if (isAuthor)
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, size: 20),
                    onSelected: (value) {
                      if (value == 'edit') {
                        _showEditPostDialog(context, ref);
                      } else if (value == 'delete') {
                        _confirmDelete(context, ref);
                      }
                    },
                    itemBuilder: (ctx) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Text('Edit Post'),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete Post'),
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              post.title,
              style: AppTextStyles.labelMd.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              post.body,
              style: AppTextStyles.bodyMd,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            if (post.imageUrl != null) ...[
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  post.imageUrl!,
                  height: 192,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                GestureDetector(
                  onTap: () async {
                    final notifier = ref.read(likedPostsProvider.notifier);
                    final previousState = notifier.state;
                    if (isLiked) {
                      notifier.state = notifier.state.difference({post.id});
                    } else {
                      notifier.state = notifier.state.union({post.id});
                    }
                    try {
                      await ref.read(communityRepositoryProvider).toggleLike(post.id, isLiked);
                    } catch (_) {
                      notifier.state = previousState;
                    }
                  },
                  child: Row(
                    children: [
                      Icon(
                        isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                        size: 20,
                        color: isLiked
                            ? AppColors.primary
                            : AppColors.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Text('${post.likesCount}', style: AppTextStyles.labelSm),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: onTap,
                  child: Row(
                    children: [
                       Icon(
                        Icons.chat_bubble_outline,
                        size: 20,
                        color: AppColors.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${post.commentsCount}',
                        style: AppTextStyles.labelSm,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showEditPostDialog(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController(text: post.title);
    final bodyController = TextEditingController(text: post.body);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Post'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: bodyController,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Body'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final title = titleController.text.trim();
              final body = bodyController.text.trim();
              if (title.isEmpty || body.isEmpty) return;
              Navigator.pop(ctx);
              await ref.read(communityRepositoryProvider).editPost(post.id, title, body);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Post'),
        content: const Text('Are you sure you want to delete this post?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await ref.read(communityRepositoryProvider).deletePost(post.id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: AppColors.onError,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
