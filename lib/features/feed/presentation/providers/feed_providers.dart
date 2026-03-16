import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:annivet/features/feed/data/repositories/feed_repository.dart';
import 'package:annivet/features/feed/domain/entities/feed_post.dart';
import 'package:annivet/features/auth/presentation/providers/auth_providers.dart';

final feedRepositoryProvider = Provider<FeedRepository>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return FeedRepository(apiService);
});

// StateProvider for tracking current feed page
final feedPageProvider = StateProvider<int>((ref) => 1);

// FutureProvider: Get paginated feed posts
final feedPostsProvider =
    FutureProvider.autoDispose<List<FeedPost>>((ref) async {
  final repository = ref.watch(feedRepositoryProvider);
  final page = ref.watch(feedPageProvider);
  return repository.getFeedPosts(page: page, limit: 10);
});

// FutureProvider: Get post by ID
final postDetailProvider = FutureProvider.autoDispose.family<FeedPost, String>(
  (ref, postId) async {
    final repository = ref.watch(feedRepositoryProvider);
    return repository.getPostById(postId);
  },
);

// FutureProvider: Create post (admin)
final createPostProvider =
    FutureProvider.autoDispose.family<FeedPost, Map<String, dynamic>>(
  (ref, variables) async {
    final repository = ref.watch(feedRepositoryProvider);
    final post = await repository.createPost(variables);
    // Invalidate feed cache on success
    ref.invalidate(feedPostsProvider);
    return post;
  },
);

// FutureProvider: Update post (admin)
final updatePostProvider =
    FutureProvider.autoDispose.family<FeedPost, Map<String, dynamic>>(
  (ref, variables) async {
    final repository = ref.watch(feedRepositoryProvider);
    final postId = variables['id'] as String;
    final data = Map<String, dynamic>.from(variables);
    data.remove('id');
    final post = await repository.updatePost(postId, data);
    // Invalidate related cache on success
    ref.invalidate(postDetailProvider(postId));
    ref.invalidate(feedPostsProvider);
    return post;
  },
);

// FutureProvider: Delete post (admin)
final deletePostProvider = FutureProvider.autoDispose.family<void, String>(
  (ref, postId) async {
    final repository = ref.watch(feedRepositoryProvider);
    await repository.deletePost(postId);
    // Invalidate feed cache on success
    ref.invalidate(feedPostsProvider);
  },
);
