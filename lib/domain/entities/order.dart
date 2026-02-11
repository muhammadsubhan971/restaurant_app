import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  final String id;
  final String customerId;
  final String restaurantId;
  final String restaurantName;
  final List<OrderItem> items;
  final double subtotal;
  final double tax;
  final double total;
  final String status; // pending, confirmed, preparing, ready, completed, cancelled
  final String orderType; // pickup, dine_in
  final String? specialInstructions;
  final String? customerName;
  final String? customerPhone;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? confirmedAt;
  final DateTime? completedAt;

  Order({
    required this.id,
    required this.customerId,
    required this.restaurantId,
    required this.restaurantName,
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.total,
    required this.status,
    required this.orderType,
    this.specialInstructions,
    this.customerName,
    this.customerPhone,
    required this.createdAt,
    required this.updatedAt,
    this.confirmedAt,
    this.completedAt,
  });

  // Create Order from Firestore document
  factory Order.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Order(
      id: doc.id,
      customerId: data['customerId'] ?? '',
      restaurantId: data['restaurantId'] ?? '',
      restaurantName: data['restaurantName'] ?? '',
      items: (data['items'] as List<dynamic>?)
          ?.map((item) => OrderItem.fromMap(item as Map<String, dynamic>))
          .toList() ?? [],
      subtotal: (data['subtotal'] is num) ? data['subtotal'].toDouble() : 0.0,
      tax: (data['tax'] is num) ? data['tax'].toDouble() : 0.0,
      total: (data['total'] is num) ? data['total'].toDouble() : 0.0,
      status: data['status'] ?? 'pending',
      orderType: data['orderType'] ?? 'pickup',
      specialInstructions: data['specialInstructions'],
      customerName: data['customerName'],
      customerPhone: data['customerPhone'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      confirmedAt: data['confirmedAt'] != null 
          ? (data['confirmedAt'] as Timestamp).toDate() 
          : null,
      completedAt: data['completedAt'] != null 
          ? (data['completedAt'] as Timestamp).toDate() 
          : null,
    );
  }

  // Convert Order to Firestore data
  Map<String, dynamic> toFirestore() {
    return {
      'customerId': customerId,
      'restaurantId': restaurantId,
      'restaurantName': restaurantName,
      'items': items.map((item) => item.toMap()).toList(),
      'subtotal': subtotal,
      'tax': tax,
      'total': total,
      'status': status,
      'orderType': orderType,
      'specialInstructions': specialInstructions,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'confirmedAt': confirmedAt != null ? Timestamp.fromDate(confirmedAt!) : null,
      'completedAt': completedAt != null ? Timestamp.fromDate(completedAt!) : null,
    };
  }

  // Create a copy with updated values
  Order copyWith({
    String? id,
    String? customerId,
    String? restaurantId,
    String? restaurantName,
    List<OrderItem>? items,
    double? subtotal,
    double? tax,
    double? total,
    String? status,
    String? orderType,
    String? specialInstructions,
    String? customerName,
    String? customerPhone,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? confirmedAt,
    DateTime? completedAt,
  }) {
    return Order(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      restaurantId: restaurantId ?? this.restaurantId,
      restaurantName: restaurantName ?? this.restaurantName,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      tax: tax ?? this.tax,
      total: total ?? this.total,
      status: status ?? this.status,
      orderType: orderType ?? this.orderType,
      specialInstructions: specialInstructions ?? this.specialInstructions,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      confirmedAt: confirmedAt ?? this.confirmedAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  // Calculate total items count
  int get totalItems => items.fold(0, (total, item) => total + item.quantity);

  // Check if order can be cancelled
  bool get canBeCancelled => status == 'pending' || status == 'confirmed';

  // Check if order is completed
  bool get isCompleted => status == 'completed';

  // Check if order is cancelled
  bool get isCancelled => status == 'cancelled';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Order &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Order(id: $id, restaurant: $restaurantName, total: $total, status: $status)';
  }
}

class OrderItem {
  final String menuItemId;
  final String name;
  final int quantity;
  final double price;
  final String? specialInstructions;

  OrderItem({
    required this.menuItemId,
    required this.name,
    required this.quantity,
    required this.price,
    this.specialInstructions,
  });

  // Create OrderItem from map
  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      menuItemId: map['menuItemId'] ?? '',
      name: map['name'] ?? '',
      quantity: map['quantity'] ?? 0,
      price: (map['price'] is num) ? map['price'].toDouble() : 0.0,
      specialInstructions: map['specialInstructions'],
    );
  }

  // Convert OrderItem to map
  Map<String, dynamic> toMap() {
    return {
      'menuItemId': menuItemId,
      'name': name,
      'quantity': quantity,
      'price': price,
      'specialInstructions': specialInstructions,
    };
  }

  // Calculate item total
  double get total => price * quantity;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderItem &&
          runtimeType == other.runtimeType &&
          menuItemId == other.menuItemId;

  @override
  int get hashCode => menuItemId.hashCode;

  @override
  String toString() {
    return 'OrderItem(name: $name, quantity: $quantity, price: $price)';
  }
}