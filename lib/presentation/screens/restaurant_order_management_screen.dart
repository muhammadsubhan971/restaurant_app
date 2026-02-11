import 'package:flutter/material.dart';

import '../../core/themes/app_themes.dart';
import '../../domain/entities/order.dart';

class RestaurantOrderManagementScreen extends StatefulWidget {
  const RestaurantOrderManagementScreen({super.key});

  @override
  State<RestaurantOrderManagementScreen> createState() => _RestaurantOrderManagementScreenState();
}

class _RestaurantOrderManagementScreenState extends State<RestaurantOrderManagementScreen> {
  // Mock orders data
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
      customerName: 'John Doe',
      customerPhone: '(555) 123-4567',
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
      customerName: 'Jane Smith',
      customerPhone: '(555) 987-6543',
      createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
      updatedAt: DateTime.now().subtract(const Duration(minutes: 25)),
    ),
    Order(
      id: 'order3',
      customerId: 'user3',
      restaurantId: 'rest1',
      restaurantName: "Joe's Coffee",
      items: [
        OrderItem(
          menuItemId: 'item4',
          name: 'Caesar Salad',
          quantity: 1,
          price: 10.50,
        ),
        OrderItem(
          menuItemId: 'item5',
          name: 'Iced Tea',
          quantity: 2,
          price: 2.50,
        ),
      ],
      subtotal: 15.50,
      tax: 1.24,
      total: 16.74,
      status: 'ready',
      orderType: 'pickup',
      customerName: 'Mike Johnson',
      customerPhone: '(555) 456-7890',
      createdAt: DateTime.now().subtract(const Duration(minutes: 45)),
      updatedAt: DateTime.now().subtract(const Duration(minutes: 40)),
    ),
    Order(
      id: 'order4',
      customerId: 'user4',
      restaurantId: 'rest1',
      restaurantName: "Joe's Coffee",
      items: [
        OrderItem(
          menuItemId: 'item6',
          name: 'Margherita Pizza',
          quantity: 1,
          price: 14.50,
        ),
      ],
      subtotal: 14.50,
      tax: 1.16,
      total: 15.66,
      status: 'completed',
      orderType: 'dine_in',
      customerName: 'Sarah Wilson',
      customerPhone: '(555) 234-5678',
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      updatedAt: DateTime.now().subtract(const Duration(minutes: 55)),
      completedAt: DateTime.now().subtract(const Duration(minutes: 55)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Management'),
        bottom: TabBar(
          tabs: [
            const Tab(text: 'All'),
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Pending'),
                  const SizedBox(width: 4),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      _getOrderCount('pending').toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Preparing'),
                  const SizedBox(width: 4),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      _getOrderCount('preparing').toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Ready'),
                  const SizedBox(width: 4),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppThemes.successColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      _getOrderCount('ready').toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: TabBarView(
          children: [
            _buildOrderList(),
            _buildOrderList(statusFilter: 'pending'),
            _buildOrderList(statusFilter: 'preparing'),
            _buildOrderList(statusFilter: 'ready'),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderList({String? statusFilter}) {
    List<Order> filteredOrders = _orders;
    if (statusFilter != null) {
      filteredOrders = _orders.where((order) => order.status == statusFilter).toList();
    }

    if (filteredOrders.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_bag_outlined,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No orders',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        // Simulate refresh
        await Future.delayed(const Duration(seconds: 1));
      },
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: filteredOrders.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final order = filteredOrders[index];
          return _buildOrderCard(order);
        },
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
        statusText = 'Ready for Pickup';
        break;
      case 'completed':
        statusColor = Colors.grey;
        statusText = 'Completed';
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order #${order.id.substring(0, 8)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${order.customerName ?? 'Customer'} • ${order.orderType == 'pickup' ? 'Pickup' : 'Dine In'}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
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
            
            // Order items
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: order.items.map((item) => 
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Text(
                          '${item.quantity}x',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            item.name,
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Text(
                          '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ).toList(),
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Order totals
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Subtotal'),
                Text('\$${order.subtotal.toStringAsFixed(2)}'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Tax'),
                Text('\$${order.tax.toStringAsFixed(2)}'),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  '\$${order.total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Order timing
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Ordered: ${_formatTime(order.createdAt)}',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                if (order.confirmedAt != null)
                  Text(
                    'Confirmed: ${_formatTime(order.confirmedAt!)}',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      _showOrderDetails(order);
                    },
                    child: const Text('View Details'),
                  ),
                ),
                const SizedBox(width: 8),
                if (order.status == 'pending')
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _updateOrderStatus(order.id, 'preparing');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppThemes.primaryColor,
                      ),
                      child: const Text(
                        'Start Preparing',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                else if (order.status == 'preparing')
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _updateOrderStatus(order.id, 'ready');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppThemes.successColor,
                      ),
                      child: const Text(
                        'Mark Ready',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                else if (order.status == 'ready')
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _updateOrderStatus(order.id, 'completed');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                      ),
                      child: const Text(
                        'Complete',
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

  void _showOrderDetails(Order order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Order #${order.id.substring(0, 8)} Details'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Customer: ${order.customerName ?? 'N/A'}'),
              Text('Phone: ${order.customerPhone ?? 'N/A'}'),
              Text('Order Type: ${order.orderType == 'pickup' ? 'Pickup' : 'Dine In'}'),
              if (order.specialInstructions != null && order.specialInstructions!.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    const Text('Special Instructions:', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(order.specialInstructions!),
                  ],
                ),
              const SizedBox(height: 8),
              const Text('Items:', style: TextStyle(fontWeight: FontWeight.bold)),
              ...order.items.map((item) => 
                Padding(
                  padding: const EdgeInsets.only(left: 8, top: 4),
                  child: Text('• ${item.quantity}x ${item.name} - \$${(item.price * item.quantity).toStringAsFixed(2)}'),
                ),
              ),
              const SizedBox(height: 8),
              Text('Total: \$${order.total.toStringAsFixed(2)}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _updateOrderStatus(String orderId, String newStatus) {
    // In a real app, this would update the order in Firebase
    setState(() {
      // Update the order status in the list
      final orderIndex = _orders.indexWhere((order) => order.id == orderId);
      if (orderIndex != -1) {
        _orders[orderIndex] = _orders[orderIndex].copyWith(
          status: newStatus,
          updatedAt: DateTime.now(),
        );
      }
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Order status updated to $newStatus'),
        backgroundColor: AppThemes.successColor,
      ),
    );
  }

  int _getOrderCount(String status) {
    return _orders.where((order) => order.status == status).length;
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hr ago';
    } else {
      return '${dateTime.month}/${dateTime.day}';
    }
  }
}