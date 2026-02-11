class AppConstants {
  // App Information
  static const String appName = 'Local Rewards';
  static const String appVersion = '1.0.0';
  
  // Firebase Collections
  static const String usersCollection = 'users';
  static const String restaurantsCollection = 'restaurants';
  static const String menusCollection = 'menus';
  static const String ordersCollection = 'orders';
  static const String loyaltyTransactionsCollection = 'loyalty_transactions';
  static const String pointsBalancesCollection = 'points_balances';
  static const String notificationsCollection = 'notifications';
  
  // User Roles
  static const String roleCustomer = 'customer';
  static const String roleRestaurantOwner = 'restaurant_owner';
  static const String roleAdmin = 'admin';
  
  // Storage Paths
  static const String restaurantImagesPath = 'restaurant_images';
  static const String menuImagesPath = 'menu_images';
  static const String profileImagesPath = 'profile_images';
  
  // Default Values
  static const int defaultPointsPerDollar = 10;
  static const int minPointsForRedemption = 50;
  static const int maxPinLength = 6;
  static const int pinExpiryMinutes = 10;
  
  // Cache Keys
  static const String currentUserKey = 'current_user';
  static const String userRoleKey = 'user_role';
  static const String favoritesKey = 'favorites';
  
  // Notification Channels
  static const String orderChannelId = 'orders';
  static const String loyaltyChannelId = 'loyalty';
  static const String generalChannelId = 'general';
  
  // API Endpoints (if needed)
  static const String baseUrl = 'https://your-api-domain.com/api';
  
  // Pagination
  static const int defaultPageSize = 20;
  
  // Timeouts
  static const int networkTimeout = 30000; // 30 seconds
  static const int cacheTimeout = 300000; // 5 minutes
}