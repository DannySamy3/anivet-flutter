import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:annivet/core/constants/app_enums.dart';
import 'package:annivet/core/theme/app_theme.dart';
import 'package:annivet/features/auth/presentation/providers/auth_providers.dart';
import 'package:annivet/features/auth/presentation/screens/login_screen.dart';
import 'package:annivet/features/auth/presentation/screens/register_screen.dart';
import 'package:annivet/features/pet/routes.dart';
import 'package:annivet/features/products/routes.dart';
import 'package:annivet/features/orders/routes.dart';
import 'package:annivet/features/feed/routes.dart';
import 'package:annivet/features/boarding/routes.dart';
import 'package:annivet/features/settings/routes.dart';
import 'package:annivet/features/reminders/routes.dart';
import 'package:annivet/features/medical_records/routes.dart';
import 'package:annivet/core/widgets/home_screen.dart';
import 'package:annivet/features/products/presentation/screens/admin_products_screen.dart';
import 'package:annivet/features/products/presentation/screens/product_form_screen.dart';
import 'package:annivet/features/feed/presentation/screens/admin_feed_screen.dart';
import 'package:annivet/features/feed/presentation/screens/feed_form_screen.dart';
import 'package:annivet/features/boarding/presentation/screens/admin_boardings_screen.dart';
import 'package:annivet/features/boarding/presentation/screens/request_boarding_screen.dart';
import 'package:annivet/features/orders/presentation/screens/admin_orders_screen.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = _createRouter(ref);

    return ScreenUtilInit(
      designSize: const Size(375, 812), // iPhone 11 Pro size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: 'Anivet',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme(),
          darkTheme: AppTheme.darkTheme(),
          themeMode: ThemeMode.light, // TODO: Make this configurable
          routerConfig: router,
        );
      },
    );
  }

  GoRouter _createRouter(WidgetRef ref) {
    return GoRouter(
      initialLocation: '/login',
      redirect: (context, state) {
        final authState = ref.read(authStateProvider);
        final isAuthenticated = authState.user != null;
        final isAuthRoute = state.matchedLocation == '/login' ||
            state.matchedLocation == '/register';

        // Redirect to login if not authenticated and trying to access protected route
        if (!isAuthenticated && !isAuthRoute) {
          return '/login';
        }

        // Redirect to home if authenticated and trying to access auth routes
        if (isAuthenticated && isAuthRoute) {
          return _getHomeRouteForRole(authState.user!.role);
        }

        return null; // No redirect needed
      },
      routes: [
        // Auth routes
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterScreen(),
        ),

        // Main app shell with bottom navigation
        ShellRoute(
          builder: (context, state, child) {
            return MainScaffold(child: child);
          },
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
            ),
            ...petRoutes,
            ...productRoutes,
            ...orderRoutes,
            ...feedRoutes,
            ...boardingRoutes,
            ...settingsRoutes,
            ...reminderRoutes,
            ...medicalRecordRoutes,

            // Admin routes for products
            GoRoute(
              path: '/admin/products',
              builder: (context, state) => const AdminProductsScreen(),
            ),
            GoRoute(
              path: '/admin/products/new',
              builder: (context, state) => const ProductFormScreen(),
            ),
            GoRoute(
              path: '/admin/products/:id/edit',
              builder: (context, state) {
                final productId = state.pathParameters['id']!;
                return ProductFormScreen(productId: productId);
              },
            ),

            // Admin routes for feed
            GoRoute(
              path: '/admin/feed',
              builder: (context, state) => const AdminFeedScreen(),
            ),
            GoRoute(
              path: '/admin/feed/new',
              builder: (context, state) => const FeedFormScreen(),
            ),
            GoRoute(
              path: '/admin/feed/:id/edit',
              builder: (context, state) {
                final postId = state.pathParameters['id']!;
                return FeedFormScreen(postId: postId);
              },
            ),

            // Admin routes for boarding
            GoRoute(
              path: '/admin/boarding',
              builder: (context, state) => const AdminBoardingsScreen(),
            ),
            GoRoute(
              path: '/boarding/request',
              builder: (context, state) => const RequestBoardingScreen(),
            ),

            // Admin routes for orders
            GoRoute(
              path: '/admin/orders',
              builder: (context, state) => const AdminOrdersScreen(),
            ),
          ],
        ),
      ],
    );
  }

  String _getHomeRouteForRole(UserRole role) {
    // Both roles see the same home screen for now
    return '/home';
  }
}

// Main scaffold with bottom navigation
class MainScaffold extends ConsumerStatefulWidget {
  final Widget child;

  const MainScaffold({super.key, required this.child});

  @override
  ConsumerState<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends ConsumerState<MainScaffold> {
  int _selectedIndex = 0;

  final List<_NavItem> _navItems = const [
    _NavItem(path: '/home', icon: Icons.home, label: 'Home'),
    _NavItem(path: '/pets', icon: Icons.pets, label: 'Pets'),
    _NavItem(path: '/store', icon: Icons.store, label: 'Store'),
    _NavItem(path: '/boarding', icon: Icons.hotel, label: 'Boarding'),
    _NavItem(path: '/settings', icon: Icons.settings, label: 'Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          context.go(_navItems[index].path);
        },
        items: _navItems
            .map(
              (item) => BottomNavigationBarItem(
                icon: Icon(item.icon),
                label: item.label,
              ),
            )
            .toList(),
      ),
    );
  }
}

class _NavItem {
  final String path;
  final IconData icon;
  final String label;

  const _NavItem({required this.path, required this.icon, required this.label});
}
