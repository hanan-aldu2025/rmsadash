import '../entities/repos/driver_order_repo.dart';

/// UseCase لرفض الطلب
class RejectOrderUseCase {
  final DriverOrdersRepository repository;

  RejectOrderUseCase({required this.repository});

  /// استدعاء الـ UseCase لرفض الطلب
  Future<void> call({required String orderId, required String driverId}) async {
    await repository.changeOrderStatus(
      orderId: orderId,
      newStatus: 'rejected',
      driverId: driverId,
    );
  }
}
