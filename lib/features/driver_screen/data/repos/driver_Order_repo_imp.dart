import '../data_source/driver_order_datasorce.dart';
import '../models/order_model.dart';
import '../../domain/entities/repos/driver_order_repo.dart';

class DriverOrdersRepositoryImpl implements DriverOrdersRepository {
  final DriverOrdersDataSource dataSource;

  DriverOrdersRepositoryImpl({required this.dataSource});

  @override
  Stream<List<OrderModel>> getAvailableOrders() {
    return dataSource.getAvailableOrdersStream();
  }

  @override
  Future<void> changeOrderStatus({
    required String orderId,
    required String newStatus,
    required String driverId,
  }) async {
    await dataSource.updateOrderStatus(
      orderId: orderId,
      newStatus: newStatus,
      driverId: driverId,
    );
  }

  @override
  Future<OrderModel?> getOrder(String orderId) async {
    return await dataSource.getOrderById(orderId);
  }
}