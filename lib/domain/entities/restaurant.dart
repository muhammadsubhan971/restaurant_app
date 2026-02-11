import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Restaurant {
  final String id;
  final String ownerId; // User ID of the restaurant owner
  final String name;
  final String description;
  final String address;
  final String? city;
  final String? state;
  final String? zipCode;
  final String? phoneNumber;
  final String? website;
  final String? cuisineType;
  final String? profileImageUrl;
  final String? coverImageUrl;
  final double? latitude;
  final double? longitude;
  final double? rating;
  final int? totalRatings;
  final bool isActive;
  final bool isApproved; // Admin approval status
  final int pointsPerDollar; // How many points earned per dollar spent
  final List<String> categories;
  final Map<String, dynamic>? operatingHours; // {monday: {open: "09:00", close: "21:00"}}
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic>? metadata;

  Restaurant({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.description,
    required this.address,
    this.city,
    this.state,
    this.zipCode,
    this.phoneNumber,
    this.website,
    this.cuisineType,
    this.profileImageUrl,
    this.coverImageUrl,
    this.latitude,
    this.longitude,
    this.rating,
    this.totalRatings,
    this.isActive = true,
    this.isApproved = false,
    this.pointsPerDollar = 10,
    this.categories = const [],
    this.operatingHours,
    required this.createdAt,
    required this.updatedAt,
    this.metadata,
  });

  // Create Restaurant from Firestore document
  factory Restaurant.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Restaurant(
      id: doc.id,
      ownerId: data['ownerId'] ?? '',
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      address: data['address'] ?? '',
      city: data['city'],
      state: data['state'],
      zipCode: data['zipCode'],
      phoneNumber: data['phoneNumber'],
      website: data['website'],
      cuisineType: data['cuisineType'],
      profileImageUrl: data['profileImageUrl'],
      coverImageUrl: data['coverImageUrl'],
      latitude: data['latitude'] is num ? data['latitude'].toDouble() : null,
      longitude: data['longitude'] is num ? data['longitude'].toDouble() : null,
      rating: data['rating'] is num ? data['rating'].toDouble() : null,
      totalRatings: data['totalRatings'] is int ? data['totalRatings'] : null,
      isActive: data['isActive'] ?? true,
      isApproved: data['isApproved'] ?? false,
      pointsPerDollar: data['pointsPerDollar'] ?? 10,
      categories: List<String>.from(data['categories'] ?? []),
      operatingHours: data['operatingHours'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      metadata: data['metadata'],
    );
  }

  // Convert Restaurant to Firestore data
  Map<String, dynamic> toFirestore() {
    return {
      'ownerId': ownerId,
      'name': name,
      'description': description,
      'address': address,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'phoneNumber': phoneNumber,
      'website': website,
      'cuisineType': cuisineType,
      'profileImageUrl': profileImageUrl,
      'coverImageUrl': coverImageUrl,
      'latitude': latitude,
      'longitude': longitude,
      'rating': rating,
      'totalRatings': totalRatings,
      'isActive': isActive,
      'isApproved': isApproved,
      'pointsPerDollar': pointsPerDollar,
      'categories': categories,
      'operatingHours': operatingHours,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'metadata': metadata,
    };
  }

  // Create a copy with updated values
  Restaurant copyWith({
    String? id,
    String? ownerId,
    String? name,
    String? description,
    String? address,
    String? city,
    String? state,
    String? zipCode,
    String? phoneNumber,
    String? website,
    String? cuisineType,
    String? profileImageUrl,
    String? coverImageUrl,
    double? latitude,
    double? longitude,
    double? rating,
    int? totalRatings,
    bool? isActive,
    bool? isApproved,
    int? pointsPerDollar,
    List<String>? categories,
    Map<String, dynamic>? operatingHours,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? metadata,
  }) {
    return Restaurant(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      name: name ?? this.name,
      description: description ?? this.description,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      website: website ?? this.website,
      cuisineType: cuisineType ?? this.cuisineType,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      rating: rating ?? this.rating,
      totalRatings: totalRatings ?? this.totalRatings,
      isActive: isActive ?? this.isActive,
      isApproved: isApproved ?? this.isApproved,
      pointsPerDollar: pointsPerDollar ?? this.pointsPerDollar,
      categories: categories ?? this.categories,
      operatingHours: operatingHours ?? this.operatingHours,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      metadata: metadata ?? this.metadata,
    );
  }

  // Get formatted address
  String get fullAddress {
    final parts = [
      address,
      city,
      state,
      zipCode,
    ].where((part) => part != null && part.isNotEmpty).toList();
    return parts.join(', ');
  }

  // Check if restaurant is open now
  bool get isOpen {
    if (operatingHours == null) return false;
    
    final now = DateTime.now();
    final day = _getDayOfWeek(now.weekday);
    final currentTime = TimeOfDay.fromDateTime(now);
    
    final hours = operatingHours![day];
    if (hours == null) return false;
    
    try {
      final openTime = _parseTime(hours['open']);
      final closeTime = _parseTime(hours['close']);
      
      if (openTime == null || closeTime == null) return false;
      
      return currentTime.compareTo(openTime) >= 0 && 
             currentTime.compareTo(closeTime) <= 0;
    } catch (e) {
      return false;
    }
  }

  // Helper method to get day name
  String _getDayOfWeek(int weekday) {
    const days = ['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'];
    return days[weekday - 1];
  }

  // Helper method to parse time string
  TimeOfDay? _parseTime(String? timeString) {
    if (timeString == null) return null;
    
    final parts = timeString.split(':');
    if (parts.length != 2) return null;
    
    try {
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      return TimeOfDay(hour: hour, minute: minute);
    } catch (e) {
      return null;
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Restaurant &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Restaurant(id: $id, name: $name, ownerId: $ownerId)';
  }
}