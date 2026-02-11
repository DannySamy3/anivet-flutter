import 'package:go_router/go_router.dart';
import 'presentation/screens/feed_list_screen.dart';
import 'presentation/screens/feed_detail_screen.dart';

final feedRoutes = [
  GoRoute(
    path: '/feed',
    builder: (context, state) => const FeedListScreen(),
  ),
  GoRoute(
    path: '/feed/:id',
    builder: (context, state) {
      final postId = state.pathParameters['id']!;
      return FeedDetailScreen(postId: postId);
    },
  ),
];
