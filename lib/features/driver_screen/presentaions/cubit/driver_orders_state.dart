import 'package:equatable/equatable.dart';
import '../../data/models/order_model.dart';

/// States for DriverOrdersCubit
abstract class DriverOrdersState extends Equatable {
  const DriverOrdersState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class DriverOrdersInitial extends DriverOrdersState {}

/// Loading state - جاري تحميل الطلبات
class DriverOrdersLoading extends DriverOrdersState {}

/// Loaded state - تم تحميل الطلبات بنجاح
class DriverOrdersLoaded extends DriverOrdersState {
  final List<OrderModel> orders;
  final bool isDriverOnline;
  final String? driverId;

  const DriverOrdersLoaded({
    required this.orders,
    this.isDriverOnline = false,
    this.driverId,
  });

  @override
  List<Object?> get props => [orders, isDriverOnline, driverId];

  DriverOrdersLoaded copyWith({
    List<OrderModel>? orders,
    bool? isDriverOnline,
    String? driverId,
  }) {
    return DriverOrdersLoaded(
      orders: orders ?? this.orders,
      isDriverOnline: isDriverOnline ?? this.isDriverOnline,
      driverId: driverId ?? this.driverId,
    );
  }
}

/// Updating state - جاري تحديث (قبول/رفض/تحديث الموقع)
class DriverOrdersUpdating extends DriverOrdersState {
  final List<OrderModel> previousOrders;
  final String message;

  const DriverOrdersUpdating({
    required this.previousOrders,
    required this.message,
  });

  @override
  List<Object?> get props => [previousOrders, message];
}

/// Updated state - تم التحديث بنجاح
class DriverOrdersUpdated extends DriverOrdersState {
  final List<OrderModel> orders;
  final String message;
  final bool isDriverOnline;

  const DriverOrdersUpdated({
    required this.orders,
    required this.message,
    this.isDriverOnline = false,
  });

  @override
  List<Object?> get props => [orders, message, isDriverOnline];
}

/// Error state
class DriverOrdersError extends DriverOrdersState {
  final String message;
  final List<OrderModel>? previousOrders;

  const DriverOrdersError({required this.message, this.previousOrders});

  @override
  List<Object?> get props => [message, previousOrders];
}

/// Driver Online/Offline Status Changed
class DriverStatusChanged extends DriverOrdersState {
  final bool isOnline;
  final List<OrderModel> orders;

  const DriverStatusChanged({required this.isOnline, required this.orders});

  @override
  List<Object?> get props => [isOnline, orders];
}
