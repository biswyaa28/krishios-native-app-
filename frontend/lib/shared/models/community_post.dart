import 'package:cloud_firestore/cloud_firestore.dart';

class CommunityPost {
  final String id;
  final String authorId;
  final String authorName;
  final String? authorAvatar;
  final String authorRole;
  final String title;
  final String body;
  final String category;
  final String? imageUrl;
  final int likesCount;
  final int commentsCount;
  final DateTime createdAt;
  final bool isExpert;

  CommunityPost({
    required this.id,
    required this.authorId,
    required this.authorName,
    this.authorAvatar,
    required this.authorRole,
    required this.title,
    required this.body,
    required this.category,
    this.imageUrl,
    this.likesCount = 0,
    this.commentsCount = 0,
    required this.createdAt,
    this.isExpert = false,
  });

  factory CommunityPost.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CommunityPost(
      id: doc.id,
      authorId: data['authorId'] ?? '',
      authorName: data['authorName'] ?? '',
      authorAvatar: data['authorAvatar'],
      authorRole: data['authorRole'] ?? 'Farmer',
      title: data['title'] ?? '',
      body: data['body'] ?? '',
      category: data['category'] ?? 'General',
      imageUrl: data['imageUrl'],
      likesCount: data['likesCount'] ?? 0,
      commentsCount: data['commentsCount'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isExpert: data['isExpert'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'authorId': authorId,
      'authorName': authorName,
      'authorAvatar': authorAvatar,
      'authorRole': authorRole,
      'title': title,
      'body': body,
      'category': category,
      'imageUrl': imageUrl,
      'likesCount': likesCount,
      'commentsCount': commentsCount,
      'createdAt': FieldValue.serverTimestamp(),
      'isExpert': isExpert,
    };
  }
}

class Comment {
  final String id;
  final String text;
  final String authorId;
  final String authorName;
  final DateTime createdAt;

  Comment({
    required this.id,
    required this.text,
    required this.authorId,
    required this.authorName,
    required this.createdAt,
  });
}
