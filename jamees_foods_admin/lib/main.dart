import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jamees_foods_admin/admin_provider/dashboard_provider.dart';
import 'package:jamees_foods_admin/admin_provider/each_user_provider.dart';
import 'package:jamees_foods_admin/admin_provider/login_provider.dart';
import 'package:jamees_foods_admin/admin_provider/sidebar_provider.dart';
import 'package:jamees_foods_admin/admin_provider/store_provider.dart';
import 'package:jamees_foods_admin/admin_provider/user_list_provider.dart';
import 'package:jamees_foods_admin/admin_view/splash.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]).then((_) {
    runApp(MyApp());
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
        ChangeNotifierProvider(create: (_) => AdminSidebarProvider()),
        ChangeNotifierProvider(create: (_) => AdminProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => SalesmanProvider()),
        ChangeNotifierProvider(create: (_) => DataProvider()),
        ChangeNotifierProvider(create: (_) => SelectedStoreProvider()),

        // Add other providers here
      ],
      child: ScreenUtilInit(
        designSize: const Size(768, 1024), // Set the design size for tablets
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: SafeArea(
              child: SplashPage(),
            ),
          );
        },
      ),
    );
  }
}
