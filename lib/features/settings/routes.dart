import 'package:go_router/go_router.dart';
import 'presentation/screens/settings_screen.dart';
import 'presentation/screens/profile_screen.dart';

final settingsRoutes = [
  GoRoute(
    path: '/settings',
    builder: (context, state) => const SettingsScreen(),
  ),
  GoRoute(
    path: '/settings/profile',
    builder: (context, state) => const ProfileScreen(),
  ),
];
