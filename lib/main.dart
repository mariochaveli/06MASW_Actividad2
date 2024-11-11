import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/event_detail_screen.dart';
import 'screens/settings_screen.dart';

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
        primaryColor: const Color(0xFFF57C00), // Naranja VIU
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.orange).copyWith(
          secondary: const Color(0xFF1976D2), // Azul profundo para contraste
        ),
        backgroundColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(
          headline6: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Color(0xFFF57C00)),
          bodyText2: TextStyle(fontSize: 16.0, color: Colors.black),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF57C00), // Naranja VIU
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: const Color(0xFFF57C00), // Naranja VIU
            onPrimary: Colors.white,
            textStyle: const TextStyle(fontSize: 16.0),
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/eventDetail': (context) => const EventDetailScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}
