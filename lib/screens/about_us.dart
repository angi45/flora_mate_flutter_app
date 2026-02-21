import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.green.shade100,
              child: const Icon(
                Icons.local_florist,
                size: 60,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'FloraMate 🌸',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 10),

            const Text(
              'Your friendly companion for all things plants!',
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            const Text(
              'FloraMate helps you take care of your plants easily. '
                  'Search for plants, track watering schedules, explore categories, '
                  'and keep your favorites all in one place. '
                  'Whether you are a beginner or an experienced plant parent, '
                  'FloraMate is here to guide you and make your home greener!',
              style: TextStyle(fontSize: 16, height: 1.5),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 30),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Contact Us:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text('Email: support@floramate.com'),
                Text('Website: www.floramate.com'),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
