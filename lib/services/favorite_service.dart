import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/plant.dart';

class FavoritesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> isFavorite(Plant plant) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;

    final doc = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .doc(plant.id.toString())
        .get();

    return doc.exists;
  }

  Future<void> toggleFavorite(Plant plant) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final docRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .doc(plant.id.toString());

    final doc = await docRef.get();

    if (doc.exists) {
      await docRef.delete();
    } else {
      await docRef.set({
        'id': plant.id,
        'commonName': plant.commonName,
        'latinName': plant.latinName,
        'imgUrl': plant.imgUrl ?? '',
      });
    }
  }

  Future<List<Plant>> getFavorites() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    final snapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return Plant(
        id: data['id'],
        commonName: data['commonName'],
        latinName: data['latinName'],
        imgUrl: data['imgUrl'],
        mainCategory: data['mainCategory'] ?? '',
      );
    }).toList();
  }
}
