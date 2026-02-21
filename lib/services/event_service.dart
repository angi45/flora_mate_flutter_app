import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/calendar_event.dart';

class EventService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addEvent(CalendarEvent event) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("No user logged in");

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('events')
        .add(event.toMap());
  }

  Future<List<CalendarEvent>> getEvents() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    final snapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('events')
        .get();

    return snapshot.docs.map((doc) {
      return CalendarEvent.fromMap(doc.data());
    }).toList();
  }
}
