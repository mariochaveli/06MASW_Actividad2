import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool notificationsEnabled = false;
  String selectedCategory = 'Todos';

  // Lista de eventos de ejemplo
  final List<Event> events = [
    Event(
      title: 'Concierto de Rock',
      date: '2024-05-20',
      location: 'Valencia, España',
      category: 'Conciertos',
    ),
    Event(
      title: 'Torneo de Baloncesto',
      date: '2024-06-10',
      location: 'Madrid, España',
      category: 'Deportes',
    ),
    Event(
      title: 'Obra de Teatro Clásico',
      date: '2024-07-15',
      location: 'Barcelona, España',
      category: 'Teatro',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadNotificationPreference();
  }

  void _loadNotificationPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      notificationsEnabled = prefs.getBool('notificationsEnabled') ?? false;
    });
  }

  // Filtrar eventos por categoría seleccionada
  List<Event> get filteredEvents {
    if (selectedCategory == 'Todos') {
      return events;
    }
    return events.where((event) => event.category == selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eventos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notificationsEnabled ? 'Notificaciones activadas' : 'Notificaciones desactivadas',
              style: Theme.of(context).textTheme.bodyText2?.copyWith(
                color: notificationsEnabled ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Selecciona una categoría de eventos:',
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: selectedCategory,
              items: <String>['Todos', 'Conciertos', 'Deportes', 'Teatro']
                  .map((String value) {
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
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: filteredEvents.length,
                itemBuilder: (context, index) {
                  final event = filteredEvents[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(event.title),
                      subtitle: Text('${event.date} • ${event.location}'),
                      trailing: Text(event.category),
                      onTap: () {
                        Navigator.pushNamed(context, '/eventDetail');
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.settings),
              label: const Text('Configuración'),
              onPressed: () {
                Navigator.pushNamed(context, '/settings').then((_) {
                  _loadNotificationPreference();
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Definición de la clase Event
class Event {
  final String title;
  final String date;
  final String location;
  final String category;

  Event({
    required this.title,
    required this.date,
    required this.location,
    required this.category,
  });
}
