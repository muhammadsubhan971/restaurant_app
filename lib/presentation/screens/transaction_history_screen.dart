import 'package:flutter/material.dart';

import '../../core/themes/app_themes.dart';
import '../../domain/entities/loyalty.dart';
import '../../domain/entities/order.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  // Mock data for demonstration
  final List<LoyaltyTransaction> _transactions = [
    LoyaltyTransaction(
      id: 'tx1',
      userId: 'user1',
      restaurantId: 'rest1',
      restaurantName: "Joe's Coffee",
      type: 'earn',
      points: 25,
      description: 'Order #12345',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    LoyaltyTransaction(
      id: 'tx2',
      userId: 'user1',
      restaurantId: 'rest2',
      restaurantName: 'Main Street Bistro',
      type: 'earn',
      points: 75,
      description: 'Dinner order',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    LoyaltyTransaction(
      id: 'tx3',
      userId: 'user1',
      restaurantId: 'rest2',
      restaurantName: 'Main Street Bistro',
      type: 'redeem',
      points: 50,
      description: 'Free dessert reward',
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
    ),
  ];

  final List<Order> _orders = [
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
      ],
      subtotal: 4.50,
      tax: 0.36,
      total: 4.86,
      status: 'completed',
      orderType: 'pickup',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      updatedAt: DateTime.now().subtract(const Duration(days: 2)),
      completedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('History'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Points'),
              Tab(text: 'Orders'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Points Transactions Tab
            _buildPointsTab(),
            // Orders Tab
            _buildOrdersTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildPointsTab() {
    if (_transactions.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.stars,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No transactions yet',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Start earning points by dining at restaurants',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _transactions.length,
      itemBuilder: (context, index) {
        final transaction = _transactions[index];
        return _buildTransactionCard(transaction);
      },
    );
  }

  Widget _buildOrdersTab() {
    if (_orders.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_bag,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No orders yet',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Place your first order to get started',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _orders.length,
      itemBuilder: (context, index) {
        final order = _orders[index];
        return _buildOrderCard(order);
      },
    );
  }

  Widget _buildTransactionCard(LoyaltyTransaction transaction) {
    IconData icon;
    Color iconColor;
    Color cardColor;
    
    if (transaction.isEarning) {
      icon = Icons.add_circle;
      iconColor = AppThemes.successColor;
      cardColor = AppThemes.successColor.withOpacity(0.1);
    } else if (transaction.isRedeeming) {
      icon = Icons.remove_circle;
      iconColor = Colors.orange;
      cardColor = Colors.orange.withOpacity(0.1);
    } else {
      icon = Icons.info;
      iconColor = Colors.grey;
      cardColor = Colors.grey.withOpacity(0.1);
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: cardColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 24,
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Transaction details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.restaurantName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    transaction.description ?? '',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${transaction.createdAt.month}/${transaction.createdAt.day}/${transaction.createdAt.year}',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            
            // Points
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Text(
                      transaction.isRedeeming ? '-' : '+',
                      style: TextStyle(
                        color: transaction.isRedeeming ? Colors.orange : AppThemes.successColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${transaction.points}',
                      style: TextStyle(
                        color: transaction.isRedeeming ? Colors.orange : AppThemes.successColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Icon(
                      Icons.stars,
                      color: Colors.amber,
                      size: 16,
                    ),
                  ],
                ),
              ],
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
      case 'completed':
        statusColor = AppThemes.successColor;
        statusText = 'Completed';
        break;
      case 'pending':
        statusColor = Colors.orange;
        statusText = 'Pending';
        break;
      case 'cancelled':
        statusColor = AppThemes.errorColor;
        statusText = 'Cancelled';
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
                  order.restaurantName,
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
            
            // Order items preview
            Text(
              '${order.totalItems} items • \$${order.total.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Items list (first 2 items)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: order.items.take(2).map((item) => 
                Text(
                  '${item.quantity}x ${item.name}',
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                )
              ).toList(),
            ),
            
            if (order.items.length > 2) ...[
              const SizedBox(height: 4),
              Text(
                '+${order.items.length - 2} more items',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
            
            const SizedBox(height: 12),
            
            // Footer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order #${order.id.substring(0, 8)}',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                Text(
                  '${order.createdAt.month}/${order.createdAt.day}/${order.createdAt.year}',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}