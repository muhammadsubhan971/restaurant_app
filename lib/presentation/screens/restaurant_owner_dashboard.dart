import 'package:flutter/material.dart';

import '../../core/themes/app_themes.dart';
import '../../domain/entities/restaurant.dart';
import '../../domain/entities/order.dart';

class RestaurantOwnerDashboard extends StatefulWidget {
  const RestaurantOwnerDashboard({super.key});

  @override
  State<RestaurantOwnerDashboard> createState() => _RestaurantOwnerDashboardState();
}

class _RestaurantOwnerDashboardState extends State<RestaurantOwnerDashboard> {
  // Mock restaurant data
  final Restaurant _restaurant = Restaurant(
    id: 'rest1',
    ownerId: 'owner1',
    name: "Joe's Coffee",
    description: 'Premium coffee and bakery',
    address: '123 Main Street',
    cuisineType: 'Coffee',
    categories: ['Coffee', 'Breakfast'],
    rating: 4.8,
    totalRatings: 128,
    pointsPerDollar: 15,
    isApproved: true,
    isActive: true,
    createdAt: DateTime.now().subtract(const Duration(days: 30)),
    updatedAt: DateTime.now(),
  );

  // Mock orders data
  final List<Order> _recentOrders = [
    Order(
      id: 'order1',
      customerId: 'user1',
      restaurantId: 'rest1',
      restaurantName: "Joe's Coffee",
      items: [
        OrderItem(
          menuItemId: 'item1',
          name: 'Classic Latte',
          quantity: 1,
          price: 4.50,
        ),
        OrderItem(
          menuItemId: 'item2',
          name: 'Croissant',
          quantity: 1,
          price: 3.75,
        ),
      ],
      subtotal: 8.25,
      tax: 0.66,
      total: 8.91,
      status: 'pending',
      orderType: 'pickup',
      createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
      updatedAt: DateTime.now().subtract(const Duration(minutes: 15)),
    ),
    Order(
      id: 'order2',
      customerId: 'user2',
      restaurantId: 'rest1',
      restaurantName: "Joe's Coffee",
      items: [
        OrderItem(
          menuItemId: 'item3',
          name: 'Avocado Toast',
          quantity: 1,
          price: 12.00,
        ),
      ],
      subtotal: 12.00,
      tax: 0.96,
      total: 12.96,
      status: 'preparing',
      orderType: 'dine_in',
      createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
      updatedAt: DateTime.now().subtract(const Duration(minutes: 25)),
    ),
  ];

  int _newOrders = 3;
  int _totalOrders = 45;
  double _totalRevenue = 1250.75;
  double _averageRating = 4.8;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // Show notifications
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              // Show settings
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Restaurant Header
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      // Restaurant Image
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.restaurant,
                          size: 40,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Restaurant Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _restaurant.name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _restaurant.description,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${_restaurant.rating} (${_restaurant.totalRatings} reviews)',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Status Toggle
                      Column(
                        children: [
                          Switch(
                            value: _restaurant.isActive,
                            onChanged: (value) {
                              setState(() {
                                // Update restaurant status
                              });
                            },
                            activeColor: AppThemes.successColor,
                          ),
                          Text(
                            _restaurant.isActive ? 'Open' : 'Closed',
                            style: TextStyle(
                              color: _restaurant.isActive 
                                ? AppThemes.successColor 
                                : AppThemes.errorColor,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Quick Stats
              Text(
                'Today\'s Overview',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'New Orders',
                      '$_newOrders',
                      Icons.shopping_bag,
                      AppThemes.primaryColor,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(
                      'Total Orders',
                      '$_totalOrders',
                      Icons.list,
                      Colors.blue,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Revenue',
                      '\$${_totalRevenue.toStringAsFixed(2)}',
                      Icons.attach_money,
                      AppThemes.successColor,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(
                      'Rating',
                      '$_averageRating',
                      Icons.star,
                      Colors.amber,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Recent Orders
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Orders',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigate to full orders list
                    },
                    child: const Text('View All'),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              if (_recentOrders.isEmpty)
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Column(
                    children: [
                      Icon(
                        Icons.shopping_bag_outlined,
                        size: 48,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No orders yet',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                )
              else
                Column(
                  children: _recentOrders.map((order) => _buildOrderCard(order)).toList(),
                ),
              
              const SizedBox(height: 24),
              
              // Quick Actions
              Text(
                'Quick Actions',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    child: _buildActionCard(
                      'Menu Management',
                      Icons.restaurant_menu,
                      AppThemes.primaryColor,
                      () {
                        // Navigate to menu management
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildActionCard(
                      'Loyalty Settings',
                      Icons.stars,
                      Colors.amber,
                      () {
                        // Navigate to loyalty settings
                      },
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    child: _buildActionCard(
                      'Analytics',
                      Icons.analytics,
                      Colors.purple,
                      () {
                        // Navigate to analytics
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildActionCard(
                      'Profile',
                      Icons.store,
                      Colors.blue,
                      () {
                        // Navigate to profile
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderCard(Order order) {
    Color statusColor;
    String statusText;
    
    switch (order.status) {
      case 'pending':
        statusColor = Colors.orange;
        statusText = 'New Order';
        break;
      case 'preparing':
        statusColor = Colors.blue;
        statusText = 'Preparing';
        break;
      case 'ready':
        statusColor = AppThemes.successColor;
        statusText = 'Ready';
        break;
      default:
        statusColor = Colors.grey;
        statusText = order.status;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order #${order.id.substring(0, 8)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Order details
            Text(
              '${order.totalItems} items • \$${order.total.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
            
            const SizedBox(height: 8),
            
            Text(
              order.orderType == 'pickup' ? 'Pickup' : 'Dine In',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // View order details
                    },
                    child: const Text('View Details'),
                  ),
                ),
                const SizedBox(width: 8),
                if (order.status == 'pending')
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Accept order
                        setState(() {
                          // Update order status
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppThemes.successColor,
                      ),
                      child: const Text(
                        'Accept',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                else if (order.status == 'preparing')
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Mark as ready
                        setState(() {
                          // Update order status
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppThemes.primaryColor,
                      ),
                      child: const Text(
                        'Mark Ready',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(
                icon,
                color: color,
                size: 32,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}