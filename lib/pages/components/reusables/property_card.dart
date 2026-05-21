import 'package:flutter/material.dart';
import 'package:hello_world/data/dummy_data.dart';
import 'package:hello_world/models/property.dart';
import '../../property_main.dart';

class PropertyCard extends StatefulWidget {
  final Property property;
  final bool? showFavBtn;
  const PropertyCard({super.key, required this.property, this.showFavBtn});

  @override
  State<PropertyCard> createState() => _PropertyCardState();
}

class _PropertyCardState extends State<PropertyCard> {
  late bool showFavBtn;

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
  void initState() {
    super.initState();
    showFavBtn = widget.showFavBtn ?? true;
  }

  String _typeLabel(String typeId) {
    switch (typeId) {
      case '1': return 'Apartment';
      case '2': return 'Studio';
      case '3': return 'Villa';
      case '4': return 'Room Share';
      default:  return 'Property';
    }
  }

  @override
  Widget build(BuildContext context) {
    final gradIdx = widget.property.id % _gradients.length;
    final typeIdx = (int.tryParse(widget.property.propertyTypeId) ?? 1) - 1;
    final icon = _propIcons[typeIdx.clamp(0, _propIcons.length - 1)];
    final gradient = _gradients[gradIdx];

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => PropertyMainScreen(property: widget.property)),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.07),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
              child: SizedBox(
                width: 110,
                height: 130,
                child: Image.network(
                  DummyData.getPropertyImages(widget.property.id).first,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: gradient,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Center(
                      child: Icon(icon,
                          size: 42,
                          color: Colors.white.withValues(alpha: 0.9)),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: gradient[0].withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _typeLabel(widget.property.propertyTypeId),
                            style: TextStyle(
                              color: gradient[0],
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        if (showFavBtn)
                          GestureDetector(
                            onTap: () => setState(() {
                              widget.property.isFav =
                                  !(widget.property.isFav ?? false);
                            }),
                            child: Icon(
                              (widget.property.isFav ?? false)
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: (widget.property.isFav ?? false)
                                  ? Colors.red
                                  : Colors.grey[400],
                              size: 20,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.property.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: Color(0xFF1A1A2E),
                        fontFamily: 'Hind',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on,
                            size: 13, color: Color(0xFF8E8E93)),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            widget.property.location?.location ?? 'Location N/A',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 12, color: Color(0xFF8E8E93)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.bed_outlined,
                            size: 14, color: Color(0xFF8E8E93)),
                        const SizedBox(width: 3),
                        Text('${widget.property.rooms} rooms',
                            style: const TextStyle(
                                fontSize: 12, color: Color(0xFF8E8E93))),
                        const SizedBox(width: 10),
                        const Icon(Icons.square_foot_rounded,
                            size: 14, color: Color(0xFF8E8E93)),
                        const SizedBox(width: 3),
                        Text('${widget.property.area} m²',
                            style: const TextStyle(
                                fontSize: 12, color: Color(0xFF8E8E93))),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Rs ${widget.property.price ?? "N/A"}/month',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            color: Color(0xFF6246EA),
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.near_me_rounded,
                                size: 11, color: Color(0xFF11998E)),
                            const SizedBox(width: 3),
                            Text(
                              DummyData.getDistanceLabel(widget.property.id),
                              style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF11998E),
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
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
  }
}
