import '../entities/order.dart';

abstract class OrderRepository {
  Future<List<Order>> getOrdersByCustomer(String customerId);
  Future<List<Order>> getOrdersByRestaurant(String restaurantId);
  Future<List<Order>> getOrdersByStatus(String status);
  Future<Order?> getOrderById(String orderId);
  Future<bool> createOrder(Order order);
  Future<bool> updateOrderStatus(String orderId, String status);
  Future<bool> updateOrder(Order order);
  Future<bool> deleteOrder(String orderId);
  Future<List<Order>> getRecentOrders(String customerId, {int limit = 10});
  Future<double> getTotalSpentByCustomer(String customerId);
}