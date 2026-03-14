
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderItem {
  final String productId;
  final String name;
  final int quantity;
  final double price;
  final double discount;

  OrderItem({
    required this.productId,
    required this.name,
    required this.quantity,
    required this.price,
    this.discount = 0.0,
  });

  double get total => (price - discount) * quantity;
}

/// Base entity for Order
class OrderEntity {
  final String id;
  final String userId;
  final List<OrderItem> items;
  final double totalAmount;
  final double delivery;
  final double discount;
  final double pointsDiscount;
  final String? orderNote;
  final String paymentMethod;
  final String paymentStatus;
  final String orderStatus;
  final String branchId;
  final String branchName;
  final GeoPoint branchLocation;
  final GeoPoint? userLocation;
  final String? estimatedDeliveryTime;
  final Driver? driver;
  final GeoPoint? driverLocation;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Optional timestamps
  final DateTime? acceptedAt;
  final DateTime? assignedAt;
  final DateTime? cancelledAt;
  final String? cancelledBy;
  final String? cancelReason;
  final DateTime? deliveredAt;
  final DateTime? onTheWayAt;
  final DateTime? paidAt;
  final DateTime? pickedUpAt;
  final DateTime? preparingAt;
  final DateTime? readyAt;
  final DateTime? lastDriverLocationAt;
  final bool? isArchived;
  final bool? isDelayed;
  final bool? isRated;
  final double? distanceKm;
  final double? driverLat;
  final double? driverLng;
  final String? driverRoting;
  final int? realDeliveryMinutes;
  final String? reviewId;

  OrderEntity({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.delivery,
    this.discount = 0.0,
    this.pointsDiscount = 0.0,
    this.orderNote,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.orderStatus,
    required this.branchId,
    required this.branchName,
    required this.branchLocation,
    this.userLocation,
    this.estimatedDeliveryTime,
    this.driver,
    this.driverLocation,
    required this.createdAt,
    required this.updatedAt,
    this.acceptedAt,
    this.assignedAt,
    this.cancelledAt,
    this.cancelledBy,
    this.cancelReason,
    this.deliveredAt,
    this.onTheWayAt,
    this.paidAt,
    this.pickedUpAt,
    this.preparingAt,
    this.readyAt,
    this.lastDriverLocationAt,
    this.isArchived,
    this.isDelayed,
    this.isRated,
    this.distanceKm,
    this.driverLat,
    this.driverLng,
    this.driverRoting,
    this.realDeliveryMinutes,
    this.reviewId,
  });

  /// Calculate total including delivery
  double get grandTotal => totalAmount + delivery - discount - pointsDiscount;
}

/// Driver entity (minimal representation)
class Driver {
  final String id;
  final String name;
  final String phone;
  final String? imageUrl;
  final double rating;
  final bool isActive;
  final bool isAvailable;
  final bool isOnline;
  final String? vehicleType;
  final GeoPoint? lat;
  final DateTime? lastLocationUpdate;

  Driver({
    required this.id,
    required this.name,
    required this.phone,
    this.imageUrl,
    this.rating = 0.0,
    this.isActive = true,
    this.isAvailable = false,
    this.isOnline = false,
    this.vehicleType,
    this.lat,
    this.lastLocationUpdate,
  });
}

