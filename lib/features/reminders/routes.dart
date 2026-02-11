import 'package:go_router/go_router.dart';
import 'presentation/screens/all_reminders_screen.dart';

final reminderRoutes = [
  GoRoute(
    path: '/reminders',
    builder: (context, state) => const AllRemindersScreen(),
  ),
];
