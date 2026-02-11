import '../entities/restaurant.dart';

abstract class RestaurantRepository {
  Future<List<Restaurant>> getAllRestaurants();
  Future<List<Restaurant>> getApprovedRestaurants();
  Future<List<Restaurant>> getRestaurantsByOwner(String ownerId);
  Future<List<Restaurant>> searchRestaurants(String query);
  Future<List<Restaurant>> getRestaurantsByCategory(String category);
  Future<List<Restaurant>> getNearbyRestaurants(double latitude, double longitude, double radiusKm);
  Future<Restaurant?> getRestaurantById(String restaurantId);
  Future<bool> createRestaurant(Restaurant restaurant);
  Future<bool> updateRestaurant(Restaurant restaurant);
  Future<bool> deleteRestaurant(String restaurantId);
  Future<bool> approveRestaurant(String restaurantId);
  Future<bool> suspendRestaurant(String restaurantId);
}