import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/saved_registrations_screen.dart';
import 'screens/favorites_screen.dart';
import 'services/api_service.dart';  
import 'models/event.dart';  


void main() {
  runApp(const EventApp());
}

class EventApp extends StatelessWidget {
  const EventApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de Eventos',
      theme: ThemeData(
        primaryColor: const Color(0xFFF57C00),
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(
          titleLarge: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Color(0xFFF57C00)),
          bodyMedium: TextStyle(fontSize: 16.0, color: Colors.black),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF57C00), // Naranja VIU
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
              color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: const Color(0xFFF57C00),
            textStyle: const TextStyle(fontSize: 16.0),
          ),
        ),
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.orange)
            .copyWith(
              secondary:
                  const Color(0xFF1976D2), // Azul profundo para contraste
            )
            .copyWith(surface: Colors.white),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/savedRegistrations': (context) => const SavedRegistrationsScreen(), // Nueva ruta para registros guardados
        '/favorites': (context) => const FavoritesScreen(), // Nueva pantalla de favoritos
      },
    );
  }
}
