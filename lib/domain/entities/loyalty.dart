import 'package:cloud_firestore/cloud_firestore.dart';

class LoyaltyTransaction {
  final String id;
  final String userId;
  final String restaurantId;
  final String restaurantName;
  final String type; // earn, redeem, expire
  final int points;
  final String? orderId; // If transaction is related to an order
  final String? description;
  final String? pinCode; // For verification
  final DateTime createdAt;
  final DateTime? expiresAt; // For earned points expiration

  LoyaltyTransaction({
    required this.id,
    required this.userId,
    required this.restaurantId,
    required this.restaurantName,
    required this.type,
    required this.points,
    this.orderId,
    this.description,
    this.pinCode,
    required this.createdAt,
    this.expiresAt,
  });

  // Create LoyaltyTransaction from Firestore document
  factory LoyaltyTransaction.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return LoyaltyTransaction(
      id: doc.id,
      userId: data['userId'] ?? '',
      restaurantId: data['restaurantId'] ?? '',
      restaurantName: data['restaurantName'] ?? '',
      type: data['type'] ?? '',
      points: data['points'] ?? 0,
      orderId: data['orderId'],
      description: data['description'],
      pinCode: data['pinCode'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      expiresAt: data['expiresAt'] != null 
          ? (data['expiresAt'] as Timestamp).toDate() 
          : null,
    );
  }

  // Convert LoyaltyTransaction to Firestore data
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'restaurantId': restaurantId,
      'restaurantName': restaurantName,
      'type': type,
      'points': points,
      'orderId': orderId,
      'description': description,
      'pinCode': pinCode,
      'createdAt': Timestamp.fromDate(createdAt),
      'expiresAt': expiresAt != null ? Timestamp.fromDate(expiresAt!) : null,
    };
  }

  // Create a copy with updated values
  LoyaltyTransaction copyWith({
    String? id,
    String? userId,
    String? restaurantId,
    String? restaurantName,
    String? type,
    int? points,
    String? orderId,
    String? description,
    String? pinCode,
    DateTime? createdAt,
    DateTime? expiresAt,
  }) {
    return LoyaltyTransaction(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      restaurantId: restaurantId ?? this.restaurantId,
      restaurantName: restaurantName ?? this.restaurantName,
      type: type ?? this.type,
      points: points ?? this.points,
      orderId: orderId ?? this.orderId,
      description: description ?? this.description,
      pinCode: pinCode ?? this.pinCode,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }

  // Check if transaction is earning points
  bool get isEarning => type == 'earn';

  // Check if transaction is redeeming points
  bool get isRedeeming => type == 'redeem';

  // Check if transaction is expired points
  bool get isExpiring => type == 'expire';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoyaltyTransaction &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'LoyaltyTransaction(id: $id, type: $type, points: $points)';
  }
}

class PointsBalance {
  final String id; // userId_restaurantId
  final String userId;
  final String restaurantId;
  final String restaurantName;
  final int totalPoints;
  final int availablePoints;
  final int redeemedPoints;
  final int expiredPoints;
  final DateTime lastUpdated;
  final Map<String, dynamic>? metadata;

  PointsBalance({
    required this.id,
    required this.userId,
    required this.restaurantId,
    required this.restaurantName,
    required this.totalPoints,
    required this.availablePoints,
    required this.redeemedPoints,
    required this.expiredPoints,
    required this.lastUpdated,
    this.metadata,
  });

  // Create PointsBalance from Firestore document
  factory PointsBalance.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return PointsBalance(
      id: doc.id,
      userId: data['userId'] ?? '',
      restaurantId: data['restaurantId'] ?? '',
      restaurantName: data['restaurantName'] ?? '',
      totalPoints: data['totalPoints'] ?? 0,
      availablePoints: data['availablePoints'] ?? 0,
      redeemedPoints: data['redeemedPoints'] ?? 0,
      expiredPoints: data['expiredPoints'] ?? 0,
      lastUpdated: (data['lastUpdated'] as Timestamp).toDate(),
      metadata: data['metadata'],
    );
  }

  // Convert PointsBalance to Firestore data
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'restaurantId': restaurantId,
      'restaurantName': restaurantName,
      'totalPoints': totalPoints,
      'availablePoints': availablePoints,
      'redeemedPoints': redeemedPoints,
      'expiredPoints': expiredPoints,
      'lastUpdated': Timestamp.fromDate(lastUpdated),
      'metadata': metadata,
    };
  }

  // Create a copy with updated values
  PointsBalance copyWith({
    String? id,
    String? userId,
    String? restaurantId,
    String? restaurantName,
    int? totalPoints,
    int? availablePoints,
    int? redeemedPoints,
    int? expiredPoints,
    DateTime? lastUpdated,
    Map<String, dynamic>? metadata,
  }) {
    return PointsBalance(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      restaurantId: restaurantId ?? this.restaurantId,
      restaurantName: restaurantName ?? this.restaurantName,
      totalPoints: totalPoints ?? this.totalPoints,
      availablePoints: availablePoints ?? this.availablePoints,
      redeemedPoints: redeemedPoints ?? this.redeemedPoints,
      expiredPoints: expiredPoints ?? this.expiredPoints,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      metadata: metadata ?? this.metadata,
    );
  }

  // Add points to balance
  PointsBalance addPoints(int points) {
    return copyWith(
      totalPoints: totalPoints + points,
      availablePoints: availablePoints + points,
      lastUpdated: DateTime.now(),
    );
  }

  // Redeem points from balance
  PointsBalance redeemPoints(int points) {
    if (points > availablePoints) {
      throw Exception('Insufficient points balance');
    }
    
    return copyWith(
      availablePoints: availablePoints - points,
      redeemedPoints: redeemedPoints + points,
      lastUpdated: DateTime.now(),
    );
  }

  // Expire points from balance
  PointsBalance expirePoints(int points) {
    if (points > availablePoints) {
      throw Exception('Insufficient points balance');
    }
    
    return copyWith(
      availablePoints: availablePoints - points,
      expiredPoints: expiredPoints + points,
      lastUpdated: DateTime.now(),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PointsBalance &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'PointsBalance(userId: $userId, restaurantId: $restaurantId, available: $availablePoints)';
  }
}