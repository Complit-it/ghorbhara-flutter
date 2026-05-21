import 'package:flutter/material.dart';
import 'package:hello_world/data/dummy_data.dart';
import 'package:hello_world/models/facility.dart';
import 'package:hello_world/models/property.dart';
import 'package:hello_world/pages/components/reusables/property_card.dart';
import 'package:hello_world/pages/filter_screen.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  late List<Property> _allProps;
  late List<Property> _filteredProps;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _allProps = DummyData.dummyProperties;
    _filteredProps = _allProps;
    _searchController.addListener(_filterBySearch);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterBySearch() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredProps = _allProps.where((p) {
        final titleMatch = p.title.toLowerCase().contains(query);
        final locationMatch =
            (p.location?.location ?? '').toLowerCase().contains(query);
        return titleMatch || locationMatch;
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
        toolbarHeight: 72,
        elevation: 0,
        title: Row(
          children: [
            Expanded(
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F2F7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(fontSize: 14, color: Color(0xFF1A1A2E)),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search, color: Color(0xFF6246EA), size: 20),
                    hintText: 'Search city, area, property...',
                    hintStyle: TextStyle(color: Color(0xFFAAAAAA), fontSize: 13),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FilterScreen()),
                );
                if (result != null) {
                  setState(() {
                    _filteredProps = _allProps.where((property) {
                      final price = double.tryParse(property.price ?? '0') ?? 0;
                      final isPriceInRange = price >= result.values.start &&
                          price <= result.values.end;
                      final hasSelectedFacilities =
                          result.selectedFacilities.every((Facility facility) {
                        final facilities = property.homeFacilities;
                        return facilities != null &&
                            facilities.any((hf) => hf.facility.id == facility.id);
                      });
                      final hasSelectedType = result.selectedPropType.isEmpty ||
                          result.selectedPropType.any((opt) =>
                              int.tryParse(property.propertyTypeId) == opt.id);
                      return isPriceInRange &&
                          hasSelectedFacilities &&
                          hasSelectedType;
                    }).toList();
                  });
                }
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF6246EA).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.tune_rounded,
                    color: Color(0xFF6246EA), size: 22),
              ),
            ),
          ],
        ),
      ),
      body: _filteredProps.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off_rounded,
                      size: 64, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  const Text('No properties found',
                      style:
                          TextStyle(color: Color(0xFF8E8E93), fontSize: 16)),
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
