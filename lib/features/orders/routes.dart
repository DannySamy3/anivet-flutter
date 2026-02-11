import 'package:go_router/go_router.dart';
import 'presentation/screens/cart_screen.dart';
import 'presentation/screens/my_orders_screen.dart';
import 'presentation/screens/order_detail_screen.dart';

final orderRoutes = [
  GoRoute(
    path: '/cart',
    builder: (context, state) => const CartScreen(),
  ),
  GoRoute(
    path: '/orders',
    builder: (context, state) => const MyOrdersScreen(),
  ),
  GoRoute(
    path: '/orders/:id',
    builder: (context, state) {
      final orderId = state.pathParameters['id']!;
      return OrderDetailScreen(orderId: orderId);
    },
  ),
];
