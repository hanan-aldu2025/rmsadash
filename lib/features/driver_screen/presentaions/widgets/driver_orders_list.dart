import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/order_model.dart';
import '../cubit/driver_orders_cubit.dart';
import '../cubit/driver_orders_state.dart';
import 'order_card.dart';
import 'driver_status_widget.dart';

/// Main widget to display list of available orders for drivers
class DriverOrdersList extends StatefulWidget {
  final String driverId;

  const DriverOrdersList({super.key, required this.driverId});

  @override
  State<DriverOrdersList> createState() => _DriverOrdersListState();
}

class _DriverOrdersListState extends State<DriverOrdersList> {
  @override
  void initState() {
    super.initState();
    // Load orders when widget is initialized
    context.read<DriverOrdersCubit>().loadAvailableOrders(widget.driverId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الطلبات المتاحة'),
        actions: [
          // Driver status toggle
          DriverStatusWidget(driverId: widget.driverId),
        ],
      ),
      body: BlocConsumer<DriverOrdersCubit, DriverOrdersState>(
        listener: (context, state) {
          // Show snackbar messages
          if (state is DriverOrdersUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
              ),
            );
          } else if (state is DriverOrdersError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is DriverOrdersLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is DriverOrdersUpdating) {
            return Stack(
              children: [
                _buildOrdersList(state.previousOrders),
                Container(
                  color: Colors.black26,
                  child: Center(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const CircularProgressIndicator(),
                            const SizedBox(height: 16),
                            Text(state.message),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }

          List<OrderModel> orders = [];
          bool isDriverOnline = false;

          if (state is DriverOrdersLoaded) {
            orders = state.orders;
            isDriverOnline = state.isDriverOnline;
          } else if (state is DriverOrdersUpdated) {
            orders = state.orders;
            isDriverOnline = state.isDriverOnline;
          } else if (state is DriverStatusChanged) {
            orders = state.orders;
            isDriverOnline = state.isOnline;
          } else if (state is DriverOrdersError &&
              state.previousOrders != null) {
            orders = state.previousOrders!;
          }

          // Check if driver is offline
          if (!isDriverOnline) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.offline_bolt, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    'أنت غير متصل',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'قم بتفعيل الوضع اونلاين لتلقي الطلبات',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<DriverOrdersCubit>().toggleDriverStatus(
                        widget.driverId,
                        true,
                      );
                    },
                    icon: const Icon(Icons.power_settings_new),
                    label: const Text('تفعيل'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          }

          if (orders.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'لا توجد طلبات متاحة',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'انتظر حتى تصل طلبات جديدة',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return _buildOrdersList(orders);
        },
      ),
    );
  }

  Widget _buildOrdersList(List<OrderModel> orders) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<DriverOrdersCubit>().loadAvailableOrders(widget.driverId);
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return OrderCard(
            order: order,
            driverId: widget.driverId,
            onAccept: () {
              context.read<DriverOrdersCubit>().acceptOrder(
                order.id,
                widget.driverId,
              );
            },
            onReject: () {
              context.read<DriverOrdersCubit>().rejectOrder(
                order.id,
                widget.driverId,
              );
            },
          );
        },
      ),
    );
  }
}
