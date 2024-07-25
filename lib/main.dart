import 'package:Trako/screens/authFlow/forgetPass.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Trako/app_data.dart';
import 'package:Trako/pref_manager.dart';
import 'package:Trako/screens/add_toner/add_toner.dart';
import 'package:Trako/screens/authFlow/signin.dart';
import 'package:Trako/screens/home/client/add_client.dart';
import 'package:Trako/screens/home/home.dart';
import 'package:Trako/screens/products/add_machine.dart';
import 'package:Trako/screens/profile/profile.dart';
import 'package:Trako/screens/supply_chian/supplychain.dart';
import 'package:Trako/screens/users/accessibility.dart';
import 'package:Trako/screens/users/add_user.dart';
import 'package:Trako/screens/users/machine_status.dart';
import 'package:Trako/screens/users/user_status.dart';
import 'package:Trako/screens/users/users.dart';

import 'ThemeNotifier.dart';
import 'globals.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeNotifier>(
          create: (context) => ThemeNotifier(
            ThemeData(
              scaffoldBackgroundColor: Colors.white,
              appBarTheme: const AppBarTheme(
                color: Colors.white,
                elevation: 0,
              ),
              visualDensity: VisualDensity.adaptivePlatformDensity,
              inputDecorationTheme: InputDecorationTheme(
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
              ),
            ),
          ),
        ),
        ChangeNotifierProvider<AppData>(
          create: (context) => AppData(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return MaterialApp(
          navigatorObservers: [routeObserver],
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          theme: themeNotifier.currentTheme,
          home: FutureBuilder<bool?>(
            future: PrefManager().getIsLoggedIn(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator()); // Show loading indicator while waiting for the future
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}')); // Handle error state
              } else if (snapshot.hasData && snapshot.data == true) {
                return const HomeScreen(); // User is logged in
              } else {
                return const AuthProcess(); // User is not logged in
              }
            },
          ),
          routes: {
            '/profile': (context) => const ProfilePage(),
            '/home_screen': (context) => const HomeScreen(),
            '/add_client': (context) => AddClient(),
            '/add_machine': (context) => AddMachine(),
            '/rq_view_tracesci': (context) => const QRViewTracesci(),
            '/add_toner': (context) => const AddToner(),
            '/users': (context) => const UsersModule(),
            '/add_user': (context) => const AddUser(),
            '/user_status': (context) => UserStatus(),
            '/machine_status': (context) => const MachineStatus(),
            '/accessibility': (context) => Accessibility(),
            '/forgot_pass': (context) => ForgotPass(),
          },
        );
      },
    );
  }
}
