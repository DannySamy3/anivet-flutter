import '../../../../core/services/api_service.dart';
import '../dtos/feed_post_dto.dart';
import '../../domain/entities/feed_post.dart';

class FeedRepository {
  final ApiService _apiService;

  FeedRepository(this._apiService);

  // GET /api/feed - Browse posts with pagination
  Future<List<FeedPost>> getFeedPosts({int page = 1, int limit = 10}) async {
    final response = await _apiService.get(
      '/feed',
      queryParameters: {'page': page, 'limit': limit},
    );
    final List<dynamic> data = response.data as List<dynamic>;
    return data
        .map((json) => FeedPost.fromDto(FeedPostDto.fromJson(json)))
        .toList();
  }

  // GET /api/feed/:id - Get post by ID
  Future<FeedPost> getPostById(String postId) async {
    final response = await _apiService.get('/feed/$postId');
    return FeedPost.fromDto(FeedPostDto.fromJson(response.data));
  }

  // POST /api/feed - Create post (admin)
  Future<FeedPost> createPost(Map<String, dynamic> postData) async {
    final response = await _apiService.post('/feed', data: postData);
    return FeedPost.fromDto(FeedPostDto.fromJson(response.data));
  }

  // PUT /api/feed/:id - Update post (admin)
  Future<FeedPost> updatePost(
      String postId, Map<String, dynamic> postData) async {
    final response = await _apiService.put('/feed/$postId', data: postData);
    return FeedPost.fromDto(FeedPostDto.fromJson(response.data));
  }

  // DELETE /api/feed/:id - Delete post (admin)
  Future<void> deletePost(String postId) async {
    await _apiService.delete('/feed/$postId');
  }
}
