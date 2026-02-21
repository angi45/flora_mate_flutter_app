import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/calendar_event.dart';
import '../services/event_service.dart';

class ScheduleEventPage extends StatefulWidget {
  final String plantName;

  const ScheduleEventPage({super.key, required this.plantName});

  @override
  State<ScheduleEventPage> createState() => _ScheduleEventPageState();
}

class _ScheduleEventPageState extends State<ScheduleEventPage> {
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _eventController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Schedule Event for ${widget.plantName}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2023, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _selectedDate,
              selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDate = selectedDay;
                });
              },
              calendarFormat: CalendarFormat.month,
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _eventController,
              decoration: const InputDecoration(
                labelText: 'Event description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: _saveEvent,
              icon: const Icon(Icons.calendar_today, size: 20),
              label: const Text(
                "Save",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[600],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                    horizontal: 28, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                shadowColor: Colors.green.withOpacity(0.5),
              ),
            ),

          ],
        ),
      ),
    );
  }

  Future<void> _saveEvent() async {
    if (_eventController.text.isEmpty) return;

    final event = CalendarEvent(
      date: DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
      ),
      plantName: widget.plantName,
      description: _eventController.text,
    );

    await EventService().addEvent(event);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Event saved!")),
    );

    Navigator.pop(context);
  }
}
