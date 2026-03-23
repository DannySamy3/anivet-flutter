import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/feed_providers.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/feed_post.dart';
import 'package:google_fonts/google_fonts.dart';

class FeedDetailScreen extends ConsumerWidget {
  final String postId;

  const FeedDetailScreen({super.key, required this.postId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postQuery = ref.watch(postDetailProvider(postId));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Clinic News',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: AppColors.primaryBlue,
      ),
      body: postQuery.when(
        data: (post) => _buildPostContent(context, post),
        loading: () => const LoadingIndicator(),
        error: (error, stack) {
          final dummy = _getDummyPost(postId);
          return _buildPostContent(context, dummy);
        },
      ),
    );
  }

  Widget _buildPostContent(BuildContext context, FeedPost post) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post image with Hero animation
          if (post.imageUrl != null)
            Hero(
              tag: 'feed_image_${post.id}',
              child: CachedNetworkImage(
                imageUrl: post.imageUrl!,
                width: double.infinity,
                height: 280,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  height: 280,
                  color: AppColors.surfaceVariant,
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 280,
                  color: AppColors.surfaceVariant,
                  child: const Icon(Icons.image, size: 60),
                ),
              ),
            ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category/Tag placeholder
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFC2185B).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'CLINIC UPDATES',
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFFC2185B),
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Post title
                Text(
                  post.title,
                  style: GoogleFonts.poppins(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryBlue,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 16),

                // Author & Metadata Row
                Row(
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundColor:
                          AppColors.primaryGreen.withOpacity(0.2),
                      child: Icon(Icons.person,
                          size: 14, color: AppColors.primaryGreen),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Clinic Staff',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '•',
                      style: TextStyle(color: AppColors.textHint),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '2 min read',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Divider(color: AppColors.textHint.withOpacity(0.2)),
                const SizedBox(height: 20),

                // Post content
                Text(
                  post.content,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: AppColors.textPrimary,
                    height: 1.7,
                  ),
                ),

                const SizedBox(height: 24),
                // Additional dummy content for detailed view
                Text(
                  'What this means for you:',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryBlue,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'This update is part of our ongoing commitment to provide the best possible care for your pets. We understand that your schedule is busy, which is why we\'ve taken these steps to ensure you can reach us when you need us most.',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: AppColors.textPrimary.withOpacity(0.8),
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 24),
                
                // Call to action
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Have questions about this?',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryGreen,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Contact Clinic',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 60),
              ],
            ),
          ),
        ],
      ),
    );
  }

  FeedPost _getDummyPost(String id) {
    if (id == '1') {
      return FeedPost(
        id: '1',
        title: 'New Clinic Hours',
        content:
            'We are now open on Sundays from 9 AM to 1 PM for emergency checkups. Your pets\' health is our priority!',
        imageUrl:
            'https://images.unsplash.com/photo-1516733725897-1aa73b87c8e8?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
      );
    } else if (id == '2') {
      return FeedPost(
        id: '2',
        title: 'Vaccination Drive 💉',
        content:
            'Bring your pets for a free rabies vaccination drive this Saturday. Keep them protected and happy!',
        imageUrl:
            'https://images.unsplash.com/photo-1628009368231-7bb7cfcb0def?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      );
    }
    return FeedPost(
      id: '3',
      title: 'Pet Care Workshop 🐾',
      content:
          'Join our upcoming workshop on grooming and basic first aid for your beloved animal companions.',
      imageUrl:
          'https://images.unsplash.com/photo-1535268647677-300dbf3d78d1?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      updatedAt: DateTime.now().subtract(const Duration(days: 3)),
    );
  }

}
