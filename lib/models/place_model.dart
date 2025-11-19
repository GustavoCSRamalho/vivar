// models/place_model.dart
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'place_model.g.dart';

@JsonSerializable()
class PlaceModel {
  final String id;
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
  final double rating;
  final int reviewsCount;
  final String? priceRange; // '$', '$$', '$$$', '$$$$'
  final bool isOpen;
  final String? openingHours; // JSON string
  final List<String>? amenities;
  final List<String>? images;
  final String? discountText;
  final int? discountPercentage;
  final bool isPremiumOnly;
  final double? distance; // em metros
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool synced;

  PlaceModel({
    required this.id,
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
    this.rating = 0.0,
    this.reviewsCount = 0,
    this.priceRange,
    this.isOpen = true,
    this.openingHours,
    this.amenities,
    this.images,
    this.discountText,
    this.discountPercentage,
    this.isPremiumOnly = false,
    this.distance,
    required this.createdAt,
    required this.updatedAt,
    this.synced = false,
  });

  factory PlaceModel.fromJson(Map<String, dynamic> json) =>
      _$PlaceModelFromJson(json);

  Map<String, dynamic> toJson() => _$PlaceModelToJson(this);

  factory PlaceModel.fromMap(Map<String, dynamic> map) {
    return PlaceModel(
      id: map['id'],
      name: map['name'],
      category: map['category'],
      description: map['description'],
      address: map['address'],
      city: map['city'],
      state: map['state'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      phone: map['phone'],
      whatsapp: map['whatsapp'],
      email: map['email'],
      website: map['website'],
      rating: map['rating']?.toDouble() ?? 0.0,
      reviewsCount: map['reviews_count'] ?? 0,
      priceRange: map['price_range'],
      isOpen: map['is_open'] == 1,
      openingHours: map['opening_hours'],
      amenities: map['amenities'] != null
          ? List<String>.from(jsonDecode(map['amenities']))
          : null,
      images: map['images'] != null
          ? List<String>.from(jsonDecode(map['images']))
          : null,
      discountText: map['discount_text'],
      discountPercentage: map['discount_percentage'],
      isPremiumOnly: map['is_premium_only'] == 1,
      distance: map['distance']?.toDouble(),
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
      synced: map['synced'] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
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
      'rating': rating,
      'reviews_count': reviewsCount,
      'price_range': priceRange,
      'is_open': isOpen ? 1 : 0,
      'opening_hours': openingHours,
      'amenities': amenities != null ? jsonEncode(amenities) : null,
      'images': images != null ? jsonEncode(images) : null,
      'discount_text': discountText,
      'discount_percentage': discountPercentage,
      'is_premium_only': isPremiumOnly ? 1 : 0,
      'distance': distance,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'synced': synced ? 1 : 0,
    };
  }

  PlaceModel copyWith({
    String? id,
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
    double? rating,
    int? reviewsCount,
    String? priceRange,
    bool? isOpen,
    String? openingHours,
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
    return PlaceModel(
      id: id ?? this.id,
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
