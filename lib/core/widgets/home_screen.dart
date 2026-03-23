import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:annivet/core/constants/app_colors.dart';
import 'package:annivet/features/auth/presentation/providers/auth_providers.dart';
import 'package:annivet/features/feed/presentation/providers/feed_providers.dart';
import 'package:annivet/features/feed/presentation/widgets/feed_card.dart';
import 'package:annivet/features/feed/domain/entities/feed_post.dart';
import 'package:annivet/core/widgets/loading_indicator.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _headerController;
  late AnimationController _cardsController;
  late Animation<double> _headerFade;
  late Animation<Offset> _headerSlide;
  late Animation<double> _cardsFade;
  late Animation<Offset> _cardsSlide;
  final ScrollController _scrollController = ScrollController();
  bool _isCollapsed = false;

  @override
  void initState() {
    super.initState();
    _headerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _cardsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _headerFade =
        CurvedAnimation(parent: _headerController, curve: Curves.easeIn);
    _headerSlide = Tween<Offset>(begin: const Offset(0, -0.2), end: Offset.zero)
        .animate(CurvedAnimation(
            parent: _headerController, curve: Curves.easeOutCubic));
    _cardsFade =
        CurvedAnimation(parent: _cardsController, curve: Curves.easeIn);
    _cardsSlide = Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero)
        .animate(CurvedAnimation(
            parent: _cardsController, curve: Curves.easeOutCubic));

    _headerController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _cardsController.forward();
    });

    _scrollController.addListener(() {
      final isCollapsed = _scrollController.hasClients &&
          _scrollController.offset > (170 - kToolbarHeight);
      if (isCollapsed != _isCollapsed) {
        setState(() {
          _isCollapsed = isCollapsed;
        });
      }
    });
  }

  @override
  void dispose() {
    _headerController.dispose();
    _cardsController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final user = authState.user;
    final firstName = user?.name.split(' ').first ?? 'there';

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Sticky Gradient Header
          SliverAppBar(
            pinned: true,
            expandedHeight: 170,
            automaticallyImplyLeading: false,
            backgroundColor: const Color(0xFFF7F8FA),
            elevation: _isCollapsed ? 1 : 0,
            centerTitle: true,
            title: _isCollapsed
                ? Text(
                    'NEWS FEED',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryBlue,
                      letterSpacing: 1.2,
                    ),
                  )
                : null,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _isCollapsed
                        ? Colors.black.withOpacity(0.05)
                        : Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.notifications_outlined,
                    color: _isCollapsed ? AppColors.primaryBlue : Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: SlideTransition(
                position: _headerSlide,
                child: FadeTransition(
                  opacity: _headerFade,
                  child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFC2185B), Color(0xFF1A3558)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    child: SafeArea(
                      bottom: false,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 16, 24, 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Hello, $firstName! 🐾',
                                      style: GoogleFonts.poppins(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Keep your pets healthy & happy',
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        color: Colors.white.withOpacity(0.85),
                                      ),
                                    ),
                                  ],
                                ),
                                // Bell removed here because it's now in the actions
                                const SizedBox(width: 48),
                              ],
                            ),
                            const SizedBox(height: 24),
                            // Search bar
                            Container(
                              height: 48,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.95),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Row(
                                children: [
                                  const SizedBox(width: 14),
                                  Icon(Icons.search,
                                      color: AppColors.textSecondary,
                                      size: 20),
                                  const SizedBox(width: 10),
                                  Text(
                                    'Search services, products...',
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: SlideTransition(
              position: _cardsSlide,
              child: FadeTransition(
                opacity: _cardsFade,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 14),

                      // Services banner
                      _sectionTitle('Our Services'),
                      const SizedBox(height: 14),
                      SizedBox(
                        height: 130,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          children: [
                            _ServiceBanner(
                              icon: Icons.shopping_bag_outlined,
                              title: 'Pet Shop',
                              subtitle: 'Quality food & accessories',
                              gradient: const [
                                Color(0xFF5C6BC0),
                                Color(0xFF7986CB)
                              ],
                              onTap: () => context.push('/products'),
                            ),
                            const SizedBox(width: 14),
                            _ServiceBanner(
                              icon: Icons.newspaper_outlined,
                              title: 'Pet News',
                              subtitle: 'Tips & vet articles',
                              gradient: const [
                                Color(0xFF26A69A),
                                Color(0xFF4DB6AC)
                              ],
                              onTap: () => context.push('/feed'),
                            ),
                            const SizedBox(width: 14),
                            _ServiceBanner(
                              icon: Icons.hotel_outlined,
                              title: 'Boarding',
                              subtitle: 'Safe stays for your pets',
                              gradient: const [
                                Color(0xFFF4511E),
                                Color(0xFFFFB300)
                              ],
                              onTap: () => context.push('/boarding'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Clinic news feed
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _sectionTitle('Latest from Clinic'),
                          TextButton(
                            onPressed: () => context.push('/feed'),
                            child: Text(
                              'View All',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFFC2185B),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ref.watch(feedPostsProvider).when(
                            data: (posts) {
                              final displayPosts =
                                  posts.isEmpty ? _getDummyPosts() : posts;
                              return Column(
                                children: displayPosts
                                    .take(3)
                                    .map((post) => FeedCard(
                                          post: post,
                                          onTap: () =>
                                              context.push('/feed/${post.id}'),
                                        ))
                                    .toList(),
                              );
                            },
                            loading: () => const Center(
                              child: Padding(
                                padding: EdgeInsets.all(20),
                                child: LoadingIndicator(),
                              ),
                            ),
                            error: (error, _) {
                              final dummyPosts = _getDummyPosts();
                              return Column(
                                children: dummyPosts
                                    .take(3)
                                    .map((post) => FeedCard(
                                          post: post,
                                          onTap: () =>
                                              context.push('/feed/${post.id}'),
                                        ))
                                    .toList(),
                              );
                            },
                          ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<FeedPost> _getDummyPosts() {
    return [
      FeedPost(
        id: '1',
        title: 'New Clinic Hours! ⏰',
        content:
            'We are now open on Sundays from 9 AM to 1 PM for emergency checkups. Your pets\' health is our priority!',
        imageUrl:
            'https://images.unsplash.com/photo-1516733725897-1aa73b87c8e8?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      FeedPost(
        id: '2',
        title: 'Vaccination Drive 💉',
        content:
            'Bring your pets for a free rabies vaccination drive this Saturday. Keep them protected and happy!',
        imageUrl:
            'https://images.unsplash.com/photo-1628009368231-7bb7cfcb0def?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      FeedPost(
        id: '3',
        title: 'Pet Care Workshop 🐾',
        content:
            'Join our upcoming workshop on grooming and basic first aid for your beloved animal companions.',
        imageUrl:
            'https://images.unsplash.com/photo-1535268647677-300dbf3d78d1?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        updatedAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
    ];
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 17,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
    );
  }
}


class _ServiceBanner extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<Color> gradient;
  final VoidCallback onTap;

  const _ServiceBanner(
      {required this.icon,
      required this.title,
      required this.subtitle,
      required this.gradient,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: gradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: gradient.first.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 6)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: Colors.white, size: 22),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
                Text(subtitle,
                    style: GoogleFonts.poppins(
                        fontSize: 10, color: Colors.white.withOpacity(0.85)),
                    maxLines: 2),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

