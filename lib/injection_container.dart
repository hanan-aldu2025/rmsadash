import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rmsadash/features/driver_screen/data/data_source/driver_order_datasorce.dart';
import 'package:rmsadash/features/driver_screen/data/repos/driver_Order_repo_imp.dart';
import 'package:rmsadash/features/driver_screen/domain/entities/repos/driver_order_repo.dart';
import 'package:rmsadash/features/driver_screen/domain/usecases/accept_order_usecase.dart';
import 'package:rmsadash/features/driver_screen/domain/usecases/get_available_orders_usecase.dart';
import 'package:rmsadash/features/driver_screen/domain/usecases/reject_order_usecase.dart';
import 'package:rmsadash/features/driver_screen/domain/usecases/update_driver_location_usecase.dart';
import 'package:rmsadash/features/driver_screen/presentaions/cubit/driver_orders_cubit.dart';



final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // =======================
  // Firebase
  // =======================
  sl.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );

  // =======================
  // Data Sources
  // =======================
  sl.registerLazySingleton<DriverOrdersDataSource>(
    () => DriverOrdersDataSource(firestore: sl()),
  );

  // =======================
  // Repositories
  // =======================
  sl.registerLazySingleton<DriverOrdersRepository>(
    () => DriverOrdersRepositoryImpl(dataSource: sl()),
  );

  // =======================
  // Use Cases
  // =======================
  sl.registerLazySingleton(
    () => GetAvailableOrdersUseCase(repository: sl()),
  );
  sl.registerLazySingleton(
    () => AcceptOrderUseCase(repository: sl()),
  );
  sl.registerLazySingleton(
    () => RejectOrderUseCase(repository: sl()),
  );
  sl.registerLazySingleton(
    () => UpdateDriverLocationUseCase(firestore: sl()),
  );

  // =======================
  // Cubits
  // =======================
  sl.registerFactory(
    () => DriverOrdersCubit(
      getAvailableOrdersUseCase: sl(),
      acceptOrderUseCase: sl(),
      rejectOrderUseCase: sl(),
      updateDriverLocationUseCase: sl(),
      firestore: sl(),
    ),
  );
}

