import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/plant.dart';

class ApiService {
  final String baseUrl = 'https://plants-api-production-2df5.up.railway.app';

  Future<List<Plant>> loadPlants() async {
    final response = await http.get(Uri.parse('$baseUrl/plants'));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((p) => Plant.fromJson(p)).toList();
    }

    return [];
  }

  Future<Plant?> loadPlantById(int localId) async {
    final response = await http.get(Uri.parse('$baseUrl/plants/$localId'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Plant.fromJson(data);
    }

    return null;
  }

  Future<List<String>> loadCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/categories'));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((c) => c.toString()).toList();
    }

    return [];
  }

  Future<List<Plant>> loadPlantsByCategory(String category) async {
    final allPlants = await loadPlants();
    return allPlants.where((p) => p.mainCategory == category).toList();
  }
}
