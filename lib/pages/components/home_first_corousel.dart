import 'package:flutter/material.dart';
import 'package:hello_world/data/dummy_data.dart';
import 'package:hello_world/models/property.dart';
import 'package:hello_world/pages/list_all_props.dart';
import 'package:hello_world/pages/property_main.dart';

class CorouselOne extends StatefulWidget {
  final List<Property> properties;
  const CorouselOne({super.key, required this.properties});

  @override
  State<CorouselOne> createState() => _CorouselOneState();
}

class _CorouselOneState extends State<CorouselOne> {
  static const List<List<Color>> _gradients = [
    [Color(0xFF667EEA), Color(0xFF764BA2)],
    [Color(0xFF11998E), Color(0xFF38EF7D)],
    [Color(0xFFF7971E), Color(0xFFFFD200)],
    [Color(0xFFEB3349), Color(0xFFF45C43)],
    [Color(0xFF2193B0), Color(0xFF6DD5ED)],
    [Color(0xFF834D9B), Color(0xFFD04ED6)],
  ];

  static const List<IconData> _propIcons = [
    Icons.apartment_rounded,
    Icons.single_bed_rounded,
    Icons.villa_rounded,
    Icons.meeting_room_rounded,
    Icons.house_rounded,
    Icons.home_work_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Featured Properties',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Hind',
                  color: Color(0xFF1A1A2E),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ListAllProp()),
                ),
                child: const Text(
                  'See all',
                  style: TextStyle(
                    color: Color(0xFF6246EA),
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 20, bottom: 12),
          child: Text(
            'Top picks near you',
            style: TextStyle(color: Color(0xFF8E8E93), fontSize: 13),
          ),
        ),
        SizedBox(
          height: 255,
          child: widget.properties.isEmpty
              ? const Center(
                  child: Text('No properties available',
                      style: TextStyle(color: Color(0xFF8E8E93))))
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount:
                      widget.properties.length > 6 ? 6 : widget.properties.length,
                  itemBuilder: (context, index) {
                    final property = widget.properties[index];
                    final gradIdx = property.id % _gradients.length;
                    final typeIdx =
                        (int.tryParse(property.propertyTypeId) ?? 1) - 1;
                    final icon =
                        _propIcons[typeIdx.clamp(0, _propIcons.length - 1)];
                    final gradient = _gradients[gradIdx];
                    final typeLabel = const {
                      '1': 'Apartment', '2': 'Studio',
                      '3': 'Villa', '4': 'Room Share'
                    }[property.propertyTypeId] ?? 'Property';

                    return GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                PropertyMainScreen(property: property)),
                      ),
                      child: Container(
                        width: 210,
                        margin: const EdgeInsets.only(right: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.09),
                              blurRadius: 16,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 140,
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(18)),
                                    child: Image.network(
                                      DummyData.getPropertyImages(property.id).first,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: gradient,
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius:
                                              const BorderRadius.vertical(
                                                  top: Radius.circular(18)),
                                        ),
                                        child: Center(
                                          child: Icon(icon,
                                              size: 52,
                                              color: Colors.white
                                                  .withValues(alpha: 0.85)),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // type badge
                                  Positioned(
                                    top: 10,
                                    left: 10,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: gradient[0],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        typeLabel,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                  // fav button
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: GestureDetector(
                                      onTap: () => setState(() {
                                        property.isFav =
                                            !(property.isFav ?? false);
                                      }),
                                      child: Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: Colors.white
                                              .withValues(alpha: 0.92),
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withValues(alpha: 0.1),
                                              blurRadius: 4,
                                            ),
                                          ],
                                        ),
                                        child: Icon(
                                          (property.isFav ?? false)
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color: (property.isFav ?? false)
                                              ? Colors.red
                                              : Colors.grey[500],
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      property.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13,
                                        color: Color(0xFF1A1A2E),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        const Icon(Icons.location_on,
                                            size: 12,
                                            color: Color(0xFF8E8E93)),
                                        const SizedBox(width: 2),
                                        Expanded(
                                          child: Text(
                                            property.location?.location ?? 'N/A',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontSize: 11,
                                                color: Color(0xFF8E8E93)),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Rs ${property.price ?? "N/A"}/mo',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14,
                                            color: Color(0xFF6246EA),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            const Icon(Icons.bed_outlined,
                                                size: 13,
                                                color: Color(0xFF8E8E93)),
                                            const SizedBox(width: 2),
                                            Text(
                                              '${property.rooms} bed',
                                              style: const TextStyle(
                                                  fontSize: 11,
                                                  color: Color(0xFF8E8E93)),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Icon(
                                            Icons.near_me_rounded,
                                            size: 11,
                                            color: Color(0xFF11998E)),
                                        const SizedBox(width: 3),
                                        Text(
                                          DummyData.getDistanceLabel(property.id),
                                          style: const TextStyle(
                                              fontSize: 10,
                                              color: Color(0xFF11998E),
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
