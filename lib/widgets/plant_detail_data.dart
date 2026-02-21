import 'package:flutter/material.dart';
import '../models/plant.dart';
import 'package:url_launcher/url_launcher.dart';

class PlantDetailData extends StatelessWidget {
  final Plant plant;

  const PlantDetailData({super.key, required this.plant});

  Widget infoCard(String title, String? value,
      {Color? color, String? emoji}) {
    if (value == null || value.isEmpty) return const SizedBox.shrink();
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      color: color ?? Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (emoji != null) Text("$emoji  ", style: const TextStyle(fontSize: 18)),
            Text(
              "$title: ",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Expanded(child: Text(value)),
          ],
        ),
      ),
    );
  }

  Widget listCard(String title, List<String>? values, {String? emoji}) {
    if (values == null || values.isEmpty) return const SizedBox.shrink();
    return infoCard(title, values.join(', '), emoji: emoji);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 1),

            infoCard("Category", plant.mainCategory, emoji: "📂"),
            infoCard("Family", plant.family, emoji: "🏷️"),
            infoCard("Style", plant.style, emoji: "🌿"),
            infoCard("Watering", plant.watering, emoji: "💧", color: Colors.blue[50]),
            infoCard("Light tolerated", plant.lightTolered, emoji: "☀️", color: Colors.yellow[50]),
            infoCard("Light ideal", plant.lightIdeal, emoji: "🌞", color: Colors.yellow[100]),
            infoCard("Growth", plant.growth, emoji: "🌱"),
            infoCard("Pruning", plant.pruning, emoji: "✂️"),

            infoCard(
                "Height at purchase",
                plant.heightAtPurchase != null
                    ? "${plant.heightAtPurchase!['M']} m / ${plant.heightAtPurchase!['CM']} cm"
                    : null,
                emoji: "📏"),
            infoCard(
                "Width at purchase",
                plant.widthAtPurchase != null
                    ? "${plant.widthAtPurchase!['M']} m / ${plant.widthAtPurchase!['CM']} cm"
                    : null,
                emoji: "📏"),
            infoCard(
                "Height potential",
                plant.heightPotential != null
                    ? "${plant.heightPotential!['M']} m / ${plant.heightPotential!['CM']} cm"
                    : null,
                emoji: "📐"),
            infoCard(
                "Width potential",
                plant.widthPotential != null
                    ? "${plant.widthPotential!['M']} m / ${plant.widthPotential!['CM']} cm"
                    : null,
                emoji: "📐"),
            infoCard(
                "Pot diameter",
                plant.potDiameter != null
                    ? "${plant.potDiameter!['M']} m / ${plant.potDiameter!['CM']} cm"
                    : null,
                emoji: "🪴"),

            infoCard(
                "Temperature min",
                plant.temperatureMin != null
                    ? "${plant.temperatureMin!['C']}°C / ${plant.temperatureMin!['F']}°F"
                    : null,
                emoji: "🌡️", color: Colors.red[50]),
            infoCard(
                "Temperature max",
                plant.temperatureMax != null
                    ? "${plant.temperatureMax!['C']}°C / ${plant.temperatureMax!['F']}°F"
                    : null,
                emoji: "🌡️", color: Colors.red[100]),

            listCard("Blooming season", plant.bloomingSeason != null ? [plant.bloomingSeason!] : null, emoji: "🌼"),
            listCard("Color of leaf", plant.colorLeaf, emoji: "🍃"),
            listCard("Color of blooms", plant.colorBlooms, emoji: "🌸"),
            listCard("Insects", plant.insects, emoji: "🐛"),
            listCard("Origin", plant.origin, emoji: "🌎"),

            infoCard("Appeal", plant.appeal, emoji: "✨", color: Colors.green[50]),

            infoCard("Description", plant.description, emoji: "📝"),

          ],
        ),
      ),
    );
  }
}
