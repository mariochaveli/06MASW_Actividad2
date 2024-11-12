import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share/share.dart';

class EventDetailScreen extends StatefulWidget {
  final String title;
  final String date;
  final String location;
  final String category;

  const EventDetailScreen({
    Key? key,
    required this.title,
    required this.date,
    required this.location,
    required this.category,
  }) : super(key: key);

  @override
  EventDetailScreenState createState() => EventDetailScreenState();
}

class EventDetailScreenState extends State<EventDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _feedbackController = TextEditingController();
  bool isFeedbackEmpty = true;

  @override
  void initState() {
    super.initState();
    _feedbackController.addListener(_updateFeedbackState);
  }

  @override
  void dispose() {
    _feedbackController.removeListener(_updateFeedbackState);
    _feedbackController.dispose();
    super.dispose();
  }

  void _updateFeedbackState() {
    setState(() {
      isFeedbackEmpty = _feedbackController.text.isEmpty;
    });
  }

  Future<void> _saveRegistration() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> registrations = prefs.getStringList('registrations') ?? [];

    Map<String, String> newRegistration = {
      'title': widget.title,
      'date': widget.date,
      'location': widget.location,
      'category': widget.category,
      'name': _nameController.text,
      'email': _emailController.text,
      'phone': _phoneController.text,
    };

    registrations.add(jsonEncode(newRegistration));
    await prefs.setStringList('registrations', registrations);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('¡Registro guardado exitosamente!')),
      );
    }
  }

  Future<void> _saveFeedback() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> feedbacks = prefs.getStringList('feedbacks') ?? [];

    Map<String, String> newFeedback = {
      'eventTitle': widget.title,
      'feedback': _feedbackController.text,
    };

    feedbacks.add(jsonEncode(newFeedback));
    await prefs.setStringList('feedbacks', feedbacks);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('¡Feedback enviado exitosamente!')),
      );
      _feedbackController.clear();
    }
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmación de Registro'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nombre: ${_nameController.text}'),
              Text('Correo Electrónico: ${_emailController.text}'),
              Text('Teléfono: ${_phoneController.text}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Editar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _saveRegistration();
              },
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }

  void _register() {
    if (_formKey.currentState!.validate()) {
      _showConfirmationDialog();
    }
  }

  void _shareEventDetails() {
    final String eventDetails =
        'Evento: ${widget.title}\nFecha: ${widget.date}\nUbicación: ${widget.location}\nCategoría: ${widget.category}';
    Share.share(eventDetails);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del Evento'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareEventDetails,
            tooltip: 'Compartir evento',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                widget.title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text('${widget.date} • ${widget.location} • ${widget.category}'),
              const SizedBox(height: 20),
              const Text(
                'Regístrate para este evento',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa tu nombre';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Correo Electrónico',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa tu correo electrónico';
                  } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Ingresa un correo electrónico válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Teléfono',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa tu teléfono';
                  } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                    return 'Ingresa solo números';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _register,
                child: const Text('Registrar'),
              ),
              const SizedBox(height: 30),
              const Text(
                'Enviar Feedback',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _feedbackController,
                decoration: const InputDecoration(
                  labelText: 'Tu opinión',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa tu feedback';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isFeedbackEmpty ? null : _saveFeedback,
                child: const Text('Enviar Feedback'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
