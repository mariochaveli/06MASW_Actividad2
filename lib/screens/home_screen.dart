import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'event_detail_screen.dart';
import 'package:eventos/models/event.dart';
import 'package:eventos/services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  bool notificationsEnabled = false;
  String selectedCategory = 'Todos';
  String searchQuery = '';
  String? selectedLocation;
  DateTime? selectedDate;

  // Lista de eventos que se obtendrá de la API
  late Future<List<Event>> events;

  List<String> favoriteEvents = [];

  @override
  void initState() {
    super.initState();
    _loadNotificationPreference();
    _loadFavoriteEvents();
    events = ApiService().getEventsFromAssets();
  }

  void _loadNotificationPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      notificationsEnabled = prefs.getBool('notificationsEnabled') ?? false;
    });
  }

  void _loadFavoriteEvents() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      favoriteEvents = prefs.getStringList('favoriteEvents') ?? [];
    });
  }

  Future<void> _toggleFavorite(Event event) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (favoriteEvents.contains(event.title)) {
        favoriteEvents.remove(event.title);
      } else {
        favoriteEvents.add(event.title);
      }
    });
    await prefs.setStringList('favoriteEvents', favoriteEvents);
  }

  bool _isFavorite(Event event) {
    return favoriteEvents.contains(event.title);
  }

  // Método para aplicar los filtros
  List<Event> _filterEvents(List<Event> events) {
    return events.where((event) {
      final matchesCategory =
          selectedCategory == 'Todos' || event.category == selectedCategory;
      final matchesSearchQuery =
          event.title.toLowerCase().contains(searchQuery.toLowerCase());
      final matchesLocation =
          selectedLocation == null || event.location == selectedLocation;
      final matchesDate =
          selectedDate == null || event.date == selectedDate.toString();
      return matchesCategory &&
          matchesSearchQuery &&
          matchesLocation &&
          matchesDate;
    }).toList();
  }

  void _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2025),
    );
    setState(() {
      selectedDate = pickedDate;
    });
  }

  void _clearFilters() {
    setState(() {
      searchQuery = '';
      selectedLocation = null;
      selectedDate = null;
      selectedCategory = 'Todos';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eventos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.pushNamed(context, '/favorites');
            },
            tooltip: 'Ver eventos favoritos',
          ),
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () {
              Navigator.pushNamed(context, '/savedRegistrations');
            },
            tooltip: 'Ver registros guardados',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/settings').then((_) {
            _loadNotificationPreference();
          });
        },
        backgroundColor: const Color(0xFFF57C00),
        child: const Icon(Icons.settings),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Buscar evento',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            searchQuery = '';
                          });
                        },
                      )
                    : null,
                border: const OutlineInputBorder(),
              ),
              onChanged: (query) {
                setState(() {
                  searchQuery = query;
                });
              },
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: selectedCategory,
              items: <String>[
                'Todos',
                'Conciertos',
                'Deportes',
                'Teatro',
                'Artes'
              ].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedCategory = newValue!;
                });
              },
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              hint: const Text('Selecciona ubicación'),
              value: selectedLocation,
              items: <String?>[
                'Valencia, España',
                'Madrid, España',
                'Barcelona, España',
                'Sevilla, España'
              ]
                  .map((String? value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(value ?? ''),
                      ))
                  .toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedLocation = newValue;
                });
              },
            ),
            if (selectedLocation != null)
              TextButton(
                onPressed: () {
                  setState(() {
                    selectedLocation = null;
                  });
                },
                child: const Text('Limpiar ubicación'),
              ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  selectedDate == null
                      ? 'Selecciona una fecha'
                      : 'Fecha: ${selectedDate.toString().split(' ')[0]}',
                ),
                const Spacer(),
                TextButton(
                  onPressed: _pickDate,
                  child: const Text('Seleccionar Fecha'),
                ),
                if (selectedDate != null)
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        selectedDate = null;
                      });
                    },
                  ),
              ],
            ),
            const SizedBox(height: 20),
            if (searchQuery.isNotEmpty ||
                selectedLocation != null ||
                selectedDate != null ||
                selectedCategory != 'Todos')
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    icon: const Icon(Icons.clear),
                    label: const Text('Limpiar filtros'),
                    onPressed: _clearFilters,
                  ),
                ],
              ),
            Expanded(
              child: FutureBuilder<List<Event>>(
                future: events,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                        child: Text('No hay eventos disponibles.'));
                  } else {
                    // Filtramos los eventos después de que se obtienen
                    final filteredEvents = _filterEvents(snapshot.data!);

                    return ListView.builder(
                      itemCount: filteredEvents.length,
                      itemBuilder: (context, index) {
                        final event = filteredEvents[index];
                        final isFavorite = _isFavorite(event);
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            title: Text(event.title),
                            subtitle: Text('${event.date} • ${event.location}'),
                            trailing: IconButton(
                              icon: Icon(
                                isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: isFavorite ? Colors.red : null,
                              ),
                              onPressed: () => _toggleFavorite(event),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EventDetailScreen(
                                    title: event.title,
                                    date: event.date,
                                    location: event.location,
                                    category: event.category,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
