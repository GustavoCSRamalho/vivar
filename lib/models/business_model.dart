// models/business_model.dart

import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class BusinessModel {
  final String id;
  final String? userId;

  final String name;
  final String category;
  final String? description;

  final String address;
  final String city;
  final String state;

  final double latitude;
  final double longitude;

  final String? phone;
  final String? whatsapp;
  final String? email;
  final String? website;

  final Map<String, dynamic>? schedule;
  final bool isWhatsapp;

  final double rating;
  final int reviewsCount;

  final String? priceRange;
  final bool isOpen;

  final Map<String, dynamic>? openingHours;

  final List<String> amenities;
  final List<String> images;

  final String? discountText;
  final int discountPercentage;

  final bool isPremiumOnly;

  final double? distance;

  final DateTime createdAt;
  final DateTime updatedAt;

  final bool synced;

  BusinessModel({
    required this.id,
    this.userId,
    required this.name,
    required this.category,
    this.description,
    required this.address,
    required this.city,
    required this.state,
    required this.latitude,
    required this.longitude,
    this.phone,
    this.whatsapp,
    this.email,
    this.website,
    this.schedule,
    this.isWhatsapp = false,
    this.rating = 0.0,
    this.reviewsCount = 0,
    this.priceRange,
    this.isOpen = true,
    this.openingHours,
    this.amenities = const [],
    this.images = const [],
    this.discountText,
    this.discountPercentage = 0,
    this.isPremiumOnly = false,
    this.distance,
    required this.createdAt,
    required this.updatedAt,
    this.synced = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'category': category,
      'description': description,
      'address': address,
      'city': city,
      'state': state,
      'latitude': latitude,
      'longitude': longitude,
      'phone': phone,
      'whatsapp': whatsapp,
      'email': email,
      'website': website,
      'schedule': schedule != null ? jsonEncode(schedule) : null,
      'is_whatsapp': isWhatsapp ? 1 : 0,
      'rating': rating,
      'reviews_count': reviewsCount,
      'price_range': priceRange,
      'is_open': isOpen ? 1 : 0,
      'opening_hours': openingHours != null ? jsonEncode(openingHours) : null,
      'amenities': jsonEncode(amenities),
      'images': jsonEncode(images),
      'discount_text': discountText,
      'discount_percentage': discountPercentage,
      'is_premium_only': isPremiumOnly ? 1 : 0,
      'distance': distance,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'synced': synced ? 1 : 0,
    };
  }

  factory BusinessModel.fromMap(Map<String, dynamic> map) {
    return BusinessModel(
      id: map['id'] as String,
      userId: map['user_id'] as String?,
      name: map['name'] as String,
      category: map['category'] as String,
      description: map['description'] as String?,
      address: map['address'] as String,
      city: map['city'] as String,
      state: map['state'] as String,
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
      phone: map['phone'] as String?,
      whatsapp: map['whatsapp'] as String?,
      email: map['email'] as String?,
      website: map['website'] as String?,
      schedule: map['schedule'] != null
          ? (map['schedule'] is String
                ? Map<String, dynamic>.from(jsonDecode(map['schedule']))
                : Map<String, dynamic>.from(map['schedule']))
          : null,
      isWhatsapp: map['is_whatsapp'] is int
          ? (map['is_whatsapp'] as int) == 1
          : (map['is_whatsapp'] as bool? ?? false),
      rating: map['rating'] != null ? (map['rating'] as num).toDouble() : 0.0,
      reviewsCount: map['reviews_count'] as int? ?? 0,
      priceRange: map['price_range'] as String?,
      isOpen: map['is_open'] is int
          ? (map['is_open'] as int) == 1
          : (map['is_open'] as bool? ?? true),
      openingHours: map['opening_hours'] != null
          ? (map['opening_hours'] is String
                ? Map<String, dynamic>.from(jsonDecode(map['opening_hours']))
                : Map<String, dynamic>.from(map['opening_hours']))
          : null,
      amenities: map['amenities'] != null
          ? (map['amenities'] is String
                ? List<String>.from(jsonDecode(map['amenities']))
                : List<String>.from(map['amenities']))
          : [],
      images: map['images'] != null
          ? (map['images'] is String
                ? List<String>.from(jsonDecode(map['images']))
                : List<String>.from(map['images']))
          : [],
      discountText: map['discount_text'] as String?,
      discountPercentage: map['discount_percentage'] as int? ?? 0,
      isPremiumOnly: map['is_premium_only'] is int
          ? (map['is_premium_only'] as int) == 1
          : (map['is_premium_only'] as bool? ?? false),
      distance: map['distance'] != null
          ? (map['distance'] as num).toDouble()
          : null,
      createdAt: map['created_at'] is String
          ? DateTime.parse(map['created_at'])
          : (map['created_at'] as DateTime),
      updatedAt: map['updated_at'] is String
          ? DateTime.parse(map['updated_at'])
          : (map['updated_at'] as DateTime),
      synced: map['synced'] is int
          ? (map['synced'] as int) == 1
          : (map['synced'] as bool? ?? false),
    );
  }

  BusinessModel copyWith({
    String? id,
    String? userId,
    String? name,
    String? category,
    String? description,
    String? address,
    String? city,
    String? state,
    double? latitude,
    double? longitude,
    String? phone,
    String? whatsapp,
    String? email,
    String? website,
    Map<String, dynamic>? schedule,
    bool? isWhatsapp,
    double? rating,
    int? reviewsCount,
    String? priceRange,
    bool? isOpen,
    Map<String, dynamic>? openingHours,
    List<String>? amenities,
    List<String>? images,
    String? discountText,
    int? discountPercentage,
    bool? isPremiumOnly,
    double? distance,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? synced,
  }) {
    return BusinessModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      category: category ?? this.category,
      description: description ?? this.description,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      phone: phone ?? this.phone,
      whatsapp: whatsapp ?? this.whatsapp,
      email: email ?? this.email,
      website: website ?? this.website,
      schedule: schedule ?? this.schedule,
      isWhatsapp: isWhatsapp ?? this.isWhatsapp,
      rating: rating ?? this.rating,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      priceRange: priceRange ?? this.priceRange,
      isOpen: isOpen ?? this.isOpen,
      openingHours: openingHours ?? this.openingHours,
      amenities: amenities ?? this.amenities,
      images: images ?? this.images,
      discountText: discountText ?? this.discountText,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      isPremiumOnly: isPremiumOnly ?? this.isPremiumOnly,
      distance: distance ?? this.distance,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      synced: synced ?? this.synced,
    );
  }
}
