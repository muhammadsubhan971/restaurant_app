import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';

import '../../core/constants/app_constants.dart';
import '../../domain/entities/restaurant.dart';
import '../../domain/repositories/restaurant_repository.dart';

class FirebaseRestaurantRepository implements RestaurantRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GeoFlutterFire _geo = GeoFlutterFire();

  @override
  Future<List<Restaurant>> getAllRestaurants() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(AppConstants.restaurantsCollection)
          .get();

      return snapshot.docs
          .map((doc) => Restaurant.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get all restaurants: $e');
    }
  }

  @override
  Future<List<Restaurant>> getApprovedRestaurants() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(AppConstants.restaurantsCollection)
          .where('isApproved', isEqualTo: true)
          .where('isActive', isEqualTo: true)
          .get();

      return snapshot.docs
          .map((doc) => Restaurant.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get approved restaurants: $e');
    }
  }

  @override
  Future<List<Restaurant>> getRestaurantsByOwner(String ownerId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(AppConstants.restaurantsCollection)
          .where('ownerId', isEqualTo: ownerId)
          .get();

      return snapshot.docs
          .map((doc) => Restaurant.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get restaurants by owner: $e');
    }
  }

  @override
  Future<List<Restaurant>> searchRestaurants(String query) async {
    try {
      // This is a simple text search - for production, consider using Firebase text search
      QuerySnapshot snapshot = await _firestore
          .collection(AppConstants.restaurantsCollection)
          .where('isApproved', isEqualTo: true)
          .where('isActive', isEqualTo: true)
          .get();

      final allRestaurants = snapshot.docs
          .map((doc) => Restaurant.fromFirestore(doc))
          .toList();

      final searchTerm = query.toLowerCase();
      return allRestaurants.where((restaurant) =>
          restaurant.name.toLowerCase().contains(searchTerm) ||
          restaurant.description.toLowerCase().contains(searchTerm) ||
          (restaurant.cuisineType?.toLowerCase().contains(searchTerm) ?? false) ||
          restaurant.categories.any((cat) => cat.toLowerCase().contains(searchTerm))
      ).toList();
    } catch (e) {
      throw Exception('Failed to search restaurants: $e');
    }
  }

  @override
  Future<List<Restaurant>> getRestaurantsByCategory(String category) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(AppConstants.restaurantsCollection)
          .where('categories', arrayContains: category)
          .where('isApproved', isEqualTo: true)
          .where('isActive', isEqualTo: true)
          .get();

      return snapshot.docs
          .map((doc) => Restaurant.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get restaurants by category: $e');
    }
  }

  @override
  Future<List<Restaurant>> getNearbyRestaurants(double latitude, double longitude, double radiusKm) async {
    try {
      // For nearby restaurants, we'll get all approved restaurants and filter by distance
      // In production, you'd want to use geohashing for better performance
      final allRestaurants = await getApprovedRestaurants();
      
      return allRestaurants.where((restaurant) {
        if (restaurant.latitude == null || restaurant.longitude == null) {
          return false;
        }
        
        final distance = _calculateDistance(
          latitude, longitude, 
          restaurant.latitude!, restaurant.longitude!
        );
        return distance <= radiusKm;
      }).toList();
    } catch (e) {
      throw Exception('Failed to get nearby restaurants: $e');
    }
  }

  @override
  Future<Restaurant?> getRestaurantById(String restaurantId) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection(AppConstants.restaurantsCollection)
          .doc(restaurantId)
          .get();

      if (doc.exists) {
        return Restaurant.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get restaurant by ID: $e');
    }
  }

  @override
  Future<bool> createRestaurant(Restaurant restaurant) async {
    try {
      await _firestore
          .collection(AppConstants.restaurantsCollection)
          .doc(restaurant.id)
          .set(restaurant.toFirestore());
      return true;
    } catch (e) {
      throw Exception('Failed to create restaurant: $e');
    }
  }

  @override
  Future<bool> updateRestaurant(Restaurant restaurant) async {
    try {
      await _firestore
          .collection(AppConstants.restaurantsCollection)
          .doc(restaurant.id)
          .update(restaurant.toFirestore());
      return true;
    } catch (e) {
      throw Exception('Failed to update restaurant: $e');
    }
  }

  @override
  Future<bool> deleteRestaurant(String restaurantId) async {
    try {
      await _firestore
          .collection(AppConstants.restaurantsCollection)
          .doc(restaurantId)
          .delete();
      return true;
    } catch (e) {
      throw Exception('Failed to delete restaurant: $e');
    }
  }

  @override
  Future<bool> approveRestaurant(String restaurantId) async {
    try {
      await _firestore
          .collection(AppConstants.restaurantsCollection)
          .doc(restaurantId)
          .update({
        'isApproved': true,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      throw Exception('Failed to approve restaurant: $e');
    }
  }

  @override
  Future<bool> suspendRestaurant(String restaurantId) async {
    try {
      await _firestore
          .collection(AppConstants.restaurantsCollection)
          .doc(restaurantId)
          .update({
        'isActive': false,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      throw Exception('Failed to suspend restaurant: $e');
    }
  }

  // Helper method to calculate distance between two coordinates
  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371; // Earth's radius in kilometers
    final dLat = _degreesToRadians(lat2 - lat1);
    final dLon = _degreesToRadians(lon2 - lon1);
    
    final a = 
      (Math.sin(dLat/2) * Math.sin(dLat/2)) +
      (Math.cos(_degreesToRadians(lat1)) * Math.cos(_degreesToRadians(lat2)) * 
       Math.sin(dLon/2) * Math.sin(dLon/2));
    
    final c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
    return R * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * (3.14159265358979323846 / 180);
  }
}