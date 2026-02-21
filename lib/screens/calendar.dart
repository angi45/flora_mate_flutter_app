import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/event_service.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  Map<DateTime, List<String>> _events = {};

  @override
  void initState() {
    super.initState();
    _loadEventsFromFirebase();
  }

  Future<void> _loadEventsFromFirebase() async {
    final events = await EventService().getEvents();
    final Map<DateTime, List<String>> loadedEvents = {};

    for (var e in events) {
      final dayOnly = DateTime(e.date.year, e.date.month, e.date.day);
      loadedEvents.putIfAbsent(dayOnly, () => []);
      loadedEvents[dayOnly]!.add("${e.plantName}: ${e.description}");
    }

    setState(() {
      _events = loadedEvents;
    });
  }


  List<String> _getEventsForDay(DateTime day) {
    final key = DateTime(day.year, day.month, day.day);
    return _events[key] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plant Calendar'),
        backgroundColor: Colors.green.shade700,
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2023, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: CalendarFormat.month,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            eventLoader: _getEventsForDay,
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.green.shade300,
                shape: BoxShape.circle,
              ),
              selectedDecoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              markerDecoration: const BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
            ),
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: _selectedDay == null
                ? const Center(
              child: Text('Select a day to see events'),
            )
                : ListView(
              children: _getEventsForDay(_selectedDay!).map((event) {
                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  child: ListTile(
                    leading: const Icon(
                      Icons.local_florist,
                      color: Colors.green,
                    ),
                    title: Text(event),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
