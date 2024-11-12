import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'event_detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  FavoritesScreenState createState() => FavoritesScreenState();
}

class FavoritesScreenState extends State<FavoritesScreen> {
  List<Map<String, String>> favoriteEvents = [];

  @override
  void initState() {
    super.initState();
    _loadFavoriteEvents();
  }

  Future<void> _loadFavoriteEvents() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList('favoriteEvents') ?? [];

    setState(() {
      favoriteEvents = favorites.map((event) {
        try {
          // Intentar decodificar el JSON
          return Map<String, String>.from(jsonDecode(event));
        } catch (e) {
          // Si falla, interpretarlo como un texto simple
          return {'title': event};
        }
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eventos Favoritos'),
      ),
      body: favoriteEvents.isNotEmpty
          ? ListView.builder(
              itemCount: favoriteEvents.length,
              itemBuilder: (context, index) {
                final event = favoriteEvents[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    title: Text(event['title'] ?? 'Evento'),
                    subtitle: Text('${event['date'] ?? ''} • ${event['location'] ?? ''}'),
                    trailing: Text(event['category'] ?? ''),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EventDetailScreen(
                            title: event['title'] ?? '',
                            date: event['date'] ?? '',
                            location: event['location'] ?? '',
                            category: event['category'] ?? '',
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            )
          : const Center(
              child: Text(
                'No tienes eventos favoritos.',
                style: TextStyle(fontSize: 16),
              ),
            ),
    );
  }
}
