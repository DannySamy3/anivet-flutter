import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:annivet/core/constants/app_enums.dart';
import 'package:annivet/core/theme/app_theme.dart';
import 'package:annivet/features/auth/presentation/providers/auth_providers.dart';
import 'package:annivet/features/auth/presentation/screens/login_screen.dart';
import 'package:annivet/features/auth/presentation/screens/register_screen.dart';
import 'package:annivet/features/auth/presentation/screens/splash_screen.dart';
import 'package:annivet/features/pet/routes.dart';
import 'package:annivet/features/products/routes.dart';
import 'package:annivet/features/orders/routes.dart';
import 'package:annivet/features/feed/presentation/screens/feed_list_screen.dart';
import 'package:annivet/features/feed/presentation/screens/feed_detail_screen.dart';
import 'package:annivet/features/more/presentation/screens/customer_more_screen.dart';
import 'package:annivet/features/boarding/routes.dart';
import 'package:annivet/features/settings/routes.dart';
import 'package:annivet/features/reminders/routes.dart';
import 'package:annivet/features/medical_records/routes.dart';
import 'package:annivet/core/widgets/home_screen.dart';
import 'package:annivet/core/widgets/owner_scaffold.dart';
import 'package:annivet/features/products/presentation/screens/admin_products_screen.dart';
import 'package:annivet/features/products/presentation/screens/product_form_screen.dart';
import 'package:annivet/features/feed/presentation/screens/admin_feed_screen.dart';
import 'package:annivet/features/feed/presentation/screens/feed_form_screen.dart';
import 'package:annivet/features/boarding/presentation/screens/admin_boardings_screen.dart';
import 'package:annivet/features/boarding/presentation/screens/boarding_detail_screen.dart';
import 'package:annivet/features/boarding/presentation/screens/request_boarding_screen.dart';
import 'package:annivet/features/orders/presentation/screens/admin_orders_screen.dart';
import 'package:annivet/features/orders/presentation/screens/order_detail_screen.dart';
import 'package:annivet/features/pet/presentation/screens/admin_pets_screen.dart';
import 'package:annivet/features/medical_records/presentation/screens/medical_records_screen.dart';
import 'package:annivet/features/medical_records/presentation/screens/medical_record_detail_screen.dart';
import 'package:annivet/features/settings/presentation/screens/settings_screen.dart';
import 'package:annivet/features/owner/presentation/screens/owner_dashboard_screen.dart';
import 'package:annivet/features/owner/presentation/screens/clinic_management_screen.dart';
import 'package:annivet/features/owner/presentation/screens/pricing_screen.dart';
import 'package:annivet/features/owner/presentation/screens/owner_profile_screen.dart';
import 'package:annivet/features/owner/presentation/screens/owner_more_screen.dart';
import 'package:annivet/features/customers/presentation/screens/customer_detail_screen.dart';
import 'package:annivet/features/owner/presentation/screens/customers_screen.dart';

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
    final notifier = RouterNotifier(ref);
    return GoRouter(
      initialLocation: '/splash',
      refreshListenable: notifier,
      redirect: (context, state) {
        final authState = ref.read(authStateProvider);
        final isAuthenticated = authState.user != null;
        final isAuthRoute = state.matchedLocation == '/login' ||
            state.matchedLocation == '/register' ||
            state.matchedLocation == '/splash';

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
        // Splash screen
        GoRoute(
          path: '/splash',
          builder: (context, state) => const SplashScreen(),
        ),
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
            GoRoute(
              path: '/more',
              builder: (context, state) => const CustomerMoreScreen(),
            ),
            ...petRoutes,
            ...productRoutes,
            ...orderRoutes,
            GoRoute(
              path: '/feed',
              builder: (context, state) => const FeedListScreen(),
            ),
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

        // Full-screen News Detail (outside shell to hide bottom nav)
        GoRoute(
          path: '/feed/:id',
          builder: (context, state) {
            final postId = state.pathParameters['id']!;
            return FeedDetailScreen(postId: postId);
          },
        ),

        // ── OWNER role shell ────────────────────────────────────────────────
        ShellRoute(
          builder: (context, state, child) {
            return OwnerScaffold(child: child);
          },
          routes: [
            // Owner Dashboard
            GoRoute(
              path: '/owner/dashboard',
              builder: (context, state) => const OwnerDashboardScreen(),
            ),

            // Clinic Management
            GoRoute(
              path: '/owner/clinic',
              builder: (context, state) => const ClinicManagementScreen(),
            ),

            // Pricing (OWNER ONLY)
            GoRoute(
              path: '/owner/pricing',
              builder: (context, state) => const PricingScreen(),
            ),

            // Owner Profile
            GoRoute(
              path: '/owner/profile',
              builder: (context, state) => const OwnerProfileScreen(),
            ),

            // Owner More Options
            GoRoute(
              path: '/owner/more',
              builder: (context, state) => const OwnerMoreScreen(),
            ),

            // Community Feed
            GoRoute(
              path: '/owner/feed',
              builder: (context, state) => const AdminFeedScreen(),
            ),

            // Customers Management
            GoRoute(
              path: '/owner/customers',
              builder: (context, state) => const CustomersScreen(),
            ),
            GoRoute(
              path: '/owner/customers/:id',
              builder: (context, state) {
                final id = state.pathParameters['id']!;
                return CustomerDetailScreen(customerId: id);
              },
            ),

            // Settings (reuse existing screen)
            GoRoute(
              path: '/owner/settings',
              builder: (context, state) => const SettingsScreen(),
            ),

            // Boarding management
            GoRoute(
              path: '/owner/boarding',
              builder: (context, state) => const AdminBoardingsScreen(),
            ),
            GoRoute(
              path: '/owner/boarding/:id',
              builder: (context, state) {
                final id = state.pathParameters['id']!;
                return BoardingDetailScreen(boardingId: id);
              },
            ),

            // Pets (all pets view)
            GoRoute(
              path: '/owner/pets',
              builder: (context, state) => const AdminPetsScreen(),
            ),

            // Products & Inventory
            GoRoute(
              path: '/owner/products',
              builder: (context, state) => const AdminProductsScreen(),
            ),
            GoRoute(
              path: '/owner/products/new',
              builder: (context, state) => const ProductFormScreen(),
            ),
            GoRoute(
              path: '/owner/products/:id/edit',
              builder: (context, state) {
                final id = state.pathParameters['id']!;
                return ProductFormScreen(productId: id);
              },
            ),

            // Orders
            GoRoute(
              path: '/owner/orders',
              builder: (context, state) => const AdminOrdersScreen(),
            ),
            GoRoute(
              path: '/owner/orders/:id',
              builder: (context, state) {
                final id = state.pathParameters['id']!;
                return OrderDetailScreen(orderId: id);
              },
            ),

            // Medical Records
            GoRoute(
              path: '/owner/medical-records',
              builder: (context, state) =>
                  const MedicalRecordsScreen(petId: ''),
            ),
            GoRoute(
              path: '/owner/medical-records/:id',
              builder: (context, state) {
                final id = state.pathParameters['id']!;
                return MedicalRecordDetailScreen(recordId: id);
              },
            ),
          ],
        ),
      ],
    );
  }

  String _getHomeRouteForRole(UserRole role) {
    switch (role) {
      case UserRole.owner:
        return '/owner/dashboard';
      case UserRole.customer:
        return '/home';
    }
  }
}

// Listens to auth state and notifies GoRouter to re-run redirect
class RouterNotifier extends ChangeNotifier {
  RouterNotifier(WidgetRef ref) {
    ref.listen(authStateProvider, (_, __) => notifyListeners());
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
    _NavItem(path: '/more', icon: Icons.more_horiz, label: 'More'),
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
