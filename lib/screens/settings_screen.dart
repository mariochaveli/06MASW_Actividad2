import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key); // Agregar el parámetro Key

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  // Cargar preferencias de SharedPreferences
  void _loadPreferences() async {
    SharedPreferences prefs =await SharedPreferences.getInstance();
    setState(() {
      notificationsEnabled = prefs.getBool('notificationsEnabled') ?? false;
    });
  }

  // Guardar preferencias en SharedPreferences
  void _savePreferences(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('notificationsEnabled', value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'), // Añadir const
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Notificaciones',
              style: TextStyle(fontSize: 18),
            ),
            SwitchListTile(
              title: const Text('Activar Notificaciones'), // Añadir const
              value: notificationsEnabled,
              onChanged: (bool value) {
                setState(() {
                  notificationsEnabled = value;
                });
                _savePreferences(value); // Guardar la preferencia
              },
            ),
          ],
        ),
      ),
    );
  }
}
