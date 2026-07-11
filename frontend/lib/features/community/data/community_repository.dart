import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:krishios/shared/models/community_post.dart';

class CommunityRepository {
  final FirebaseFirestore _firestore;

  CommunityRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<List<CommunityPost>> getPosts({String? category, int limit = 20}) {
    Query query = _firestore.collection('posts').orderBy('createdAt', descending: true);
    if (category != null && category != 'Trending') {
      query = query.where('category', isEqualTo: category);
    }
    return query.limit(limit).snapshots().map(
          (snapshot) => snapshot.docs.map((doc) => CommunityPost.fromFirestore(doc)).toList(),
        );
  }

  Future<void> createPost(CommunityPost post) async {
    await _firestore.collection('posts').add(post.toFirestore());
  }

  Future<void> toggleLike(String postId, bool isLiked) async {
    await _firestore.collection('posts').doc(postId).update({
      'likesCount': FieldValue.increment(isLiked ? -1 : 1),
    });
  }

  Stream<QuerySnapshot> getComments(String postId) {
    return _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .orderBy('createdAt', descending: false)
        .snapshots();
  }

  Future<void> addComment(String postId, String text, String authorId, String authorName) async {
    await _firestore.collection('posts').doc(postId).collection('comments').add({
      'text': text,
      'authorId': authorId,
      'authorName': authorName,
      'createdAt': FieldValue.serverTimestamp(),
    });
    await _firestore.collection('posts').doc(postId).update({
      'commentsCount': FieldValue.increment(1),
    });
  }

  Future<void> deletePost(String postId) async {
    await _firestore.collection('posts').doc(postId).delete();
  }

  Future<void> editPost(String postId, String title, String body) async {
    await _firestore.collection('posts').doc(postId).update({
      'title': title,
      'body': body,
    });
  }
}
