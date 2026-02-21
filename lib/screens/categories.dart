import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/category_grid.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final ApiService _api = ApiService();
  List<String> _categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  void _loadCategories() async {
    final data = await _api.loadCategories();
    setState(() {
      _categories = data;
      _isLoading = false;
    });
  }

  void _onCategoryTap(String category) {
    Navigator.pushNamed(
      context,
      "/plants_by_category",
      arguments: category,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Plant Categories")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : CategoryGrid(
        categories: _categories,
        onCategoryTap: _onCategoryTap,
      ),
    );
  }
}
