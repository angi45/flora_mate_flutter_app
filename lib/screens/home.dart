import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../models/plant.dart';
import '../services/api_service.dart';
import '../widgets/plant_grid.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Plant> _plants = [];
  List<Plant> _filteredPlants = [];
  bool _isLoading = true;
  String _searchQuery = '';
  int _selectedIndex = 0;

  final ApiService _apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Foreground message: ${message.notification?.title} - ${message.notification?.body}');
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('User clicked notification: ${message.notification?.title}');
    });
    _loadPlants();
  }

  void _loadPlants() async {
    final list = await _apiService.loadPlants();
    setState(() {
      _plants = list;
      _filteredPlants = list;
      _isLoading = false;
    });
  }

  void _filterPlants(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();

      if (_searchQuery.isEmpty) {
        _filteredPlants = _plants;
      } else {
        _filteredPlants = _plants.where((p) {
          final common = p.commonName.toLowerCase();
          final latin = p.latinName.toLowerCase();

          return common.contains(_searchQuery) ||
              latin.contains(_searchQuery);
        }).toList();
      }
    });
  }


  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImageAndIdentify() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a photo'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
                  if (photo != null) {
                    await _identifyPlant(File(photo.path));
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from gallery'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    await _identifyPlant(File(image.path));
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }


  Future<void> _identifyPlant(File imageFile) async {
    const apiKey = "2b10YI2P51MrPIvJc5gsxIV";
    const project = "all";

    final uri = Uri.parse(
      "https://my-api.plantnet.org/v2/identify/$project?api-key=$apiKey",
    );

    final request = http.MultipartRequest("POST", uri);

    request.files.add(
      await http.MultipartFile.fromPath(
        'images',
        imageFile.path,
      ),
    );

    request.fields['organs'] = 'leaf';

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final data = jsonDecode(responseBody);

      final latinName =
      data['results'][0]['species']['scientificNameWithoutAuthor'];

      _searchController.text = latinName;
      _filterPlants(latinName);
    } else {
      debugPrint("PlantNet error");
    }
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.pushNamed(context, "/categories");
        break;
      case 2:
        Navigator.pushNamed(context, "/calendar");
        break;
      case 3:
        Navigator.pushNamed(context, "/favorites");
        break;
      case 4:
        Navigator.pushNamed(context, "/aboutus");
        break;
      case 5:
        Navigator.pushNamed(context, "/profile");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(widget.title),
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
                hintText: 'Search plant...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                suffixIcon: TextButton.icon(
                  onPressed: _pickImageAndIdentify,
                  icon: const Icon(Icons.camera_alt, color: Colors.green),
                  label: const Text(
                    'Identify',
                    style: TextStyle(color: Colors.green),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                ),
              ),
              onChanged: _filterPlants,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: PlantGrid(plants: _filteredPlants),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onBottomNavTap,
        selectedItemColor: Colors.green.shade700,
        unselectedItemColor: Colors.black54,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'About Us',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
