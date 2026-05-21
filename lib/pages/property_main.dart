import 'package:flutter/material.dart';
import 'package:hello_world/data/dummy_data.dart';
import 'package:hello_world/models/property.dart';
import 'package:hello_world/pages/chat_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PropertyMainScreen extends StatefulWidget {
  final Property property;
  const PropertyMainScreen({super.key, required this.property});

  @override
  State<PropertyMainScreen> createState() => _PropertyMainScreenState();
}

class _PropertyMainScreenState extends State<PropertyMainScreen> {
  bool _isFav = false;
  int _currentImageIndex = 0;
  int _currentUserId = 0;
  final PageController _pageController = PageController();

  static const List<List<Color>> _gradients = [
    [Color(0xFF667EEA), Color(0xFF764BA2)],
    [Color(0xFF11998E), Color(0xFF38EF7D)],
    [Color(0xFFF7971E), Color(0xFFFFD200)],
    [Color(0xFFEB3349), Color(0xFFF45C43)],
    [Color(0xFF2193B0), Color(0xFF6DD5ED)],
    [Color(0xFF834D9B), Color(0xFFD04ED6)],
  ];

  @override
  void initState() {
    super.initState();
    _isFav = widget.property.isFav ?? false;
    _loadCurrentUser();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) setState(() => _currentUserId = prefs.getInt('userId') ?? 0);
  }

  String get _propertyTypeLabel {
    switch (widget.property.propertyTypeId) {
      case '1':
        return 'Apartment';
      case '2':
        return 'Studio';
      case '3':
        return 'Villa';
      case '4':
        return 'Room Share';
      default:
        return 'Property';
    }
  }

  List<Color> get _gradient =>
      _gradients[widget.property.id % _gradients.length];

  void _openChatWithOwner() {
    final ownerUserId = int.tryParse(widget.property.userId ?? '1') ?? 1;
    final owner = DummyData.getUserById(ownerUserId);
    if (owner == null) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LocalChatScreen(
          otherUserId: ownerUserId,
          otherUserName: owner.name ?? 'Owner',
        ),
      ),
    );
  }

  void _showBookingDialog() {
    final price = widget.property.price ?? '0';
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Book Property',
            style: TextStyle(
                fontFamily: 'Hind',
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A2E))),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.property.title,
                style: const TextStyle(
                    fontSize: 15, color: Color(0xFF555555))),
            const SizedBox(height: 8),
            Text('Monthly Rent: Rs $price',
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF6246EA))),
            const SizedBox(height: 12),
            const Text('Choose a payment option:',
                style: TextStyle(color: Color(0xFF8E8E93), fontSize: 13)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _confirmBooking('Pay at Property');
            },
            child: const Text('Pay at Property',
                style: TextStyle(color: Color(0xFF8E8E93))),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _confirmBooking('Pay Now');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6246EA),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Pay Now',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _confirmBooking(String method) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Property booked successfully! ($method)'),
        backgroundColor: const Color(0xFF6246EA),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final images = DummyData.getPropertyImages(widget.property.id);
    final ownerUserId = int.tryParse(widget.property.userId ?? '1') ?? 1;
    final owner = DummyData.getUserById(ownerUserId);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FF),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: _gradient[0],
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: Color(0xFF6246EA), size: 18),
              ),
            ),
            actions: [
              GestureDetector(
                onTap: () => setState(() {
                  _isFav = !_isFav;
                  widget.property.isFav = _isFav;
                }),
                child: Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isFav ? Icons.favorite : Icons.favorite_border,
                    color: _isFav ? Colors.red : const Color(0xFF6246EA),
                    size: 20,
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  PageView.builder(
                    controller: _pageController,
                    itemCount: images.length,
                    onPageChanged: (i) =>
                        setState(() => _currentImageIndex = i),
                    itemBuilder: (context, index) => Image.network(
                      images[index],
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (_, __, ___) => Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: _gradient,
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: const Center(
                          child: Icon(Icons.home_rounded,
                              size: 80, color: Colors.white54),
                        ),
                      ),
                    ),
                  ),
                  if (images.length > 1)
                    Positioned(
                      bottom: 12,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          images.length,
                          (i) => AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            width: _currentImageIndex == i ? 16 : 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: _currentImageIndex == i
                                  ? Colors.white
                                  : Colors.white54,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: _gradient[0].withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _propertyTypeLabel,
                          style: TextStyle(
                              color: _gradient[0],
                              fontWeight: FontWeight.w600,
                              fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.property.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A1A2E),
                      fontFamily: 'Hind',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          color: Color(0xFF6246EA), size: 16),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          widget.property.location?.location ??
                              widget.property.address,
                          style: const TextStyle(
                              color: Color(0xFF8E8E93), fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      _statChip(Icons.bed_outlined,
                          '${widget.property.rooms} Rooms'),
                      const SizedBox(width: 12),
                      _statChip(Icons.square_foot_rounded,
                          '${widget.property.area} m²'),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _sectionTitle('Owner'),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor:
                              _gradient[0].withValues(alpha: 0.15),
                          child: Text(
                            (owner?.name ?? 'O')[0].toUpperCase(),
                            style: TextStyle(
                              color: _gradient[0],
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                owner?.name ?? 'Property Owner',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: Color(0xFF1A1A2E),
                                ),
                              ),
                              const Text(
                                'Property Owner',
                                style: TextStyle(
                                    color: Color(0xFF8E8E93), fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: _currentUserId != ownerUserId
                              ? _openChatWithOwner
                              : null,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: _currentUserId != ownerUserId
                                  ? const Color(0xFF6246EA)
                                  : Colors.grey[200],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.chat_bubble_outline_rounded,
                              color: _currentUserId != ownerUserId
                                  ? Colors.white
                                  : Colors.grey,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (widget.property.homeFacilities != null &&
                      widget.property.homeFacilities!.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    _sectionTitle('Features & Amenities'),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: widget.property.homeFacilities!
                          .map((hf) => _facilityChip(hf.facility.facility))
                          .toList(),
                    ),
                  ],
                  const SizedBox(height: 24),
                  _sectionTitle('About This Home'),
                  const SizedBox(height: 10),
                  Text(
                    widget.property.about,
                    style: const TextStyle(
                      color: Color(0xFF555555),
                      fontSize: 14,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _sectionTitle('Location'),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF6246EA).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.location_on,
                              color: Color(0xFF6246EA), size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.property.location?.location ??
                                    'Location',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF1A1A2E),
                                    fontSize: 14),
                              ),
                              Text(
                                widget.property.address,
                                style: const TextStyle(
                                    color: Color(0xFF8E8E93), fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Monthly Rent',
                      style: TextStyle(
                          color: Color(0xFF8E8E93), fontSize: 12)),
                  Text(
                    'Rs ${widget.property.price ?? "N/A"}',
                    style: const TextStyle(
                      color: Color(0xFF6246EA),
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Hind',
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: _showBookingDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6246EA),
                padding: const EdgeInsets.symmetric(
                    horizontal: 28, vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
              child: const Text(
                'Book Now',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Color(0xFF1A1A2E),
        fontFamily: 'Hind',
      ),
    );
  }

  Widget _statChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: const Color(0xFF6246EA)),
          const SizedBox(width: 6),
          Text(label,
              style: const TextStyle(
                  color: Color(0xFF555555),
                  fontWeight: FontWeight.w500,
                  fontSize: 13)),
        ],
      ),
    );
  }

  Widget _facilityChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF6246EA).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: const Color(0xFF6246EA).withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle_rounded,
              size: 14, color: Color(0xFF6246EA)),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
                color: Color(0xFF6246EA),
                fontSize: 12,
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
