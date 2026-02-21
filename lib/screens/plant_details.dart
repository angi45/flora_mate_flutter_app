import 'package:flutter/material.dart';
import '../models/calendar_event.dart';
import '../models/plant.dart';
import '../services/api_service.dart';
import '../services/event_service.dart';
import '../services/favorite_service.dart';
import '../widgets/plant_detail_image.dart';
import '../widgets/plant_detail_title.dart';
import '../widgets/plant_detail_data.dart';
import 'schedule_event.dart';

class PlantDetailsPage extends StatefulWidget {
  const PlantDetailsPage({super.key});

  @override
  State<PlantDetailsPage> createState() => _PlantDetailsPageState();
}

class _PlantDetailsPageState extends State<PlantDetailsPage> {
  final ApiService _api = ApiService();
  Plant? _plant;
  bool _isLoading = true;
  bool _isFavorite = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final localId = ModalRoute.of(context)!.settings.arguments as int;
    _loadPlantDetails(localId);
  }

  Future<void> _loadPlantDetails(int localId) async {
    final data = await _api.loadPlantById(localId);

    setState(() {
      _plant = data;
      _isLoading = false;
    });

    if (_plant != null) {
      final fav = await FavoritesService().isFavorite(_plant!);
      setState(() {
        _isFavorite = fav;
      });
    }
  }

  void _openSchedulePage() {
    if (_plant == null) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ScheduleEventPage(plantName: _plant!.commonName),
      ),
    );
  }

  void _toggleFavorite() async {
    if (_plant == null) return;

    await FavoritesService().toggleFavorite(_plant!);

    final isFav = await FavoritesService().isFavorite(_plant!);

    setState(() {
      _isFavorite = isFav;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isFav
              ? "${_plant!.commonName} added to favorites!"
              : "${_plant!.commonName} removed from favorites!",
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }


  void _scheduleWatering() async {
    if (_plant == null || _plant!.wateringScheduleDays == null) return;

    final int interval = _plant!.wateringScheduleDays!;
    final DateTime today = DateTime.now();

    for (int i = 0; i < 10; i++) {
      final DateTime wateringDay = today.add(Duration(days: interval * i));

      await EventService().addEvent(CalendarEvent(
        date: wateringDay,
        plantName: _plant!.commonName,
        description: "Watering day",
      ));
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Watering schedule created for the next 10 periods!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50.0, left: 16.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                ),
              ),
            ),

            PlantDetailTitle(
              commonName: _plant!.commonName,
              latinName: _plant!.latinName,
            ),

            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _openSchedulePage,
                      icon: const Icon(Icons.calendar_today, size: 18),
                      label: const Text(
                        "Create reminder",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[600],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                        shadowColor: Colors.green.withOpacity(0.5),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _scheduleWatering,
                      icon: const Icon(Icons.water_drop, size: 18),
                      label: const Text(
                        "Schedule Watering",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[600],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                        shadowColor: Colors.blue.withOpacity(0.5),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _toggleFavorite,
                      icon: Icon(
                        _isFavorite ? Icons.favorite : Icons.favorite_border,
                        size: 18,
                        color: Colors.white,
                      ),
                      label: Text(
                        _isFavorite ? "Favorited" : "Add to Favorite",
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[400],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                        shadowColor: Colors.red.withOpacity(0.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            PlantDetailImage(imageUrl: _plant!.imgUrl),

            const SizedBox(height: 10),

            PlantDetailData(plant: _plant!),
          ],
        ),
      ),
    );
  }
}
