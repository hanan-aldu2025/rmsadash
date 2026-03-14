import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rmsadash/features/driver_screen/presentaions/cubit/driver_orders_cubit.dart';
import 'package:rmsadash/features/driver_screen/presentaions/widgets/driver_orders_list.dart';
import 'package:rmsadash/firebase_options.dart';
import 'package:rmsadash/injection_container.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // تهيئة الـ Dependencies
  await initializeDependencies();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // معرف السائق للاختبار - يجب استبداله بمعرف حقيقي من Firebase
    const String testDriverId = "YOUR_DRIVER_ID_HERE";
    
    return BlocProvider(
      create: (context) => sl<DriverOrdersCubit>(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: DriverOrdersList(driverId: testDriverId),
      ),
    );
  }
}
