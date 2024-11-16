import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/event.dart';
import 'package:flutter/services.dart';

class ApiService {
  final String baseUrl =  "http://10.0.2.2:3000";  

   Future<List<Event>> getEventsFromAssets() async {
    // Leer el archivo JSON desde los assets
    final String response = await rootBundle.loadString('assets/events.json');
    // Decodificar el contenido del archivo JSON
    final data = json.decode(response);

    // Convertir el JSON a una lista de eventos
    List<Event> events = (data['events'] as List).map((e) => Event.fromJson(e)).toList();

    return events;
  }

  // Obtener los eventos desde la API (JSON Server)
  Future<List<Event>> fetchEvents() async {
    final response = await http.get(Uri.parse('$baseUrl/events'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Event.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load events');
    }
  }

  // Agregar un nuevo evento
  Future<void> addEvent(Event event) async {
    final response = await http.post(
      Uri.parse('$baseUrl/events'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(event.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to add event');
    }
  }
}
