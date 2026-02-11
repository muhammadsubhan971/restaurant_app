import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/themes/app_themes.dart';
import '../../domain/entities/restaurant.dart';
import '../../presentation/providers/auth_provider.dart';

class RestaurantDiscoveryScreen extends StatefulWidget {
  const RestaurantDiscoveryScreen({super.key});

  @override
  State<RestaurantDiscoveryScreen> createState() => _RestaurantDiscoveryScreenState();
}

class _RestaurantDiscoveryScreenState extends State<RestaurantDiscoveryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  final List<String> _categories = [
    'All', 'Coffee', 'American', 'Italian', 'Japanese', 'Mexican'
  ];

  // Mock data for demonstration
  final List<Restaurant> _restaurants = [
    Restaurant(
      id: '1',
      ownerId: 'owner1',
      name: "Joe's Coffee",
      description: 'Coffee & Bakery',
      address: '123 Main Street',
      cuisineType: 'Coffee',
      categories: ['Coffee', 'Breakfast'],
      rating: 4.8,
      totalRatings: 128,
      pointsPerDollar: 15,
      profileImageUrl: 'https://example.com/joes-coffee.jpg',
      isApproved: true,
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      updatedAt: DateTime.now(),
    ),
    Restaurant(
      id: '2',
      ownerId: 'owner2',
      name: 'Main Street Bistro',
      description: 'American Contemporary',
      address: '456 Main Street',
      cuisineType: 'American',
      categories: ['American', 'Contemporary'],
      rating: 4.6,
      totalRatings: 89,
      pointsPerDollar: 10,
      profileImageUrl: 'https://example.com/main-street-bistro.jpg',
      isApproved: true,
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 45)),
      updatedAt: DateTime.now(),
    ),
    Restaurant(
      id: '3',
      ownerId: 'owner3',
      name: 'The Daily Grind',
      description: 'Artisanal Coffee',
      address: '789 Oak Avenue',
      cuisineType: 'Coffee',
      categories: ['Coffee'],
      rating: 4.9,
      totalRatings: 203,
      pointsPerDollar: 12,
      profileImageUrl: 'https://example.com/daily-grind.jpg',
      isApproved: true,
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
      updatedAt: DateTime.now(),
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Restaurants'),
        actions: [
          Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              return IconButton(
                icon: const Icon(Icons.person_outline),
                onPressed: () {
                  // Navigate to profile
                },
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Search bar
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search restaurants or cuisine...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Theme.of(context).cardColor,
                    ),
                    onChanged: (value) {
                      // Implement search functionality
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
                          child: FilterChip(
                            label: Text(category),
                            selected: _selectedCategory == category,
                            onSelected: (selected) {
                              setState(() {
                                _selectedCategory = category;
                              });
                            },
                            selectedColor: AppThemes.primaryColor.withOpacity(0.2),
                            checkmarkColor: AppThemes.primaryColor,
                          ),
                        )
                      ).toList(),
                    ),
                  ),
                ],
              ),
            ),
            
            // Restaurant list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: _restaurants.length,
                itemBuilder: (context, index) {
                  final restaurant = _restaurants[index];
                  return _buildRestaurantCard(context, restaurant);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRestaurantCard(BuildContext context, Restaurant restaurant) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          // Navigate to restaurant details
        },
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Restaurant image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Container(
                height: 180,
                width: double.infinity,
                color: Colors.grey[300],
                child: restaurant.profileImageUrl != null
                  ? Image.network(
                      restaurant.profileImageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.restaurant, size: 60, color: Colors.grey);
                      },
                    )
                  : const Icon(Icons.restaurant, size: 60, color: Colors.grey),
              ),
            ),
            
            // Restaurant info
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with name and favorite button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          restaurant.name,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.favorite_border),
                        onPressed: () {
                          // Add to favorites
                        },
                      ),
                    ],
                  ),
                  
                  // Description and price
                  Text(
                    '${restaurant.description} • ${restaurant.cuisineType}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Rating and points info
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Rating
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            '${restaurant.rating}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '(${restaurant.totalRatings})',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                      
                      // Points info
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppThemes.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.stars, color: AppThemes.primaryColor, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              '${restaurant.pointsPerDollar} pts/\$',
                              style: TextStyle(
                                color: AppThemes.primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Location and hours
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        '0.3 mi • ',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const Icon(Icons.schedule, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        '6AM - 8PM',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}