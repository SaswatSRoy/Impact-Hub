import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


import 'features/auth/ui/login_screen.dart';
import 'features/auth/ui/register_screen.dart';
import 'features/auth/ui/forgot_password_screen.dart';
import 'features/dashboard/ui/dashboard_screen.dart';
import 'features/home/ui/home_screen.dart';
import 'features/home/ui/event_details_screen.dart';
import 'features/home/ui/communities_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const storage = FlutterSecureStorage();
  final token = await storage.read(key: 'access_token');
  final initialRoute = (token != null && token.isNotEmpty) ? '/home' : '/login';

  runApp(
    ProviderScope(
      child: MyApp(initialRoute: initialRoute),
    ),
  );
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ImpactHub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF00796B),
        scaffoldBackgroundColor: const Color(0xFFFAFAFA),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Color(0xFF00796B),
        ),
      ),
      initialRoute: initialRoute,
      // simple named routes (no args)
      routes: {
        '/login': (_) => const LoginScreen(),
        '/register': (_) => const RegisterScreen(),
        '/forgot-password': (_) => const ForgotPasswordScreen(),
        '/dashboard': (_) => const DashboardScreen(),
        '/home': (_) => const HomeScreen(),
        '/communities': (_) => const CommunitiesScreen(),
      },
      // handle routes that need arguments (event details)
      onGenerateRoute: (settings) {
        if (settings.name == '/event-detail') {
          final args = settings.arguments;
          // EventDetailsScreen reads event via ModalRoute (that's ok),
          // but providing a typed route is safer:
          return MaterialPageRoute(
            builder: (context) => const EventDetailsScreen(),
            settings: settings,
          );
        }

        // fallback: unknown route -> home or 404 page
        return MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        );
      },
    );
  }
}
