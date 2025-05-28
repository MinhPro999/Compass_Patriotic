import 'package:compassapp_vn/screen/home_screen.dart';
import 'package:compassapp_vn/providers/user_state.dart';
import 'package:compassapp_vn/providers/compass_state.dart';
import 'package:compassapp_vn/services/admob_service.dart';
import 'package:compassapp_vn/services/facebook_service.dart';
import 'package:compassapp_vn/services/storage_service.dart';
// import 'package:compassapp_vn/services/permission_service.dart'; // Disabled - not needed
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:logging/logging.dart';

void main() async {
  // Khởi tạo logging
  Logger.root.level = Level.INFO;
  Logger.root.onRecord.listen((record) {
    debugPrint('${record.level.name}: ${record.time}: ${record.message}');
  });

  WidgetsFlutterBinding.ensureInitialized();

  // Khởi tạo Storage service
  await StorageService.instance.initialize();

  // Note: Permission service disabled - compass doesn't need permissions
  // await PermissionService.instance.initialize();

  // Khởi tạo AdMob service
  await AdMobService.instance.initialize();

  // Khởi tạo Facebook service
  await FacebookService.instance.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) {
            final userState = UserState();
            // Khởi tạo và load dữ liệu đã lưu
            userState.initialize();
            return userState;
          },
        ),
        ChangeNotifierProvider(create: (_) => CompassState()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            backgroundColor: Color.fromARGB(222, 190, 10, 10),
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.white),
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
