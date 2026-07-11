import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:krishios/shared/providers/auth_provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/models/community_post.dart';
import '../providers/community_provider.dart';

class PostDetailScreen extends ConsumerStatefulWidget {
  final CommunityPost post;
  final bool isLiked;
  final VoidCallback onLike;

  const PostDetailScreen({
    super.key,
    required this.post,
    required this.isLiked,
    required this.onLike,
  });

  @override
  ConsumerState<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends ConsumerState<PostDetailScreen> {
  final TextEditingController _commentController = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submitComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    setState(() => _sending = true);
    _commentController.clear();

    try {
      final profile = ref.read(userProfileProvider).value;
      final user = FirebaseAuth.instance.currentUser;

      final authorId = profile?.uid ?? user?.uid ?? 'guest-user';
      final authorName = profile?.name ?? user?.displayName ?? 'Anonymous Farmer';

      await ref.read(communityRepositoryProvider).addComment(
            widget.post.id,
            text,
            authorId,
            authorName,
          );
      
      // Invalidate posts list to refresh comments count dynamically
      ref.invalidate(postsProvider);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to post comment: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final commentsAsync = ref.watch(commentsProvider(widget.post.id));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        surfaceTintColor: AppColors.surface,
        scrolledUnderElevation: 0,
        title: const Text('Post Discussion', style: AppTextStyles.labelMd),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Post Card details
                Container(
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
                            child: widget.post.authorAvatar != null
                                ? ClipOval(
                                    child: Image.network(
                                      widget.post.authorAvatar!,
                                      width: 40,
                                      height: 40,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Text(
                                    widget.post.authorName.isNotEmpty
                                        ? widget.post.authorName[0]
                                        : '?',
                                    style: AppTextStyles.labelMd,
                                  ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.post.authorName, style: AppTextStyles.labelMd),
                                Text(
                                  '${widget.post.authorRole} • ${Formatters.relativeTime(widget.post.createdAt)}',
                                  style: AppTextStyles.bodySm,
                                ),
                              ],
                            ),
                          ),
                          if (widget.post.isExpert)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.tertiaryContainer,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'Expert',
                                style: AppTextStyles.labelSm.copyWith(
                                    color: AppColors.onTertiaryContainer),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(widget.post.title,
                          style: AppTextStyles.labelMd.copyWith(
                              fontWeight: FontWeight.w600, fontSize: 16)),
                      const SizedBox(height: 8),
                      Text(widget.post.body, style: AppTextStyles.bodyMd),
                      if (widget.post.imageUrl != null) ...[
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            widget.post.imageUrl!,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: widget.onLike,
                            child: Row(
                              children: [
                                Icon(
                                  widget.isLiked
                                      ? Icons.thumb_up
                                      : Icons.thumb_up_outlined,
                                  size: 20,
                                  color: widget.isLiked
                                      ? AppColors.primary
                                      : AppColors.onSurfaceVariant,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${widget.post.likesCount}',
                                  style: AppTextStyles.labelSm.copyWith(
                                    color: widget.isLiked
                                        ? AppColors.primary
                                        : AppColors.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 24),
                          Row(
                            children: [
                              const Icon(Icons.chat_bubble_outline,
                                  size: 20, color: AppColors.onSurfaceVariant),
                              const SizedBox(width: 4),
                              Text('${widget.post.commentsCount}',
                                  style: AppTextStyles.labelSm),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Comments',
                  style: AppTextStyles.labelMd.copyWith(color: AppColors.primary),
                ),
                const SizedBox(height: 12),
                commentsAsync.when(
                  data: (comments) {
                    if (comments.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Center(
                          child: Text(
                            'No comments yet. Start the conversation!',
                            style: AppTextStyles.bodySm.copyWith(color: Colors.grey),
                          ),
                        ),
                      );
                    }
                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: comments.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (ctx, idx) {
                        final comment = comments[idx];
                        return Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerLowest,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.outlineVariant, width: 0.5),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    comment.authorName,
                                    style: AppTextStyles.labelSm.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const Spacer(),
                                  Text(
                                    Formatters.relativeTime(comment.createdAt),
                                    style: AppTextStyles.bodySm.copyWith(fontSize: 10, color: Colors.grey),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(comment.text, style: AppTextStyles.bodySm),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  loading: () => const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: CircularProgressIndicator(color: AppColors.primary),
                    ),
                  ),
                  error: (err, _) => Center(
                    child: Text('Error loading comments: $err', style: AppTextStyles.bodySm),
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: const InputDecoration(
                        hintText: 'Add a comment...',
                        border: InputBorder.none,
                      ),
                      maxLines: null,
                    ),
                  ),
                  IconButton(
                    icon: _sending
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                          )
                        : const Icon(Icons.send, color: AppColors.primary),
                    onPressed: _sending ? null : _submitComment,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
