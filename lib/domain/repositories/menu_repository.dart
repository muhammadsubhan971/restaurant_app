import '../entities/menu.dart';

abstract class MenuRepository {
  Future<List<MenuItem>> getMenuItemsByRestaurant(String restaurantId);
  Future<List<MenuItem>> getAvailableMenuItemsByRestaurant(String restaurantId);
  Future<List<MenuItem>> searchMenuItems(String restaurantId, String query);
  Future<List<MenuItem>> getMenuItemsByCategory(String restaurantId, String category);
  Future<MenuItem?> getMenuItemById(String menuItemId);
  Future<bool> createMenuItem(MenuItem menuItem);
  Future<bool> updateMenuItem(MenuItem menuItem);
  Future<bool> deleteMenuItem(String menuItemId);
  Future<bool> updateMenuItemAvailability(String menuItemId, bool isAvailable);
  
  // Menu Categories
  Future<List<MenuCategory>> getMenuCategoriesByRestaurant(String restaurantId);
  Future<MenuCategory?> getMenuCategoryById(String categoryId);
  Future<bool> createMenuCategory(MenuCategory category);
  Future<bool> updateMenuCategory(MenuCategory category);
  Future<bool> deleteMenuCategory(String categoryId);
}