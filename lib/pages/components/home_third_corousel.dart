import 'package:flutter/material.dart';

class CorouselThree extends StatelessWidget {
  const CorouselThree({super.key});

  static const List<Map<String, dynamic>> _tips = [
    {
      'title': 'Verify Before You Rent',
      'desc':
          'Always visit the property in person and check all documents before signing any agreement.',
      'icon': Icons.verified_user_rounded,
      'gradient': [Color(0xFF667EEA), Color(0xFF764BA2)],
    },
    {
      'title': 'Understand the Lease',
      'desc':
          'Read every clause carefully. Know your notice period, deposit terms, and maintenance responsibilities.',
      'icon': Icons.description_rounded,
      'gradient': [Color(0xFF11998E), Color(0xFF38EF7D)],
    },
    {
      'title': 'Document Everything',
      'desc':
          'Take photos on move-in day and keep all payment receipts to avoid disputes later.',
      'icon': Icons.photo_camera_rounded,
      'gradient': [Color(0xFFF7971E), Color(0xFFFFD200)],
    },
    {
      'title': 'Know Your Rights',
      'desc':
          'As a tenant you have legal rights. A landlord cannot enter without prior notice.',
      'icon': Icons.gavel_rounded,
      'gradient': [Color(0xFFEB3349), Color(0xFFF45C43)],
    },
    {
      'title': 'Budget Beyond Rent',
      'desc':
          'Factor in utilities, maintenance charges, and advance deposit when calculating total cost.',
      'icon': Icons.calculate_rounded,
      'gradient': [Color(0xFF2193B0), Color(0xFF6DD5ED)],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 16, 20, 4),
          child: Text(
            'Smart Renting Tips',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              fontFamily: 'Hind',
              color: Color(0xFF1A1A2E),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 20, bottom: 12),
          child: Text(
            'Stay informed, rent smart',
            style: TextStyle(color: Color(0xFF8E8E93), fontSize: 13),
          ),
        ),
        SizedBox(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _tips.length,
            itemBuilder: (context, index) {
              final tip = _tips[index];
              final colors = tip['gradient'] as List<Color>;
              return Container(
                width: 220,
                margin: const EdgeInsets.only(right: 14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: colors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: colors[0].withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(tip['icon'] as IconData,
                          color: Colors.white, size: 28),
                      const Spacer(),
                      Text(
                        tip['title'] as String,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          fontFamily: 'Hind',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        tip['desc'] as String,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 11),
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
