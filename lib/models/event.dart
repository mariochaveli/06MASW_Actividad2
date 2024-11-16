class Event {
  final int id;
  final String title;  // Cambié 'name' a 'title' para coincidir con el JSON
  final String date;
  final String location;
  final String category;  // Cambié 'description' a 'category' para coincidir con el JSON

  Event({
    required this.id,
    required this.title,  // Cambié 'name' a 'title'
    required this.date,
    required this.location,
    required this.category,  // Cambié 'description' a 'category'
  });

  // Convertir un JSON a un objeto de tipo Event
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] ?? 0,  // Si 'id' es null, asignamos el valor por defecto 0
      title: json['title'] ?? '',  // Cambié 'name' a 'title'
      date: json['date'] ?? '',  // Si 'date' es null, asignamos el valor vacío
      location: json['location'] ?? '',  // Si 'location' es null, asignamos el valor vacío
      category: json['category'] ?? '',  // Cambié 'description' a 'category'
    );
  }

  // Convertir un objeto de tipo Event a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,  // Cambié 'name' a 'title'
      'date': date,
      'location': location,
      'category': category,  // Cambié 'description' a 'category'
    };
  }
}

class EventList {
  final List<Event> events;

  EventList({required this.events});

  // Convertir un JSON a una lista de eventos
  factory EventList.fromJson(Map<String, dynamic> json) {
    var list = json['events'] as List;
    List<Event> eventsList = list.map((i) => Event.fromJson(i)).toList();

    return EventList(events: eventsList);
  }

  // Convertir una lista de eventos a JSON
  Map<String, dynamic> toJson() {
    return {
      'events': events.map((e) => e.toJson()).toList(),
    };
  }
}
