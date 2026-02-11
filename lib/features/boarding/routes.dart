import 'package:go_router/go_router.dart';
import 'presentation/screens/my_boardings_screen.dart';
import 'presentation/screens/boarding_detail_screen.dart';

final boardingRoutes = [
  GoRoute(
    path: '/boarding',
    builder: (context, state) => const MyBoardingsScreen(),
  ),
  GoRoute(
    path: '/boarding/:id',
    builder: (context, state) {
      final boardingId = state.pathParameters['id']!;
      return BoardingDetailScreen(boardingId: boardingId);
    },
  ),
];
