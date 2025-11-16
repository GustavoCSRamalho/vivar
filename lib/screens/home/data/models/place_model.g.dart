// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlaceModel _$PlaceModelFromJson(Map<String, dynamic> json) => PlaceModel(
  id: json['id'] as String,
  name: json['name'] as String,
  category: json['category'] as String,
  description: json['description'] as String?,
  address: json['address'] as String,
  city: json['city'] as String,
  state: json['state'] as String,
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  phone: json['phone'] as String?,
  whatsapp: json['whatsapp'] as String?,
  email: json['email'] as String?,
  website: json['website'] as String?,
  rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
  reviewsCount: (json['reviewsCount'] as num?)?.toInt() ?? 0,
  priceRange: json['priceRange'] as String?,
  isOpen: json['isOpen'] as bool? ?? true,
  openingHours: json['openingHours'] as String?,
  amenities: (json['amenities'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  images: (json['images'] as List<dynamic>?)?.map((e) => e as String).toList(),
  discountText: json['discountText'] as String?,
  discountPercentage: (json['discountPercentage'] as num?)?.toInt(),
  isPremiumOnly: json['isPremiumOnly'] as bool? ?? false,
  distance: (json['distance'] as num?)?.toDouble(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  synced: json['synced'] as bool? ?? false,
);

Map<String, dynamic> _$PlaceModelToJson(PlaceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'category': instance.category,
      'description': instance.description,
      'address': instance.address,
      'city': instance.city,
      'state': instance.state,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'phone': instance.phone,
      'whatsapp': instance.whatsapp,
      'email': instance.email,
      'website': instance.website,
      'rating': instance.rating,
      'reviewsCount': instance.reviewsCount,
      'priceRange': instance.priceRange,
      'isOpen': instance.isOpen,
      'openingHours': instance.openingHours,
      'amenities': instance.amenities,
      'images': instance.images,
      'discountText': instance.discountText,
      'discountPercentage': instance.discountPercentage,
      'isPremiumOnly': instance.isPremiumOnly,
      'distance': instance.distance,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'synced': instance.synced,
    };
