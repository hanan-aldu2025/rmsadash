import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order_model.dart';

class DriverOrdersDataSource {
  final FirebaseFirestore firestore;

  DriverOrdersDataSource({required this.firestore});

  /// 1️⃣ Stream لجلب كل الطلبات الجديدة والمتاحة للسائق
  Stream<List<OrderModel>> getAvailableOrdersStream() {
    return firestore
        .collection('orders')
        .where('orderStatus', isEqualTo: 'pending') // الطلبات الجديدة فقط
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => OrderModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  /// 2️⃣ تحديث حالة الطلب (قبول أو رفض)
  Future<void> updateOrderStatus({
    required String orderId,
    required String newStatus, // accepted / rejected
    required String driverId,
  }) async {
    await firestore.collection('orders').doc(orderId).update({
      'orderStatus': newStatus,
      'driverId': driverId,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// 3️⃣ اختيارية: جلب طلب محدد (للتأكيد قبل التغيير)
  Future<OrderModel?> getOrderById(String orderId) async {
    final doc = await firestore.collection('orders').doc(orderId).get();
    if (!doc.exists || doc.data() == null) return null;
    return OrderModel.fromMap(doc.data()!, doc.id);
  }
}