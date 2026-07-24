import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:krishios/shared/models/community_post.dart';
import '../../data/community_repository.dart';

final communityRepositoryProvider = Provider<CommunityRepository>((ref) {
  return CommunityRepository();
});

final selectedCategoryProvider = StateProvider<String>((ref) => 'Trending');

final postsProvider = StreamProvider<List<CommunityPost>>((ref) {
  final repo = ref.watch(communityRepositoryProvider);
  final category = ref.watch(selectedCategoryProvider);
  return repo.getPosts(category: category);
});

final likedPostsProvider = StateProvider<Set<String>>((ref) => {});

final commentsProvider = StreamProvider.family<List<Comment>, String>((ref, postId) {
  final repo = ref.watch(communityRepositoryProvider);
  return repo.getComments(postId).map((snapshot) {
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return Comment(
        id: doc.id,
        text: data['text'] ?? '',
        authorId: data['authorId'] ?? '',
        authorName: data['authorName'] ?? '',
        createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      );
    }).toList();
  });
});
