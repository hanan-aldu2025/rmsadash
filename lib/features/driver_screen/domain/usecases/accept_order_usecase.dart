import '../entities/repos/driver_order_repo.dart';

/// UseCase لقبول الطلب
class AcceptOrderUseCase {
  final DriverOrdersRepository repository;

  AcceptOrderUseCase({required this.repository});

  /// استدعاء الـ UseCase لقبول الطلب
  Future<void> call({required String orderId, required String driverId}) async {
    await repository.changeOrderStatus(
      orderId: orderId,
      newStatus: 'accepted',
      driverId: driverId,
    );
  }
}
