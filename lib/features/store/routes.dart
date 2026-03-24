import 'package:go_router/go_router.dart';
import 'package:annivet/features/store/presentation/screens/store_screen.dart';
import 'package:annivet/features/store/presentation/screens/product_detail_screen.dart';

final storeRoutes = [
  GoRoute(
    path: '/store',
    name: 'store',
    builder: (context, state) => const StoreScreen(),
  ),
  GoRoute(
    path: '/store/:id',
    name: 'product-detail',
    builder: (context, state) {
      final productId = state.pathParameters['id']!;
      return ProductDetailScreen(productId: productId);
    },
  ),
];
