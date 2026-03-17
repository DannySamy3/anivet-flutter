import 'package:annivet/core/services/api_service.dart';
import '../models/customer_model.dart';
import '../../domain/entities/customer.dart';

class CustomerRepository {
  final ApiService _apiService;

  CustomerRepository(this._apiService);

  Future<List<Customer>> getCustomers({int page = 1, int limit = 20}) async {
    try {
      final response = await _apiService.get(
        '/customers',
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );
      if (response.data['success'] == true) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => CustomerModel.fromJson(json)).toList();
      } else {
        throw Exception(response.data['message'] ?? 'Failed to fetch customers');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Customer> getCustomerById(String id) async {
    try {
      final response = await _apiService.get('/customers/$id');

      if (response.data['success'] == true) {
        return CustomerModel.fromJson(response.data['data']);
      } else {
        throw Exception(
            response.data['message'] ?? 'Failed to fetch customer details');
      }
    } catch (e) {
      rethrow;
    }
  }
}
