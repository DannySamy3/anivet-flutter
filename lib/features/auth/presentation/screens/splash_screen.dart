import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:annivet/core/constants/app_colors.dart';
import 'package:annivet/features/auth/presentation/providers/auth_providers.dart';
import 'package:annivet/features/pet/presentation/providers/pet_providers.dart';
import 'package:annivet/features/products/presentation/providers/product_providers.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> with TickerProviderStateMixin {
  late final AnimationController _mainController;
  late final AnimationController _pulseController;
  late final AnimationController _progressController;
  
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _pulseAnimation;
  late final Animation<double> _progressAnimation;

  String _loadingMessage = 'authenticating clinic access...';

  @override
  void initState() {
    super.initState();
    
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat(reverse: true);

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.04).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOutSine,
      ),
    );

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _progressController,
        curve: Curves.linear,
      ),
    );

    _mainController.forward().then((_) => _progressController.forward());
    _initialize();
  }

  @override
  void dispose() {
    _mainController.dispose();
    _pulseController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  Future<void> _initialize() async {
    final startTime = DateTime.now();

    // Intentional pause for brand absorption
    await Future.delayed(const Duration(milliseconds: 1500));
    
    final authState = ref.read(authStateProvider);
    Future<void>? dataFetching;
    if (authState.user != null) {
      dataFetching = Future.wait([
        ref.read(myPetsProvider.future),
        ref.read(allProductsProvider.future),
      ]);
    }

    await Future.delayed(const Duration(milliseconds: 1500));
    if (mounted) setState(() => _loadingMessage = 'preparing personalized dashboard...');

    final elapsed = DateTime.now().difference(startTime);
    final remaining = const Duration(milliseconds: 4500) - elapsed;

    try {
      await Future.wait([
        if (dataFetching != null) dataFetching,
        if (remaining > Duration.zero) Future.delayed(remaining),
      ]);
    } catch (_) {}

    if (!mounted) return;

    if (authState.user != null) {
      final role = authState.user!.role.name;
      context.go(role == 'owner' ? '/owner/dashboard' : '/home');
    } else {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF030712), // Slate 950 base
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Dynamic Atmospheric Glow
          Center(
            child: Container(
              width: 500.w,
              height: 500.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.catColor.withOpacity(0.08),
                    AppColors.catColor.withOpacity(0.03),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.4, 1.0],
                ),
              ),
            ),
          ),
          
          SafeArea(
            child: Column(
              children: [
                const Spacer(flex: 3),
                
                // Floating Brand Identity
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Column(
                      children: [
                        // Natural Floating Logo
                        ScaleTransition(
                          scale: _pulseAnimation,
                          child: SizedBox(
                            width: 220.w,
                            height: 120.h,
                            child: Image.asset(
                              'assets/images/app_logo.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        
                        SizedBox(height: 32.h),
                        
                        // Refined Brand Text
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40.w),
                          child: Column(
                            children: [
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: GoogleFonts.outfit(
                                    fontSize: 28.sp,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.5,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'ANIVET',
                                      style: TextStyle(color: AppColors.catColor),
                                    ),
                                    const TextSpan(
                                      text: ' CLINIC',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10.h),
                              Text(
                                'ANIMAL CARE PERSPECTIVE',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.outfit(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.brandOrange.withOpacity(0.8),
                                  letterSpacing: 6.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const Spacer(flex: 3),

                // Strategic Footer Loading
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      // Status Text
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 600),
                        child: Text(
                          _loadingMessage,
                          key: ValueKey(_loadingMessage),
                          style: GoogleFonts.outfit(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.white.withOpacity(0.35),
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                      
                      SizedBox(height: 20.h),
                      
                      // Minimalist Edge-to-Edge Progress
                      AnimatedBuilder(
                        animation: _progressAnimation,
                        builder: (context, child) {
                          return Container(
                            width: 120.w,
                            height: 1, // Ultra-thin line
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.05),
                            ),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: _progressAnimation.value,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.catColor.withOpacity(0.8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.catColor.withOpacity(0.2),
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      
                      SizedBox(height: 40.h),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
