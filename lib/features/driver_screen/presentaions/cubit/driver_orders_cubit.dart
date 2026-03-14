import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import '../../domain/usecases/get_available_orders_usecase.dart';
import '../../domain/usecases/accept_order_usecase.dart';
import '../../domain/usecases/reject_order_usecase.dart';
import '../../domain/usecases/update_driver_location_usecase.dart';
import '../../data/models/order_model.dart';
import 'driver_orders_state.dart';
import 'driver_orders_event.dart';

/// Cubit لإدارة طلبات السائق
class DriverOrdersCubit extends Cubit<DriverOrdersState> {
  final GetAvailableOrdersUseCase getAvailableOrdersUseCase;
  final AcceptOrderUseCase acceptOrderUseCase;
  final RejectOrderUseCase rejectOrderUseCase;
  final UpdateDriverLocationUseCase updateDriverLocationUseCase;
  final FirebaseFirestore firestore;

  StreamSubscription<List<OrderModel>>? _ordersSubscription;
  StreamSubscription<Position>? _locationSubscription;
  String? _currentDriverId;
  List<OrderModel> _currentOrders = [];
  bool _isDriverOnline = false;

  DriverOrdersCubit({
    required this.getAvailableOrdersUseCase,
    required this.acceptOrderUseCase,
    required this.rejectOrderUseCase,
    required this.updateDriverLocationUseCase,
    required this.firestore,
  }) : super(DriverOrdersInitial());

  /// تحميل الطلبات المتاحة
  Future<void> loadAvailableOrders(String driverId) async {
    _currentDriverId = driverId;
    emit(DriverOrdersLoading());

    try {
      await _ordersSubscription?.cancel();

      _ordersSubscription = getAvailableOrdersUseCase().listen(
        (orders) {
          _currentOrders = orders;
          emit(
            DriverOrdersLoaded(
              orders: orders,
              isDriverOnline: _isDriverOnline,
              driverId: driverId,
            ),
          );
        },
        onError: (error) {
          emit(
            DriverOrdersError(
              message: 'Error loading orders: ${error.toString()}',
              previousOrders: _currentOrders,
            ),
          );
        },
      );
    } catch (e) {
      emit(
        DriverOrdersError(
          message: 'Failed to load orders: ${e.toString()}',
          previousOrders: _currentOrders,
        ),
      );
    }
  }

  /// قبول الطلب
  Future<void> acceptOrder(String orderId, String driverId) async {
    final previousOrders = List<OrderModel>.from(_currentOrders);

    emit(
      DriverOrdersUpdating(
        previousOrders: previousOrders,
        message: 'جاري قبول الطلب...',
      ),
    );

    try {
      await acceptOrderUseCase(orderId: orderId, driverId: driverId);

      // Remove the accepted order from the list
      _currentOrders = _currentOrders.where((o) => o.id != orderId).toList();

      emit(
        DriverOrdersUpdated(
          orders: _currentOrders,
          message: 'تم قبول الطلب بنجاح',
          isDriverOnline: _isDriverOnline,
        ),
      );

      // Reload orders
      await loadAvailableOrders(driverId);
    } catch (e) {
      emit(
        DriverOrdersError(
          message: 'فشل في قبول الطلب: ${e.toString()}',
          previousOrders: previousOrders,
        ),
      );
    }
  }

  /// رفض الطلب
  Future<void> rejectOrder(String orderId, String driverId) async {
    final previousOrders = List<OrderModel>.from(_currentOrders);

    emit(
      DriverOrdersUpdating(
        previousOrders: previousOrders,
        message: 'جاري رفض الطلب...',
      ),
    );

    try {
      await rejectOrderUseCase(orderId: orderId, driverId: driverId);

      // Remove the rejected order from the list
      _currentOrders = _currentOrders.where((o) => o.id != orderId).toList();

      emit(
        DriverOrdersUpdated(
          orders: _currentOrders,
          message: 'تم رفض الطلب',
          isDriverOnline: _isDriverOnline,
        ),
      );

      // Reload orders
      await loadAvailableOrders(driverId);
    } catch (e) {
      emit(
        DriverOrdersError(
          message: 'فشل في رفض الطلب: ${e.toString()}',
          previousOrders: previousOrders,
        ),
      );
    }
  }

  /// تحديث موقع السائق
  Future<void> updateDriverLocation(String driverId, GeoPoint location) async {
    try {
      await updateDriverLocationUseCase(
        driverId: driverId,
        latitude: location.latitude,
        longitude: location.longitude,
      );
    } catch (e) {
      // Silent fail for location updates
    }
  }

  /// تفعيل/إلغاء تفعيل السائق
  Future<void> toggleDriverStatus(String driverId, bool isOnline) async {
    _isDriverOnline = isOnline;

    try {
      await firestore.collection('drivers').doc(driverId).update({
        'isOnline': isOnline,
        'lastloacationUpdate': FieldValue.serverTimestamp(),
      });

      if (isOnline) {
        await loadAvailableOrders(driverId);
        _startLocationTracking(driverId);
      } else {
        await _stopLocationTracking();
      }

      emit(DriverStatusChanged(isOnline: isOnline, orders: _currentOrders));
    } catch (e) {
      emit(
        DriverOrdersError(
          message: 'فشل في تحديث الحالة: ${e.toString()}',
          previousOrders: _currentOrders,
        ),
      );
    }
  }

  /// بدء تتبع الموقع
  Future<void> startLocationTracking(String driverId) async {
    _currentDriverId = driverId;
    _isDriverOnline = true;
    await _startLocationTracking(driverId);
  }

  Future<void> _startLocationTracking(String driverId) async {
    await _locationSubscription?.cancel();

    // Check location permissions
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return;
    }

    // Get initial location
    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      await updateDriverLocationUseCase(
        driverId: driverId,
        latitude: position.latitude,
        longitude: position.longitude,
      );
    } catch (e) {
      // Silent fail
    }

    // Listen for location updates
    _locationSubscription =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 10, // Update every 10 meters
          ),
        ).listen((Position position) async {
          if (_currentDriverId != null) {
            await updateDriverLocationUseCase(
              driverId: _currentDriverId!,
              latitude: position.latitude,
              longitude: position.longitude,
            );
          }
        });
  }

  /// إيقاف تتبع الموقع
  Future<void> stopLocationTracking() async {
    await _stopLocationTracking();
    _isDriverOnline = false;
    emit(DriverStatusChanged(isOnline: false, orders: _currentOrders));
  }

  Future<void> _stopLocationTracking() async {
    await _locationSubscription?.cancel();
    _locationSubscription = null;
  }

  /// حساب ETA للموقع
  double? calculateDistanceToBranch(
    GeoPoint driverLocation,
    GeoPoint branchLocation,
  ) {
    if (driverLocation.latitude == 0 && driverLocation.longitude == 0) {
      return null;
    }
    return Geolocator.distanceBetween(
          driverLocation.latitude,
          driverLocation.longitude,
          branchLocation.latitude,
          branchLocation.longitude,
        ) /
        1000; // Convert to km
  }

  /// حساب الوقت المتوقع للوصول (بالدقائق)
  int? calculateETAMinutes(double distanceKm) {
    const double averageSpeedKmPerHour = 30; // Average speed in city
    final hours = distanceKm / averageSpeedKmPerHour;
    return (hours * 60).round();
  }

  @override
  Future<void> close() {
    _ordersSubscription?.cancel();
    _locationSubscription?.cancel();
    return super.close();
  }
}
