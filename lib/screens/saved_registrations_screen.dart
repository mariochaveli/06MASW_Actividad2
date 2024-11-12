import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavedRegistrationsScreen extends StatefulWidget {
  const SavedRegistrationsScreen({Key? key}) : super(key: key);

  @override
  SavedRegistrationsScreenState createState() =>
      SavedRegistrationsScreenState();
}

class SavedRegistrationsScreenState extends State<SavedRegistrationsScreen> {
  List<Map<String, String>> savedRegistrations = [];

  @override
  void initState() {
    super.initState();
    _loadSavedRegistrations();
  }

  Future<void> _loadSavedRegistrations() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> registrations = prefs.getStringList('registrations') ?? [];
    
    setState(() {
      savedRegistrations = registrations
          .map((registration) =>
              Map<String, String>.from(jsonDecode(registration)))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registros Guardados'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: savedRegistrations.isNotEmpty
            ? ListView.builder(
                itemCount: savedRegistrations.length,
                itemBuilder: (context, index) {
                  final registration = savedRegistrations[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(registration['title'] ?? 'Evento'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Fecha: ${registration['date']}'),
                          Text('Ubicación: ${registration['location']}'),
                          Text('Categoría: ${registration['category']}'),
                          Text('Nombre: ${registration['name']}'),
                          Text('Correo: ${registration['email']}'),
                          Text('Teléfono: ${registration['phone']}'),
                        ],
                      ),
                    ),
                  );
                },
              )
            : const Center(
                child: Text(
                  'No hay registros guardados.',
                  style: TextStyle(fontSize: 16),
                ),
              ),
      ),
    );
  }
}
