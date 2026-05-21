import 'package:flutter/material.dart';
import 'package:hello_world/data/dummy_data.dart';
import 'package:hello_world/models/property.dart';
import 'package:hello_world/pages/components/reusables/property_card.dart';

class FavProps extends StatefulWidget {
  const FavProps({super.key});

  @override
  State<FavProps> createState() => _FavPropsState();
}

class _FavPropsState extends State<FavProps> {
  List<Property> get _favProps =>
      DummyData.dummyProperties.where((p) => p.isFav == true).toList();

  @override
  Widget build(BuildContext context) {
    final favs = _favProps;
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
            'Saved Properties',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              fontFamily: 'Hind',
            ),
          ),
        ),
      ),
      body: favs.isEmpty
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
                    child: const Icon(Icons.favorite_border_rounded,
                        color: Color(0xFF6246EA), size: 48),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'No saved properties yet',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Tap the heart icon on any property to save it here.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFF8E8E93), fontSize: 14),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              itemCount: favs.length,
              itemBuilder: (context, index) => PropertyCard(
                property: favs[index],
                showFavBtn: false,
              ),
            ),
    );
  }
}
