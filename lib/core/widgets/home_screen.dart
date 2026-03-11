import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:annivet/core/constants/app_colors.dart';
import 'package:annivet/features/auth/presentation/providers/auth_providers.dart';

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
  }

  @override
  void dispose() {
    _headerController.dispose();
    _cardsController.dispose();
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
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Gradient Header
          SliverToBoxAdapter(
            child: SlideTransition(
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
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(36),
                      bottomRight: Radius.circular(36),
                    ),
                  ),
                  child: SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
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
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.notifications_outlined,
                                    color: Colors.white, size: 24),
                              ),
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
                                    color: AppColors.textSecondary, size: 20),
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
                      // Quick Actions
                      _sectionTitle('Quick Actions'),
                      const SizedBox(height: 14),
                      GridView.count(
                        crossAxisCount: 4,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.78,
                        children: [
                          _QuickAction(
                              icon: Icons.pets,
                              label: 'My Pets',
                              color: const Color(0xFF5C6BC0),
                              onTap: () => context.push('/pets')),
                          _QuickAction(
                              icon: Icons.medical_services_outlined,
                              label: 'Records',
                              color: const Color(0xFF26A69A),
                              onTap: () => context.push('/medical-records')),
                          _QuickAction(
                              icon: Icons.hotel_outlined,
                              label: 'Boarding',
                              color: const Color(0xFFF4511E),
                              onTap: () => context.push('/boarding')),
                          _QuickAction(
                              icon: Icons.alarm_outlined,
                              label: 'Reminders',
                              color: const Color(0xFFFFB300),
                              onTap: () => context.push('/reminders')),
                        ],
                      ),
                      const SizedBox(height: 24),

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

                      // Pet care tips
                      _sectionTitle('Pet Care Tips'),
                      const SizedBox(height: 14),
                      _TipCard(
                        icon: Icons.water_drop_outlined,
                        iconColor: const Color(0xFF29B6F6),
                        title: 'Hydration Matters',
                        body:
                            'Ensure fresh water is always available. Dogs need ~30ml per kg of body weight daily.',
                      ),
                      const SizedBox(height: 12),
                      _TipCard(
                        icon: Icons.directions_run,
                        iconColor: const Color(0xFFF4511E),
                        title: 'Daily Exercise',
                        body:
                            'Regular walks and playtime keep pets physically and mentally healthy.',
                      ),
                      const SizedBox(height: 12),
                      _TipCard(
                        icon: Icons.vaccines_outlined,
                        iconColor: const Color(0xFF26A69A),
                        title: 'Stay Up-to-Date on Vaccines',
                        body:
                            'Annual checkups and vaccinations prevent serious diseases and extend your pet\'s lifespan.',
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

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickAction(
      {required this.icon,
      required this.label,
      required this.color,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              height: 1.2,
            ),
          ),
        ],
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

class _TipCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String body;

  const _TipCard(
      {required this.icon,
      required this.iconColor,
      required this.title,
      required this.body});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary)),
                const SizedBox(height: 4),
                Text(body,
                    style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
