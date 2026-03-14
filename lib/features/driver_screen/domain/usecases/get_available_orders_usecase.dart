import '../../data/models/order_model.dart';
import '../entities/repos/driver_order_repo.dart';

/// UseCase لجلب الطلبات المتاحة للسائق
class GetAvailableOrdersUseCase {
  final DriverOrdersRepository repository;

  GetAvailableOrdersUseCase({required this.repository});

  /// استدعاء الـ UseCase لجلب الطلبات المتاحة
  Stream<List<OrderModel>> call() {
    return repository.getAvailableOrders();
  }
}

