import 'package:flutter/material.dart';

import '../../core/themes/app_themes.dart';
import '../../domain/entities/menu.dart';
import '../../domain/entities/order.dart';

class CartScreen extends StatefulWidget {
  final List<MenuItem> cartItems;
  final Map<String, int> itemQuantities;
  final String restaurantName;
  final String restaurantId;
  
  const CartScreen({
    super.key,
    required this.cartItems,
    required this.itemQuantities,
    required this.restaurantName,
    required this.restaurantId,
  });

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _specialInstructionsController = TextEditingController();
  String _orderType = 'pickup';

  @override
  void dispose() {
    _specialInstructionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final subtotal = _calculateSubtotal();
    final tax = subtotal * 0.08; // 8% tax
    final total = subtotal + tax;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Order'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Restaurant info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppThemes.primaryColor.withOpacity(0.1),
                border: Border(
                  bottom: BorderSide(color: AppThemes.primaryColor.withOpacity(0.3)),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.restaurant,
                    color: AppThemes.primaryColor,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.restaurantName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Order items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Items list
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Order Items',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ...widget.cartItems.map((item) {
                            final quantity = widget.itemQuantities[item.id] ?? 0;
                            return _buildOrderItem(item, quantity);
                          }).toList(),
                          
                          const Divider(height: 32),
                          
                          // Order summary
                          _buildOrderSummary(subtotal, tax, total),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Order type selection
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Order Type',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          SegmentedButton<String>(
                            segments: const [
                              ButtonSegment(
                                value: 'pickup',
                                label: Text('Pickup'),
                                icon: Icon(Icons.shopping_bag),
                              ),
                              ButtonSegment(
                                value: 'dine_in',
                                label: Text('Dine In'),
                                icon: Icon(Icons.restaurant),
                              ),
                            ],
                            selected: {_orderType},
                            onSelectionChanged: (Set<String> newSelection) {
                              setState(() {
                                _orderType = newSelection.first;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Special instructions
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Special Instructions',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _specialInstructionsController,
                            maxLines: 3,
                            decoration: InputDecoration(
                              hintText: 'Any special requests?',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Theme.of(context).cardColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Checkout button
            Container(
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          '\$${total.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppThemes.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _placeOrder,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppThemes.primaryColor,
                      minimumSize: const Size(150, 50),
                    ),
                    child: const Text(
                      'Place Order',
                      style: TextStyle(
                        fontSize: 16,
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
    );
  }

  Widget _buildOrderItem(MenuItem item, int quantity) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          // Item info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  item.description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  '\$${item.price.toStringAsFixed(2)} each',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppThemes.primaryColor,
                  ),
                ),
              ],
            ),
          ),
          
          // Quantity and total
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppThemes.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Qty: $quantity',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppThemes.primaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '\$${(item.price * quantity).toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary(double subtotal, double tax, double total) {
    return Column(
      children: [
        _buildSummaryRow('Subtotal', '\$${subtotal.toStringAsFixed(2)}'),
        _buildSummaryRow('Tax (8%)', '\$${tax.toStringAsFixed(2)}'),
        const SizedBox(height: 8),
        const Divider(),
        _buildSummaryRow(
          'Total',
          '\$${total.toStringAsFixed(2)}',
          isBold: true,
          textColor: AppThemes.primaryColor,
        ),
        const SizedBox(height: 8),
        _buildSummaryRow(
          'Points Earned',
          '+${_calculatePoints().toString()} ★',
          isBold: true,
          textColor: Colors.amber,
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false, Color? textColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  double _calculateSubtotal() {
    return widget.cartItems.fold(0.0, (sum, item) {
      final quantity = widget.itemQuantities[item.id] ?? 0;
      return sum + (item.price * quantity);
    });
  }

  int _calculatePoints() {
    return widget.cartItems.fold(0, (sum, item) {
      final quantity = widget.itemQuantities[item.id] ?? 0;
      return sum + (item.pointsEarned * quantity);
    });
  }

  Future<void> _placeOrder() async {
    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Placing your order...'),
              ],
            ),
          ),
        ),
      ),
    );
    
    try {
      // Create order object
      final orderItems = widget.cartItems.map((item) {
        final quantity = widget.itemQuantities[item.id] ?? 0;
        return OrderItem(
          menuItemId: item.id,
          name: item.name,
          quantity: quantity,
          price: item.price,
          specialInstructions: null,
        );
      }).toList();
      
      final subtotal = _calculateSubtotal();
      final tax = subtotal * 0.08;
      final total = subtotal + tax;
      
      final order = Order(
        id: 'order_${DateTime.now().millisecondsSinceEpoch}',
        customerId: 'current_user_id', // Would come from auth
        restaurantId: widget.restaurantId,
        restaurantName: widget.restaurantName,
        items: orderItems,
        subtotal: subtotal,
        tax: tax,
        total: total,
        status: 'pending',
        orderType: _orderType,
        specialInstructions: _specialInstructionsController.text.trim(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      if (!mounted) return;
      
      Navigator.pop(context); // Close loading dialog
      
      // Show success
      _showOrderSuccess(order);
      
    } catch (e) {
      if (!mounted) return;
      
      Navigator.pop(context); // Close loading dialog
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to place order. Please try again.'),
          backgroundColor: AppThemes.errorColor,
        ),
      );
    }
  }

  void _showOrderSuccess(Order order) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: AppThemes.successColor, size: 32),
            SizedBox(width: 12),
            Text('Order Placed!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Your order has been placed successfully.'),
            const SizedBox(height: 16),
            Text('Order ID: ${order.id.substring(0, 10)}...'),
            Text('Total: \$${order.total.toStringAsFixed(2)}'),
            Text('Points Earned: ${_calculatePoints()} ★'),
            const SizedBox(height: 16),
            const Text(
              'You will receive a notification when your order is ready.',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Close cart
              Navigator.pop(context); // Close menu
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}