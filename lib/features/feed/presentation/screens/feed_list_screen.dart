import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/feed_providers.dart';
import '../widgets/feed_card.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../core/widgets/app_error_widget.dart';

class FeedListScreen extends ConsumerWidget {
  const FeedListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedQuery = ref.watch(feedPostsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Clinic Feed'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.refresh(feedPostsProvider),
          ),
        ],
      ),
      body: feedQuery.when(
        data: (posts) {
          if (posts.isEmpty) {
            return const Center(child: Text('No posts yet'));
          }

          return RefreshIndicator(
            onRefresh: () async => ref.refresh(feedPostsProvider),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return FeedCard(
                  post: post,
                  onTap: () => context.push('/feed/${post.id}'),
                );
              },
            ),
          );
        },
        loading: () => const LoadingIndicator(),
        error: (error, stack) => AppErrorWidget(
          message: error.toString(),
          onRetry: () => ref.refresh(feedPostsProvider),
        ),
      ),
    );
  }
}
