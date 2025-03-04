import 'package:flutter/material.dart';
import 'package:jamees_foods_frontend/controller/admin_provider/sidebar_provider.dart';
import 'package:jamees_foods_frontend/controller/provider/checkin_checkout_provider.dart';
import 'package:jamees_foods_frontend/controller/provider/create_store_provider.dart';
import 'package:jamees_foods_frontend/controller/provider/login_provider.dart';
import 'package:jamees_foods_frontend/controller/provider/sidebar_provider.dart';
import 'package:jamees_foods_frontend/controller/provider/store_provider.dart';
import 'package:jamees_foods_frontend/controller/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';

import 'user_view/splash.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserSidebarProvider()),
        ChangeNotifierProvider(create: (_) => AdminSidebarProvider()),
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => StoreProvider()),
        ChangeNotifierProvider(create: (_) => GetStoreProvider()),
        ChangeNotifierProvider(create: (_) => StoreVisitProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),

        // Add other providers here
      ],
      child: ScreenUtilInit(
        designSize: const Size(768, 1024), // Set the design size for tablets
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              fontFamily: 'Poppins',
            ),
            home: SafeArea(
              child: SplashPage(),
            ),
          );
        },
      ),
    );
  }
}
