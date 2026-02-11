import 'package:go_router/go_router.dart';
import 'presentation/screens/product_catalog_screen.dart';
import 'presentation/screens/product_detail_screen.dart';

final productRoutes = [
  GoRoute(
    path: '/products',
    builder: (context, state) => const ProductCatalogScreen(),
  ),
  GoRoute(
    path: '/products/:id',
    builder: (context, state) {
      final productId = state.pathParameters['id']!;
      return ProductDetailScreen(productId: productId);
    },
  ),
];
