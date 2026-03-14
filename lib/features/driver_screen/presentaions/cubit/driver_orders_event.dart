import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Events for DriverOrdersCubit
abstract class DriverOrdersEvent extends Equatable {
  const DriverOrdersEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load available orders
class LoadAvailableOrders extends DriverOrdersEvent {
  final String driverId;

  const LoadAvailableOrders({required this.driverId});

  @override
  List<Object?> get props => [driverId];
}

/// Event to accept an order
class AcceptOrder extends DriverOrdersEvent {
  final String orderId;
  final String driverId;

  const AcceptOrder({required this.orderId, required this.driverId});

  @override
  List<Object?> get props => [orderId, driverId];
}

/// Event to reject an order
class RejectOrder extends DriverOrdersEvent {
  final String orderId;
  final String driverId;

  const RejectOrder({required this.orderId, required this.driverId});

  @override
  List<Object?> get props => [orderId, driverId];
}

/// Event to update driver location
class UpdateDriverLocation extends DriverOrdersEvent {
  final String driverId;
  final GeoPoint location;

  const UpdateDriverLocation({required this.driverId, required this.location});

  @override
  List<Object?> get props => [driverId, location];
}

/// Event to toggle driver online/offline status
class ToggleDriverStatus extends DriverOrdersEvent {
  final String driverId;
  final bool isOnline;

  const ToggleDriverStatus({required this.driverId, required this.isOnline});

  @override
  List<Object?> get props => [driverId, isOnline];
}

/// Event to start location tracking
class StartLocationTracking extends DriverOrdersEvent {
  final String driverId;

  const StartLocationTracking({required this.driverId});

  @override
  List<Object?> get props => [driverId];
}

/// Event to stop location tracking
class StopLocationTracking extends DriverOrdersEvent {}

/// Event when orders are updated from stream
class OrdersUpdatedFromStream extends DriverOrdersEvent {
  final List<dynamic> orders;

  const OrdersUpdatedFromStream({required this.orders});

  @override
  List<Object?> get props => [orders];
}
