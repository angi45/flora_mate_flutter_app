import 'package:flutter/material.dart';
import '../models/plant.dart';
import 'plant_card.dart';

class PlantGrid extends StatefulWidget {
  final List<Plant> plants;
  final VoidCallback? onUpdate;

  const PlantGrid({super.key, required this.plants, this.onUpdate});

  @override
  State<PlantGrid> createState() => _PlantGridState();
}

class _PlantGridState extends State<PlantGrid> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: widget.plants.length,
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      itemBuilder: (context, index) {
        return PlantCard(
          plant: widget.plants[index],
          onToggle: () {
            setState(() {});
            if (widget.onUpdate != null) widget.onUpdate!();
          },
        );
      },
    );
  }
}
