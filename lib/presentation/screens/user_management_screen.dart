import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../core/themes/app_themes.dart';
import '../../domain/entities/restaurant.dart';
import '../../domain/entities/user.dart' as app_user;

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  // Mock data for demonstration
  final List<app_user.User> _users = [
    app_user.User(
      id: 'user1',
      email: 'john.doe@example.com',
      name: 'John Doe',
      role: 'customer',
      phoneNumber: '(555) 123-4567',
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      updatedAt: DateTime.now(),
    ),
    app_user.User(
      id: 'user2',
      email: 'jane.smith@example.com',
      name: 'Jane Smith',
      role: 'customer',
      phoneNumber: '(555) 987-6543',
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      updatedAt: DateTime.now(),
    ),
    app_user.User(
      id: 'owner1',
      email: 'owner@joescoffee.com',
      name: 'Joe Wilson',
      role: 'restaurant_owner',
      phoneNumber: '(555) 555-1234',
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
      updatedAt: DateTime.now(),
    ),
    app_user.User(
      id: 'owner2',
      email: 'manager@bistro.com',
      name: 'Sarah Johnson',
      role: 'restaurant_owner',
      phoneNumber: '(555) 555-5678',
      isActive: false, // Suspended
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
      updatedAt: DateTime.now(),
    ),
    app_user.User(
      id: 'admin1',
      email: 'admin@localrewards.com',
      name: 'System Admin',
      role: 'admin',
      phoneNumber: '(555) 000-0000',
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 100)),
      updatedAt: DateTime.now(),
    ),
  ];

  final List<Restaurant> _restaurants = [
    Restaurant(
      id: 'rest1',
      ownerId: 'owner1',
      name: "Joe's Coffee",
      description: 'Coffee shop with artisanal blends',
      address: '123 Main St, City, State 12345',
      phoneNumber: '(555) 123-4567',
      cuisineType: 'Coffee Shop',
      profileImageUrl: '',
      isActive: true,
      isApproved: true,
      pointsPerDollar: 10,
      categories: ['coffee'],
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      updatedAt: DateTime.now(),
    ),
    Restaurant(
      id: 'rest2',
      ownerId: 'owner2',
      name: 'Main Street Bistro',
      description: 'Casual dining with American cuisine',
      address: '456 Oak Ave, City, State 12345',
      phoneNumber: '(555) 987-6543',
      cuisineType: 'American',
      profileImageUrl: '',
      isActive: false, // Suspended
      isApproved: true,
      pointsPerDollar: 15,
      categories: ['american'],
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      updatedAt: DateTime.now(),
    ),
    Restaurant(
      id: 'rest3',
      ownerId: 'owner3',
      name: 'Sakura Sushi',
      description: 'Fresh Japanese sushi and rolls',
      address: '789 Pine Rd, City, State 12345',
      phoneNumber: '(555) 111-2222',
      cuisineType: 'Japanese',
      profileImageUrl: '',
      isActive: true,
      isApproved: true,
      pointsPerDollar: 20,
      categories: ['japanese'],
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      updatedAt: DateTime.now(),
    ),
  ];

  int _activeTab = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('User & Restaurant Management'),
          backgroundColor: AppThemes.primaryColor,
          foregroundColor: Colors.white,
        ),
        body: Column(
          children: [
            // Tab Bar
            Container(
              color: AppThemes.backgroundLight,
              child: const TabBar(
                tabs: [
                  Tab(text: 'Users'),
                  Tab(text: 'Restaurants'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildUsersTab(),
                  _buildRestaurantsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUsersTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Manage Users',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: DataTable(
              columnSpacing: 16,
              columns: const [
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('Email')),
                DataColumn(label: Text('Role')),
                DataColumn(label: Text('Status')),
                DataColumn(label: Text('Joined')),
                DataColumn(label: Text('Actions')),
              ],
              rows: _users.map((user) {
                return DataRow(
                  cells: [
                    DataCell(Text(user.name)),
                    DataCell(Text(user.email)),
                    DataCell(_buildRoleChip(user.role)),
                    DataCell(
                      user.isActive
                          ? const Text('Active', style: TextStyle(color: Colors.green))
                          : const Text('Suspended', style: TextStyle(color: Colors.red)),
                    ),
                    DataCell(Text(_formatDate(user.createdAt))),
                    DataCell(
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert),
                        itemBuilder: (context) {
                          return [
                            PopupMenuItem(
                              value: 'view',
                              child: Row(
                                children: [
                                  const Icon(Icons.visibility, size: 16),
                                  const SizedBox(width: 8),
                                  Text(user.isActive ? 'View Details' : 'View Details'),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: user.isActive ? 'suspend' : 'activate',
                              child: Row(
                                children: [
                                  Icon(
                                    user.isActive ? Icons.block : Icons.check_circle,
                                    size: 16,
                                    color: user.isActive ? Colors.red : Colors.green,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    user.isActive ? 'Suspend User' : 'Activate User',
                                    style: TextStyle(
                                      color: user.isActive ? Colors.red : Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(Icons.delete, size: 16, color: Colors.red),
                                  SizedBox(width: 8),
                                  Text('Delete User', style: TextStyle(color: Colors.red)),
                                ],
                              ),
                            ),
                          ];
                        },
                        onSelected: (value) {
                          _handleUserAction(user, value);
                        },
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRestaurantsTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Manage Restaurants',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: DataTable(
              columnSpacing: 16,
              columns: const [
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('Owner')),
                DataColumn(label: Text('Type')),
                DataColumn(label: Text('Status')),
                DataColumn(label: Text('Joined')),
                DataColumn(label: Text('Actions')),
              ],
              rows: _restaurants.map((restaurant) {
                // Find owner name
                final owner = _users.firstWhere(
                  (user) => user.id == restaurant.ownerId,
                  orElse: () => app_user.User(
                    id: '',
                    email: '',
                    name: 'Unknown',
                    role: 'restaurant_owner',
                    createdAt: DateTime.now(),
                    updatedAt: DateTime.now(),
                  ),
                );

                return DataRow(
                  cells: [
                    DataCell(Text(restaurant.name)),
                    DataCell(Text(owner.name)),
                    DataCell(Text(restaurant.cuisineType ?? 'N/A')),
                    DataCell(
                      restaurant.isActive
                          ? const Text('Active', style: TextStyle(color: Colors.green))
                          : const Text('Suspended', style: TextStyle(color: Colors.red)),
                    ),
                    DataCell(Text(_formatDate(restaurant.createdAt))),
                    DataCell(
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert),
                        itemBuilder: (context) {
                          return [
                            const PopupMenuItem(
                              value: 'view',
                              child: Row(
                                children: [
                                  Icon(Icons.visibility, size: 16),
                                  SizedBox(width: 8),
                                  Text('View Details'),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: restaurant.isActive ? 'suspend' : 'activate',
                              child: Row(
                                children: [
                                  Icon(
                                    restaurant.isActive ? Icons.block : Icons.check_circle,
                                    size: 16,
                                    color: restaurant.isActive ? Colors.red : Colors.green,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    restaurant.isActive ? 'Suspend Restaurant' : 'Activate Restaurant',
                                    style: TextStyle(
                                      color: restaurant.isActive ? Colors.red : Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(Icons.delete, size: 16, color: Colors.red),
                                  SizedBox(width: 8),
                                  Text('Delete Restaurant', style: TextStyle(color: Colors.red)),
                                ],
                              ),
                            ),
                          ];
                        },
                        onSelected: (value) {
                          _handleRestaurantAction(restaurant, value);
                        },
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleChip(String role) {
    Color color;
    String label;

    switch (role) {
      case 'admin':
        color = Colors.purple;
        label = 'Admin';
        break;
      case 'restaurant_owner':
        color = Colors.orange;
        label = 'Owner';
        break;
      default:
        color = Colors.blue;
        label = 'Customer';
        break;
    }

    return Chip(
      label: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
      backgroundColor: color,
    );
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }

  void _handleUserAction(app_user.User user, String action) {
    switch (action) {
      case 'view':
        _viewUserDetails(user);
        break;
      case 'suspend':
        _suspendUser(user);
        break;
      case 'activate':
        _activateUser(user);
        break;
      case 'delete':
        _deleteUser(user);
        break;
    }
  }

  void _handleRestaurantAction(Restaurant restaurant, String action) {
    switch (action) {
      case 'view':
        _viewRestaurantDetails(restaurant);
        break;
      case 'suspend':
        _suspendRestaurant(restaurant);
        break;
      case 'activate':
        _activateRestaurant(restaurant);
        break;
      case 'delete':
        _deleteRestaurant(restaurant);
        break;
    }
  }

  void _viewUserDetails(app_user.User user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('User Details - ${user.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${user.id}'),
            Text('Email: ${user.email}'),
            Text('Phone: ${user.phoneNumber ?? 'N/A'}'),
            Text('Role: ${user.role}'),
            Text('Status: ${user.isActive ? 'Active' : 'Suspended'}'),
            Text('Created: ${_formatDate(user.createdAt)}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _viewRestaurantDetails(Restaurant restaurant) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Restaurant Details - ${restaurant.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${restaurant.id}'),
            Text('Owner: ${restaurant.ownerId}'),
            Text('Address: ${restaurant.address}'),
            Text('Phone: ${restaurant.phoneNumber ?? 'N/A'}'),
            Text('Cuisine Type: ${restaurant.cuisineType ?? 'N/A'}'),
            Text('Points per Dollar: ${restaurant.pointsPerDollar}'),
            Text('Status: ${restaurant.isActive ? 'Active' : 'Suspended'}'),
            Text('Approved: ${restaurant.isApproved ? 'Yes' : 'No'}'),
            Text('Created: ${_formatDate(restaurant.createdAt)}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _suspendUser(app_user.User user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Suspend User'),
        content: Text('Are you sure you want to suspend ${user.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Perform suspend action
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('User suspended successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Suspend'),
          ),
        ],
      ),
    );
  }

  void _activateUser(app_user.User user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Activate User'),
        content: Text('Are you sure you want to activate ${user.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Perform activate action
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('User activated successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Activate'),
          ),
        ],
      ),
    );
  }

  void _deleteUser(app_user.User user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete User'),
        content: Text('Are you sure you want to permanently delete ${user.name}? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Perform delete action
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('User deleted successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Delete'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  void _suspendRestaurant(Restaurant restaurant) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Suspend Restaurant'),
        content: Text('Are you sure you want to suspend ${restaurant.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Perform suspend action
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Restaurant suspended successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Suspend'),
          ),
        ],
      ),
    );
  }

  void _activateRestaurant(Restaurant restaurant) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Activate Restaurant'),
        content: Text('Are you sure you want to activate ${restaurant.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Perform activate action
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Restaurant activated successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Activate'),
          ),
        ],
      ),
    );
  }

  void _deleteRestaurant(Restaurant restaurant) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Restaurant'),
        content: Text('Are you sure you want to permanently delete ${restaurant.name}? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Perform delete action
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Restaurant deleted successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Delete'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}