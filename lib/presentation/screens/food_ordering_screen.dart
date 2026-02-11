import 'package:flutter/material.dart';

import '../../core/themes/app_themes.dart';
import '../../domain/entities/menu.dart';

class FoodOrderingScreen extends StatefulWidget {
  final String restaurantName;
  final String restaurantId;
  
  const FoodOrderingScreen({
    super.key,
    required this.restaurantName,
    required this.restaurantId,
  });

  @override
  State<FoodOrderingScreen> createState() => _FoodOrderingScreenState();
}

class _FoodOrderingScreenState extends State<FoodOrderingScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  
  // Mock menu data
  final List<MenuItem> _menuItems = [
    MenuItem(
      id: '1',
      restaurantId: 'rest1',
      name: 'Classic Latte',
      description: 'Smooth espresso with steamed milk',
      price: 4.50,
      category: 'Coffee',
      pointsEarned: 15,
      isAvailable: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    MenuItem(
      id: '2',
      restaurantId: 'rest1',
      name: 'Avocado Toast',
      description: 'Fresh avocado on sourdough with poached eggs',
      price: 12.00,
      category: 'Breakfast',
      pointsEarned: 40,
      isAvailable: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    MenuItem(
      id: '3',
      restaurantId: 'rest1',
      name: 'Caesar Salad',
      description: 'Romaine lettuce, parmesan, croutons, dressing',
      price: 10.50,
      category: 'Salads',
      pointsEarned: 35,
      isAvailable: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    MenuItem(
      id: '4',
      restaurantId: 'rest1',
      name: 'Chicken Sandwich',
      description: 'Herb-marinated chicken with fresh vegetables',
      price: 13.00,
      category: 'Sandwiches',
      pointsEarned: 45,
      isAvailable: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    MenuItem(
      id: '5',
      restaurantId: 'rest1',
      name: 'Margherita Pizza',
      description: 'Fresh mozzarella, basil, and San Marzano tomatoes',
      price: 14.50,
      category: 'Pizza',
      pointsEarned: 55,
      isAvailable: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    MenuItem(
      id: '6',
      restaurantId: 'rest1',
      name: 'Buttery Croissant',
      description: 'Flaky, golden-brown handmade pastry',
      price: 3.75,
      category: 'Pastry',
      pointsEarned: 12,
      isAvailable: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  ];
  
  final List<String> _categories = ['All', 'Coffee', 'Breakfast', 'Salads', 'Sandwiches', 'Pizza', 'Pastry'];
  
  Map<String, int> _cartItems = {};

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.restaurantName),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_bag_outlined),
                onPressed: () {
                  // Show cart
                },
              ),
              if (_cartItems.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppThemes.errorColor,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      _getCartCount().toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search and filters
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search menu items...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Theme.of(context).cardColor,
                    ),
                    onChanged: (value) {
                      // Implement search
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Category filters
                  SizedBox(
                    height: 40,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: _categories.map((category) => 
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ChoiceChip(
                            label: Text(category),
                            selected: _selectedCategory == category,
                            onSelected: (selected) {
                              setState(() {
                                _selectedCategory = category;
                              });
                            },
                            selectedColor: AppThemes.primaryColor.withOpacity(0.2),
                          ),
                        )
                      ).toList(),
                    ),
                  ),
                ],
              ),
            ),
            
            // Menu items
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.75,
                ),
                itemCount: _getFilteredMenuItems().length,
                itemBuilder: (context, index) {
                  final item = _getFilteredMenuItems()[index];
                  return _buildMenuItemCard(context, item);
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _cartItems.isNotEmpty
        ? Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Items: ${_getCartCount()}',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Total: \$${_getCartTotal().toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppThemes.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Proceed to checkout
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppThemes.primaryColor,
                    minimumSize: const Size(120, 48),
                  ),
                  child: const Text('Checkout'),
                ),
              ],
            ),
          )
        : null,
    );
  }

  List<MenuItem> _getFilteredMenuItems() {
    List<MenuItem> filtered = _menuItems;
    
    // Filter by category
    if (_selectedCategory != 'All') {
      filtered = filtered.where((item) => item.category == _selectedCategory).toList();
    }
    
    // Filter by search
    if (_searchController.text.isNotEmpty) {
      final searchTerm = _searchController.text.toLowerCase();
      filtered = filtered.where((item) => 
        item.name.toLowerCase().contains(searchTerm) ||
        item.description.toLowerCase().contains(searchTerm)
      ).toList();
    }
    
    return filtered;
  }

  Widget _buildMenuItemCard(BuildContext context, MenuItem item) {
    final quantity = _cartItems[item.id] ?? 0;
    
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Item image placeholder
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: const Icon(Icons.fastfood, size: 40, color: Colors.grey),
          ),
          
          // Points badge
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.amber[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.stars, color: Colors.amber, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    '+${item.pointsEarned} pts',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Item details
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  item.description,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${item.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppThemes.primaryColor,
                      ),
                    ),
                    if (quantity == 0)
                      IconButton(
                        icon: const Icon(Icons.add, size: 20),
                        onPressed: () => _addToCart(item),
                        style: IconButton.styleFrom(
                          backgroundColor: AppThemes.primaryColor,
                          foregroundColor: Colors.white,
                        ),
                      )
                    else
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove, size: 20),
                            onPressed: () => _removeFromCart(item),
                          ),
                          Text('$quantity'),
                          IconButton(
                            icon: const Icon(Icons.add, size: 20),
                            onPressed: () => _addToCart(item),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _addToCart(MenuItem item) {
    setState(() {
      _cartItems[item.id] = (_cartItems[item.id] ?? 0) + 1;
    });
  }

  void _removeFromCart(MenuItem item) {
    setState(() {
      if (_cartItems[item.id] != null) {
        if (_cartItems[item.id]! > 1) {
          _cartItems[item.id] = _cartItems[item.id]! - 1;
        } else {
          _cartItems.remove(item.id);
        }
      }
    });
  }

  int _getCartCount() {
    return _cartItems.values.fold(0, (sum, quantity) => sum + quantity);
  }

  double _getCartTotal() {
    return _cartItems.entries.fold(0.0, (sum, entry) {
      final item = _menuItems.firstWhere((item) => item.id == entry.key);
      return sum + (item.price * entry.value);
    });
  }
}