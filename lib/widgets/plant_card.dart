import 'package:flutter/material.dart';
import '../models/plant.dart';
import '../services/favorite_service.dart';

class PlantCard extends StatelessWidget {
  final Plant plant;
  final VoidCallback? onToggle;

  const PlantCard({
    super.key,
    required this.plant,
    this.onToggle,
  });

  @override
  Widget build(BuildContext context) {

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        Navigator.pushNamed(
          context,
          "/plant_details",
          arguments: plant.id,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(18),
                ),
                child: plant.imgUrl != null
                    ? Image.network(
                  'https://plants-api-production-2df5.up.railway.app${plant.imgUrl}',
                  fit: BoxFit.cover,
                )
                    : Container(
                  color: Colors.green.shade50,
                  child: const Icon(
                    Icons.local_florist,
                    size: 48,
                    color: Colors.green,
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                children: [
                  Text(
                    plant.commonName,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    plant.latinName,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
