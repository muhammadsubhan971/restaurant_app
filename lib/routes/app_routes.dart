import 'package:flutter/material.dart';

import '../presentation/screens/account_selection_screen.dart';
import '../presentation/screens/splash_screen.dart';
import '../presentation/screens/customer_login_screen.dart';
import '../presentation/screens/customer_home_screen.dart';
import '../presentation/screens/restaurant_discovery_screen.dart';
import '../presentation/screens/loyalty_dashboard_screen.dart';
import '../presentation/screens/food_ordering_screen.dart';
import '../presentation/screens/pin_qr_scanner_screen.dart';
import '../presentation/screens/cart_screen.dart';
import '../presentation/screens/admin_panel_screen.dart';
import '../presentation/screens/restaurant_onboarding_screen.dart';
import '../presentation/screens/user_management_screen.dart';
import '../presentation/screens/transaction_history_screen.dart';
import '../presentation/screens/restaurant_owner_dashboard.dart';
import '../presentation/screens/settings_screen.dart';
import '../presentation/screens/profile_screen.dart';
import '../presentation/screens/restaurant_login_screen.dart';
import '../presentation/screens/admin_login_screen.dart';
import '../presentation/screens/restaurant_home_screen.dart';
import '../presentation/screens/admin_home_screen.dart';

class AppRoutes {
  // Route names
  static const String splash = '/';
  static const String accountSelection = '/account_selection';
  static const String customerLogin = '/customer_login';
  static const String restaurantLogin = '/restaurant_login';
  static const String adminLogin = '/admin_login';
  static const String customerHome = '/customer_home';
  static const String restaurantHome = '/restaurant_home';
  static const String adminHome = '/admin_home';
  static const String restaurantDiscovery = '/restaurant_discovery';
  static const String foodOrdering = '/food_ordering';
  static const String loyaltyDashboard = '/loyalty_dashboard';
  static const String profile = '/profile';
  static const String settings = '/settings';

  // Generate route based on route name
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final name = settings.name;
    
    if (name == splash) {
      return MaterialPageRoute(builder: (_) => const SplashScreen());
    } else if (name == accountSelection) {
      return MaterialPageRoute(builder: (_) => const AccountSelectionScreen());
    } else if (name == customerLogin) {
      return MaterialPageRoute(builder: (_) => const CustomerLoginScreen());
    } else if (name == restaurantLogin) {
      return MaterialPageRoute(builder: (_) => const RestaurantLoginScreen());
    } else if (name == adminLogin) {
      return MaterialPageRoute(builder: (_) => const AdminLoginScreen());
    } else if (name == customerHome) {
      return MaterialPageRoute(builder: (_) => const CustomerHomeScreen());
    } else if (name == restaurantHome) {
      return MaterialPageRoute(builder: (_) => const RestaurantHomeScreen());
    } else if (name == adminHome) {
      return MaterialPageRoute(builder: (_) => const AdminHomeScreen());
    } else if (name == restaurantDiscovery) {
      return MaterialPageRoute(builder: (_) => const RestaurantDiscoveryScreen());
    } else if (name == foodOrdering) {
      final args = settings.arguments as Map<String, dynamic>?;
      return MaterialPageRoute(
        builder: (_) => FoodOrderingScreen(
          restaurantName: args?['restaurantName'] ?? 'Restaurant',
          restaurantId: args?['restaurantId'] ?? '',
        ),
      );
    } else if (name == '/pin_qr_scanner') {
      final args = settings.arguments as Map<String, dynamic>?;
      return MaterialPageRoute(
        builder: (_) => PinQrScannerScreen(
          restaurantId: args?['restaurantId'] ?? '',
          restaurantName: args?['restaurantName'] ?? 'Restaurant',
          isRedemption: args?['isRedemption'] ?? false,
        ),
      );
    } else if (name == '/cart') {
      final args = settings.arguments as Map<String, dynamic>?;
      return MaterialPageRoute(
        builder: (_) => CartScreen(
          cartItems: args?['cartItems'] ?? [],
          itemQuantities: args?['itemQuantities'] ?? {},
          restaurantName: args?['restaurantName'] ?? 'Restaurant',
          restaurantId: args?['restaurantId'] ?? '',
        ),
      );
    } else if (name == loyaltyDashboard) {
      return MaterialPageRoute(builder: (_) => const LoyaltyDashboardScreen());
    } else if (name == '/transaction_history') {
      return MaterialPageRoute(builder: (_) => const TransactionHistoryScreen());
    } else if (name == '/restaurant_owner_dashboard') {
      return MaterialPageRoute(builder: (_) => const RestaurantOwnerDashboard());
    } else if (name == '/admin_panel') {
      return MaterialPageRoute(builder: (_) => const AdminPanelScreen());
    } else if (name == '/restaurant_onboarding') {
      return MaterialPageRoute(builder: (_) => const RestaurantOnboardingScreen());
    } else if (name == '/user_management') {
      return MaterialPageRoute(builder: (_) => const UserManagementScreen());
    } else if (name == settings) {
      return MaterialPageRoute(builder: (_) => const SettingsScreen());
    } else {
      final routeName = name ?? 'unknown';
      return MaterialPageRoute(
        builder: (_) => Scaffold(
          body: Center(
            child: Text('Route not found: $routeName'),
          ),
        ),
      );
    }
  
}
}