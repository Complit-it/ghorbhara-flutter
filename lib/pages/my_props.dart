import 'package:flutter/material.dart';
import 'package:hello_world/data/dummy_data.dart';
import 'package:hello_world/models/property.dart';
import 'package:hello_world/pages/components/reusables/property_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyPropertiesScreen extends StatefulWidget {
  const MyPropertiesScreen({super.key});

  @override
  State<MyPropertiesScreen> createState() => _MyPropertiesScreenState();
}

class _MyPropertiesScreenState extends State<MyPropertiesScreen> {
  List<Property> _myProps = [];
  final TextEditingController _searchController = TextEditingController();
  List<Property> _filteredProps = [];

  @override
  void initState() {
    super.initState();
    _loadMyProps();
    _searchController.addListener(_filterBySearch);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadMyProps() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId') ?? 0;
    final props = DummyData.dummyProperties
        .where((p) => p.userId == userId.toString())
        .toList();
    if (mounted) {
      setState(() {
        _myProps = props;
        _filteredProps = props;
      });
    }
  }

  void _filterBySearch() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredProps = _myProps.where((p) {
        return p.title.toLowerCase().contains(query) ||
            (p.location?.location ?? '').toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 72,
        title: ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Color(0xFF6246EA), Color(0xFF8E2DE2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds),
          child: const Text(
            'My Properties',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              fontFamily: 'Hind',
            ),
          ),
        ),
      ),
      body: _filteredProps.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6246EA).withValues(alpha: 0.08),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.home_work_rounded,
                        color: Color(0xFF6246EA), size: 48),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'No properties listed yet',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Properties you list will appear here.',
                    style: TextStyle(color: Color(0xFF8E8E93), fontSize: 14),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              itemCount: _filteredProps.length,
              itemBuilder: (context, index) =>
                  PropertyCard(property: _filteredProps[index]),
            ),
    );
  }
}
