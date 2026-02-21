import 'package:flutter/material.dart';
import '../models/plant.dart';
import '../services/api_service.dart';
import '../widgets/plant_grid.dart';

class PlantsByCategoryPage extends StatefulWidget {
  const PlantsByCategoryPage({super.key});

  @override
  State<PlantsByCategoryPage> createState() => _PlantsByCategoryPageState();
}

class _PlantsByCategoryPageState extends State<PlantsByCategoryPage> {
  final ApiService _api = ApiService();

  late String categoryName;

  List<Plant> _plants = [];
  List<Plant> _filteredPlants = [];

  bool _isLoading = true;
  String _searchQuery = '';

  final TextEditingController _searchController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    categoryName = ModalRoute.of(context)!.settings.arguments as String;

    _loadPlants();
  }

  void _loadPlants() async {
    final list = await _api.loadPlantsByCategory(categoryName);

    setState(() {
      _plants = list;
      _filteredPlants = list;
      _isLoading = false;
    });
  }

  void _searchPlants(String query) {
    setState(() {
      _searchQuery = query;
    });

    if (query.isEmpty) {
      setState(() => _filteredPlants = _plants);
      return;
    }

    final results = _plants
        .where((p) =>
    p.commonName.toLowerCase().contains(query.toLowerCase()) ||
        p.latinName.toLowerCase().contains(query.toLowerCase()))
        .toList();

    setState(() {
      _filteredPlants = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search plants...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: _searchPlants,
            ),
          ),
          Expanded(
            child: _filteredPlants.isEmpty && _searchQuery.isNotEmpty
                ? const Center(
              child: Text(
                "No plants found",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
                : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: PlantGrid(
                plants: _filteredPlants,
                onUpdate: () => setState(() {}),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
