import 'package:flutter/material.dart';

class PlantDetailImage extends StatelessWidget {
  final String? imageUrl;

  const PlantDetailImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.green.shade200,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: imageUrl == null
            ? const Center(
          child: Icon(Icons.local_florist, size: 60, color: Colors.grey),
        )
            : Image.network(
          'https://plants-api-production-2df5.up.railway.app$imageUrl',
          fit: BoxFit.contain,
          alignment: Alignment.center,
          loadingBuilder: (context, child, progress) {
            if (progress == null) return child;
            return const Center(child: CircularProgressIndicator());
          },
          errorBuilder: (context, error, stackTrace) {
            return const Center(
              child: Icon(Icons.local_florist, size: 60, color: Colors.grey),
            );
          },
        ),
      ),
    );
  }
}
