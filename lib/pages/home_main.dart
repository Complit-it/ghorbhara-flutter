import 'package:flutter/material.dart';
import 'package:hello_world/data/dummy_data.dart';
import 'package:hello_world/models/property.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'components/home_first_corousel.dart';
import 'components/home_third_corousel.dart';
import 'lizure_page.dart';
import 'search_page.dart';
import 'list_all_props.dart';
import 'new_property.dart';

class HomeMain extends StatefulWidget {
  const HomeMain({super.key});

  @override
  State<HomeMain> createState() => _HomeMainState();
}

class _HomeMainState extends State<HomeMain> {
  List<Property> _filteredProperties = DummyData.dummyProperties;
  String? _userName;
  int _selectedCategory = 0;
  final TextEditingController _searchController = TextEditingController();

  static const List<Map<String, dynamic>> _categories = [
    {'label': 'All', 'typeId': null, 'icon': Icons.apps_rounded},
    {'label': 'Apartment', 'typeId': '1', 'icon': Icons.apartment_rounded},
    {'label': 'Studio', 'typeId': '2', 'icon': Icons.single_bed_rounded},
    {'label': 'Villa', 'typeId': '3', 'icon': Icons.villa_rounded},
    {'label': 'Room Share', 'typeId': '4', 'icon': Icons.meeting_room_rounded},
  ];

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) setState(() => _userName = prefs.getString('name'));
  }

  void _filterByCategory(int idx) {
    setState(() {
      _selectedCategory = idx;
      final typeId = _categories[idx]['typeId'] as String?;
      _filteredProperties = typeId == null
          ? DummyData.dummyProperties
          : DummyData.dummyProperties
              .where((p) => p.propertyTypeId == typeId)
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'Good morning'
        : hour < 17
            ? 'Good afternoon'
            : 'Good evening';
    final name = _userName?.split(' ').first ?? 'there';

    return ColoredBox(
      color: const Color(0xFFF4F5F8),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(greeting, name),
            _buildSearchBar(),
            _buildCategoryChips(),
            CorouselOne(properties: _filteredProperties),
          _buildLizureBanner(),
            _buildPlacesNearYou(),
            _buildQuickActions(),
            const CorouselThree(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String greeting, String name) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 50, 20, 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1E0B6E), Color(0xFF3D22B8), Color(0xFF6246EA)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.location_on_rounded,
                        color: Colors.white, size: 13),
                    SizedBox(width: 4),
                    Text(
                      'Guwahati, Assam',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const NewProp()),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 9),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add_rounded,
                          color: Color(0xFF6246EA), size: 16),
                      SizedBox(width: 5),
                      Text(
                        'List Property',
                        style: TextStyle(
                          color: Color(0xFF6246EA),
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            '$greeting,',
            style: const TextStyle(
              color: Color(0xFFBBAEFF),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w800,
              fontFamily: 'Hind',
              height: 1.1,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildHeaderStat('120+', 'Properties'),
              _buildStatDivider(),
              _buildHeaderStat('50+', 'Owners'),
              _buildStatDivider(),
              _buildHeaderStat('4.8 ★', 'Avg Rating'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderStat(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Color(0xFFBBAEFF), fontSize: 11),
        ),
      ],
    );
  }

  Widget _buildStatDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: 1,
        height: 30,
        color: Colors.white.withValues(alpha: 0.2),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.07),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onSubmitted: (val) {
                  _searchController.clear();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => SearchPage(searchText: val)),
                  );
                },
                decoration: const InputDecoration(
                  hintText: 'Search city, area, locality...',
                  hintStyle:
                      TextStyle(color: Color(0xFFAAAAAA), fontSize: 14),
                  prefixIcon:
                      Icon(Icons.search_rounded, color: Color(0xFF6246EA)),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Advanced filters coming soon'),
                behavior: SnackBarBehavior.floating,
                duration: Duration(seconds: 2),
              ),
            ),
            child: Container(
              height: 52,
              width: 52,
              decoration: BoxDecoration(
                color: const Color(0xFF6246EA),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6246EA).withValues(alpha: 0.4),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Icon(Icons.tune_rounded,
                  color: Colors.white, size: 22),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChips() {
    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final cat = _categories[index];
          final selected = _selectedCategory == index;
          return GestureDetector(
            onTap: () => _filterByCategory(index),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: selected ? const Color(0xFF6246EA) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: selected
                      ? const Color(0xFF6246EA)
                      : const Color(0xFFE0E0E0),
                ),
                boxShadow: selected
                    ? [
                        BoxShadow(
                          color: const Color(0xFF6246EA).withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        )
                      ]
                    : [],
              ),
              child: Row(
                children: [
                  Icon(
                    cat['icon'] as IconData,
                    size: 15,
                    color:
                        selected ? Colors.white : const Color(0xFF6246EA),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    cat['label'] as String,
                    style: TextStyle(
                      color: selected
                          ? Colors.white
                          : const Color(0xFF555555),
                      fontWeight: selected
                          ? FontWeight.w600
                          : FontWeight.normal,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLizureBanner() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          16, 20, 16, 8), // top margin added here
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const LizurePage()),
        ),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF11998E), Color(0xFF38EF7D)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF11998E).withValues(alpha: 0.25),
                blurRadius: 10,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.landscape_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Lizure Trips',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Hind',
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Join weekend getaways near Assam & Guwahati',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  static const List<_PlaceData> _places = [
    _PlaceData(name: 'Kamakhya Temple', category: 'Temple', icon: Icons.temple_hindu_rounded, imageUrl: 'https://images.unsplash.com/photo-1564507592333-c60657eea523?w=300&h=200&fit=crop&q=80', distance: '8.4 km', rating: 4.8, sponsored: false),
    _PlaceData(name: 'Vivanta Guwahati', category: 'Hotel', icon: Icons.hotel_rounded, imageUrl: 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=300&h=200&fit=crop&q=80', distance: '1.2 km', rating: 4.6, sponsored: true),
    _PlaceData(name: 'Umananda Island', category: 'Attraction', icon: Icons.landscape_rounded, imageUrl: 'https://images.unsplash.com/photo-1501594907352-04cda38ebc29?w=300&h=200&fit=crop&q=80', distance: '2.3 km', rating: 4.5, sponsored: false),
    _PlaceData(name: 'Radisson Blu', category: 'Hotel', icon: Icons.hotel_rounded, imageUrl: 'https://images.unsplash.com/photo-1551882547-ff40c63fe5fa?w=300&h=200&fit=crop&q=80', distance: '3.1 km', rating: 4.7, sponsored: true),
    _PlaceData(name: 'Assam State Zoo', category: 'Zoo', icon: Icons.pets_rounded, imageUrl: 'https://images.unsplash.com/photo-1474511320723-9a56873867b5?w=300&h=200&fit=crop&q=80', distance: '6.1 km', rating: 4.3, sponsored: false),
    _PlaceData(name: 'Paradise Restaurant', category: 'Restaurant', icon: Icons.restaurant_rounded, imageUrl: 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=300&h=200&fit=crop&q=80', distance: '0.5 km', rating: 4.4, sponsored: true),
    _PlaceData(name: 'Nehru Park', category: 'Park', icon: Icons.park_rounded, imageUrl: 'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=300&h=200&fit=crop&q=80', distance: '3.2 km', rating: 4.2, sponsored: false),
    _PlaceData(name: 'Naga Kitchen', category: 'Restaurant', icon: Icons.restaurant_rounded, imageUrl: 'https://images.unsplash.com/photo-1585937421612-70a008356fbe?w=300&h=200&fit=crop&q=80', distance: '1.8 km', rating: 4.6, sponsored: false),
  ];

  Widget _buildPlacesNearYou() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Places Near You',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A2E),
                      fontFamily: 'Hind',
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          size: 12, color: Color(0xFF8E8E93)),
                      const SizedBox(width: 3),
                      const Text(
                        'Guwahati area',
                        style: TextStyle(
                            color: Color(0xFF8E8E93), fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF8E1),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                          color: const Color(0xFFFFCC02)
                              .withValues(alpha: 0.5)),
                    ),
                    child: const Text(
                      'Ad slots available',
                      style: TextStyle(
                          color: Color(0xFF92400E),
                          fontSize: 9,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _places.length,
            itemBuilder: (context, index) =>
                _PlaceCard(place: _places[index]),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A2E),
              fontFamily: 'Hind',
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ListAllProp()),
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6246EA).withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                          color: const Color(0xFF6246EA).withValues(alpha: 0.2)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.search_rounded,
                            color: Color(0xFF6246EA), size: 22),
                        SizedBox(width: 10),
                        Text('Browse All',
                            style: TextStyle(
                                color: Color(0xFF6246EA),
                                fontWeight: FontWeight.w600,
                                fontSize: 13)),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const NewProp()),
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(left: 8),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF11998E).withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                          color: const Color(0xFF11998E).withValues(alpha: 0.2)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.add_home_rounded,
                            color: Color(0xFF11998E), size: 22),
                        SizedBox(width: 10),
                        Text('List Property',
                            style: TextStyle(
                                color: Color(0xFF11998E),
                                fontWeight: FontWeight.w600,
                                fontSize: 13)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PlaceData {
  final String name;
  final String category;
  final IconData icon;
  final String imageUrl;
  final String distance;
  final double rating;
  final bool sponsored;

  const _PlaceData({
    required this.name,
    required this.category,
    required this.icon,
    required this.imageUrl,
    required this.distance,
    required this.rating,
    required this.sponsored,
  });
}

class _PlaceCard extends StatelessWidget {
  final _PlaceData place;
  const _PlaceCard({required this.place});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  place.imageUrl,
                  width: 160,
                  height: 110,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 160,
                    height: 110,
                    decoration: BoxDecoration(
                      color: const Color(0xFF6246EA).withValues(alpha: 0.1),
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16)),
                    ),
                    child: Icon(place.icon,
                        size: 38, color: const Color(0xFF6246EA)),
                  ),
                ),
              ),
              if (place.sponsored)
                Positioned(
                  top: 6,
                  left: 6,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFCC02),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'Ad',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF5C3D00),
                      ),
                    ),
                  ),
                ),
              Positioned(
                bottom: 6,
                right: 6,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.55),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.star_rounded,
                          size: 10, color: Color(0xFFFFCC02)),
                      const SizedBox(width: 2),
                      Text(
                        place.rating.toStringAsFixed(1),
                        style: const TextStyle(
                            fontSize: 9,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 7, 8, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  place.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Icon(place.icon, size: 11, color: const Color(0xFF8E8E93)),
                    const SizedBox(width: 3),
                    Text(
                      place.category,
                      style: const TextStyle(
                          fontSize: 10, color: Color(0xFF8E8E93)),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    const Icon(Icons.near_me_rounded,
                        size: 11, color: Color(0xFF11998E)),
                    const SizedBox(width: 3),
                    Text(
                      place.distance,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xFF11998E),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
