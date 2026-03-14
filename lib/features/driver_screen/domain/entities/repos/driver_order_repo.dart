
import 'package:rmsadash/features/driver_screen/data/models/order_model.dart';

abstract class DriverOrdersRepository {
  /// Stream الطلبات المتاحة
  Stream<List<OrderModel>> getAvailableOrders();

  /// قبول أو رفض الطلب
  Future<void> changeOrderStatus({
    required String orderId,
    required String newStatus,
    required String driverId,
  });

  /// جلب طلب محدد
  Future<OrderModel?> getOrder(String orderId);
}