import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/constants/app_constants.dart';
import '../../domain/entities/restaurant.dart';

class FavoritesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Add restaurant to favorites
  Future<bool> addToFavorites(String restaurantId) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return false;

      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .collection('favorites')
          .doc(restaurantId)
          .set({
        'restaurantId': restaurantId,
        'userId': userId,
        'addedAt': FieldValue.serverTimestamp(),
      });
      
      return true;
    } catch (e) {
      return false;
    }
  }

  // Remove restaurant from favorites
  Future<bool> removeFromFavorites(String restaurantId) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return false;

      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .collection('favorites')
          .doc(restaurantId)
          .delete();
      
      return true;
    } catch (e) {
      return false;
    }
  }

  // Check if restaurant is in favorites
  Future<bool> isFavorite(String restaurantId) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return false;

      final doc = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .collection('favorites')
          .doc(restaurantId)
          .get();
      
      return doc.exists;
    } catch (e) {
      return false;
    }
  }

  // Get all favorite restaurants
  Future<List<String>> getFavoriteRestaurantIds() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return [];

      final snapshot = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .collection('favorites')
          .get();
      
      return snapshot.docs.map((doc) => doc.id).toList();
    } catch (e) {
      return [];
    }
  }

  // Get favorite restaurants with full data
  Future<List<Restaurant>> getFavoriteRestaurants() async {
    try {
      final favoriteIds = await getFavoriteRestaurantIds();
      if (favoriteIds.isEmpty) return [];

      final restaurants = <Restaurant>[];
      
      for (String id in favoriteIds) {
        final doc = await _firestore
            .collection(AppConstants.restaurantsCollection)
            .doc(id)
            .get();
        
        if (doc.exists) {
          restaurants.add(Restaurant.fromFirestore(doc));
        }
      }
      
      return restaurants;
    } catch (e) {
      return [];
    }
  }
}