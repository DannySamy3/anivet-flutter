import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/product_providers.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../core/widgets/app_error_widget.dart';
import '../widgets/product_card.dart';

class ProductCatalogScreen extends ConsumerWidget {
  const ProductCatalogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsQuery = ref.watch(allProductsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            icon: const Badge(
              label: Text('0'),
              child: Icon(Icons.shopping_cart),
            ),
            onPressed: () => context.push('/cart'),
          ),
        ],
      ),
      body: productsQuery.when(
        data: (products) {
          if (products.isEmpty) {
            return const Center(child: Text('No products available'));
          }

          return RefreshIndicator(
            onRefresh: () async => ref.refresh(allProductsProvider),
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                return ProductCard(
                  product: products[index],
                  onTap: () => context.push('/products/${products[index].id}'),
                );
              },
            ),
          );
        },
        loading: () => const LoadingIndicator(),
        error: (error, stack) => AppErrorWidget(
          message: error.toString(),
          onRetry: () => ref.refresh(allProductsProvider),
        ),
      ),
    );
  }
}
