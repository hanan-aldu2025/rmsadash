import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/driver_orders_cubit.dart';
import '../cubit/driver_orders_state.dart';

/// Widget to toggle driver online/offline status
class DriverStatusWidget extends StatelessWidget {
  final String driverId;

  const DriverStatusWidget({super.key, required this.driverId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DriverOrdersCubit, DriverOrdersState>(
      builder: (context, state) {
        bool isOnline = false;

        if (state is DriverOrdersLoaded) {
          isOnline = state.isDriverOnline;
        } else if (state is DriverOrdersUpdated) {
          isOnline = state.isDriverOnline;
        } else if (state is DriverStatusChanged) {
          isOnline = state.isOnline;
        }

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isOnline ? Icons.circle : Icons.circle_outlined,
              color: isOnline ? Colors.green : Colors.grey,
              size: 12,
            ),
            const SizedBox(width: 4),
            Text(
              isOnline ? 'Online' : 'Offline',
              style: TextStyle(
                color: isOnline ? Colors.green : Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            Switch(
              value: isOnline,
              onChanged: (value) {
                context.read<DriverOrdersCubit>().toggleDriverStatus(
                  driverId,
                  value,
                );
              },
              activeColor: Colors.green,
            ),
          ],
        );
      },
    );
  }
}
