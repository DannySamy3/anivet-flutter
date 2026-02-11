import '../../../../core/services/api_service.dart';
import '../dtos/order_dto.dart';
import '../../domain/entities/order.dart';

class OrderRepository {
  final ApiService _apiService;

  OrderRepository(this._apiService);

  // POST /api/orders - Place order (customer)
  Future<Order> createOrder(List<Map<String, dynamic>> items) async {
    final response = await _apiService.post('/orders', data: {'items': items});
    return Order.fromDto(OrderDto.fromJson(response.data));
  }

  // GET /api/orders/me - Get my orders (customer)
  Future<List<Order>> getMyOrders() async {
    final response = await _apiService.get('/orders/me');
    final List<dynamic> data = response.data as List<dynamic>;
    return data.map((json) => Order.fromDto(OrderDto.fromJson(json))).toList();
  }

  // GET /api/orders/:id - Get order by ID
  Future<Order> getOrderById(String orderId) async {
    final response = await _apiService.get('/orders/$orderId');
    return Order.fromDto(OrderDto.fromJson(response.data));
  }

  // GET /api/orders - Get all orders (admin)
  Future<List<Order>> getAllOrders() async {
    final response = await _apiService.get('/orders');
    final List<dynamic> data = response.data as List<dynamic>;
    return data.map((json) => Order.fromDto(OrderDto.fromJson(json))).toList();
  }

  // PATCH /api/orders/:id/status - Update order status (admin)
  Future<Order> updateOrderStatus(String orderId, String status) async {
    final response = await _apiService.patch(
      '/orders/$orderId/status',
      data: {'status': status},
    );
    return Order.fromDto(OrderDto.fromJson(response.data));
  }
}
