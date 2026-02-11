import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:annivet/features/products/domain/entities/product.dart';

class CartItem {
  final Product product;
  final int quantity;

  CartItem({required this.product, required this.quantity});

  double get total => product.price * quantity;
}

class CartState {
  final Map<String, CartItem> items;

  CartState({Map<String, CartItem>? items}) : items = items ?? {};

  double get total => items.values.fold(0, (sum, item) => sum + item.total);

  int get itemCount => items.values.fold(0, (sum, item) => sum + item.quantity);
}

class CartNotifier extends StateNotifier<CartState> {
  CartNotifier() : super(CartState());

  void addItem(Product product) {
    final currentItems = Map<String, CartItem>.from(state.items);

    if (currentItems.containsKey(product.id)) {
      final existingItem = currentItems[product.id]!;
      currentItems[product.id] = CartItem(
        product: product,
        quantity: existingItem.quantity + 1,
      );
    } else {
      currentItems[product.id] = CartItem(product: product, quantity: 1);
    }

    state = CartState(items: currentItems);
  }

  void removeItem(String productId) {
    final currentItems = Map<String, CartItem>.from(state.items);
    currentItems.remove(productId);
    state = CartState(items: currentItems);
  }

  void updateQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      removeItem(productId);
      return;
    }

    final currentItems = Map<String, CartItem>.from(state.items);
    if (currentItems.containsKey(productId)) {
      currentItems[productId] = CartItem(
        product: currentItems[productId]!.product,
        quantity: quantity,
      );
    }
    state = CartState(items: currentItems);
  }

  void clear() {
    state = CartState();
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  return CartNotifier();
});
