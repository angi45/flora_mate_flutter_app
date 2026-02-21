import 'package:flutter/material.dart';
import '../models/plant.dart';
import '../services/favorite_service.dart';
import '../widgets/plant_grid.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<Plant> _favorites = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    setState(() {
      _isLoading = true;
    });

    final favs = await FavoritesService().getFavorites();

    setState(() {
      _favorites = favs;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorite Plants"),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _favorites.isEmpty
          ? const Center(
        child: Text(
          "There is no favorite plant",
          style: TextStyle(fontSize: 18),
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(12.0),
        child: PlantGrid(
          plants: _favorites,
          onUpdate: _loadFavorites,
        ),
      ),
    );
  }
}
