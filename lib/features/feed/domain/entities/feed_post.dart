import 'package:annivet/features/feed/data/dtos/feed_post_dto.dart';

class FeedPost {
  final String id;
  final String title;
  final String content;
  final String? imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  FeedPost({
    required this.id,
    required this.title,
    required this.content,
    this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FeedPost.fromDto(FeedPostDto dto) {
    return FeedPost(
      id: dto.id,
      title: dto.title,
      content: dto.content,
      imageUrl: dto.imageUrl,
      createdAt: dto.createdAt,
      updatedAt: dto.updatedAt,
    );
  }
}
