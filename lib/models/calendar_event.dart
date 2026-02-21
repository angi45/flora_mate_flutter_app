import 'package:cloud_firestore/cloud_firestore.dart';

class CalendarEvent {
  final DateTime date;
  final String plantName;
  final String description;

  CalendarEvent({
    required this.date,
    required this.plantName,
    required this.description,
  });

  Map<String, dynamic> toMap() => {
    'date': date,
    'plantName': plantName,
    'description': description,
  };

  factory CalendarEvent.fromMap(Map<String, dynamic> map) {
    return CalendarEvent(
      date: (map['date'] as Timestamp).toDate(),
      plantName: map['plantName'],
      description: map['description'],
    );
  }
}
