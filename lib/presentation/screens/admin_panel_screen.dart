import 'package:flutter/material.dart';

import '../../core/themes/app_themes.dart';
import '../../domain/entities/restaurant.dart';
import '../../domain/entities/user.dart' as app_user;

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  int _selectedIndex = 0;
  
  // Mock data for demonstration
  final List<Restaurant> _pendingRestaurants = [
    Restaurant(
      id: 'pending1',
      ownerId: 'owner1',
      name: "Joe's Coffee",
      description: 'Coffee shop with artisanal blends',
      address: '123 Main St, City, State 12345',
      phoneNumber: '(555) 123-4567',
      cuisineType: 'Coffee Shop',
      profileImageUrl: '',
      isActive: true,
      isApproved: false,
      pointsPerDollar: 10,
      categories: ['coffee'],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    Restaurant(
      id: 'pending2',
      ownerId: 'owner2',
      name: 'Main Street Bistro',
      description: 'Casual dining with American cuisine',
      address: '456 Oak Ave, City, State 12345',
      phoneNumber: '(555) 987-6543',
      cuisineType: 'American',
      profileImageUrl: '',
      isActive: true,
      isApproved: false,
      pointsPerDollar: 15,
      categories: ['american'],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  ];

  final List<app_user.User> _users = [
    app_user.User(
      id: 'user1',
      email: 'customer@example.com',
      name: 'John Doe',
      role: 'customer',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    app_user.User(
      id: 'owner1',
      email: 'owner@example.com',
      name: 'Jane Smith',
      role: 'restaurant_owner',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: AppThemes.primaryColor,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Row(
        children: [
          // Navigation sidebar
          Container(
            width: 250,
            decoration: const BoxDecoration(
              color: AppThemes.backgroundLight,
              border: Border(
                right: BorderSide(
                  color: AppThemes.secondaryColor,
                  width: 1,
                ),
              ),
            ),
            child: ListView(
              children: [
                ListTile(
                  leading: const Icon(Icons.dashboard),
                  title: const Text('Dashboard'),
                  selected: _selectedIndex == 0,
                  onTap: () => setState(() => _selectedIndex = 0),
                ),
                ListTile(
                  leading: const Icon(Icons.storefront),
                  title: const Text('Restaurants'),
                  selected: _selectedIndex == 1,
                  onTap: () => setState(() => _selectedIndex = 1),
                ),
                ListTile(
                  leading: const Icon(Icons.people),
                  title: const Text('Users'),
                  selected: _selectedIndex == 2,
                  onTap: () => setState(() => _selectedIndex = 2),
                ),
                ListTile(
                  leading: const Icon(Icons.notifications),
                  title: const Text('Notifications'),
                  selected: _selectedIndex == 3,
                  onTap: () => setState(() => _selectedIndex = 3),
                ),
              ],
            ),
          ),
          
          // Main content
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: [
                _buildDashboardView(),
                _buildRestaurantsView(),
                _buildUsersView(),
                _buildNotificationsView(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'System Overview',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _buildStatCard('Total Users', '1,248', Icons.people),
              _buildStatCard('Active Restaurants', '89', Icons.storefront),
              _buildStatCard('Pending Approvals', '5', Icons.pending_actions),
              _buildStatCard('Daily Orders', '156', Icons.shopping_cart),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Recent Activity',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildActivityList(),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppThemes.primaryColor),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppThemes.textSecondaryLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityList() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          const ListTile(
            leading: CircleAvatar(
              backgroundColor: AppThemes.primaryColor,
              child: Icon(Icons.storefront, color: Colors.white),
            ),
            title: Text('New restaurant application'),
            subtitle: Text('Joe\'s Coffee applied for approval'),
            trailing: Text('2 hours ago'),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: AppThemes.accentColor,
              child: Icon(Icons.shopping_cart, color: Colors.white),
            ),
            title: const Text('New order placed'),
            subtitle: const Text('Order #ORD-001 from John Doe'),
            trailing: const Text('4 hours ago'),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: AppThemes.primaryColor,
              child: Icon(Icons.people, color: Colors.white),
            ),
            title: const Text('New user registered'),
            subtitle: const Text('Sarah Johnson joined the platform'),
            trailing: const Text('6 hours ago'),
          ),
        ],
      ),
    );
  }

  Widget _buildRestaurantsView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Restaurant Management',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pending Approvals',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _pendingRestaurants.length,
                    itemBuilder: (context, index) {
                      final restaurant = _pendingRestaurants[index];
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    restaurant.name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      ElevatedButton.icon(
                                        onPressed: () {},
                                        icon: const Icon(Icons.check, size: 16),
                                        label: const Text('Approve'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      ElevatedButton.icon(
                                        onPressed: () {},
                                        icon: const Icon(Icons.close, size: 16),
                                        label: const Text('Reject'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                restaurant.description,
                                style: const TextStyle(
                                  color: AppThemes.textSecondaryLight,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                restaurant.address,
                                style: const TextStyle(
                                  color: AppThemes.textSecondaryLight,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Points per dollar: ${restaurant.pointsPerDollar}',
                                style: const TextStyle(
                                  color: AppThemes.textSecondaryLight,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsersView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'User Management',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'All Users',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  DataTable(
                    columns: const [
                      DataColumn(label: Text('Name')),
                      DataColumn(label: Text('Email')),
                      DataColumn(label: Text('Role')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows: _users.map((user) {
                      return DataRow(cells: [
                        DataCell(Text(user.name)),
                        DataCell(Text(user.email)),
                        DataCell(Text(user.role)),
                        DataCell(
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.visibility, color: AppThemes.primaryColor),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: const Icon(Icons.block, color: Colors.red),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ),
                      ]);
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsView() {
    return const Center(
      child: Text('Notifications management coming soon'),
    );
  }
}