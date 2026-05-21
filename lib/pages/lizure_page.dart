import 'package:flutter/material.dart';

// ─── Data models ──────────────────────────────────────────────────────────────

enum _TripTier { standard, premium }

enum _TripDuration { dayTrip, weekend, longHoliday }

class _TripGroup {
  final String destination;
  final String description;
  final String imageUrl;
  final String locationLabel;
  final int perPerson;
  final int maxMembers;
  int joinedMembers;
  final String date;
  final List<String> tags;
  final _TripTier tier;
  final _TripDuration duration;
  final String organizer;
  final String? partnerHotel;
  final int platformFeePercent;
  bool hasBooked = false;

  _TripGroup({
    required this.destination,
    required this.description,
    required this.imageUrl,
    required this.locationLabel,
    required this.perPerson,
    required this.maxMembers,
    required this.joinedMembers,
    required this.date,
    required this.tags,
    required this.organizer,
    this.tier = _TripTier.standard,
    this.duration = _TripDuration.weekend,
    this.partnerHotel,
    this.platformFeePercent = 12,
  });

  int get spotsLeft => maxMembers - joinedMembers;
  double get fillFraction => joinedMembers / maxMembers;
  int get platformFee => (perPerson * platformFeePercent / 100).round();
  int get travelPool => perPerson - platformFee;
  int get totalGroupPool => travelPool * maxMembers;
}

String _fmt(int n) => n.toString().replaceAllMapped(
    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');

// ─── Page ─────────────────────────────────────────────────────────────────────

class LizurePage extends StatefulWidget {
  const LizurePage({super.key});

  @override
  State<LizurePage> createState() => _LizurePageState();
}

class _LizurePageState extends State<LizurePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  _TripDuration? _selectedDuration;

  final List<_TripGroup> _trips = [
    _TripGroup(
      destination: 'Kaziranga National Park',
      description:
          'One-horned rhino safari, elephant rides and jungle camp under the stars. Includes park entry, guide and all meals.',
      imageUrl:
          'https://images.unsplash.com/photo-1561731216-c3a4d99437d5?w=800&h=500&fit=crop&q=80',
      locationLabel: 'Golaghat, Assam · 217 km · 4h drive',
      perPerson: 3500,
      maxMembers: 12,
      joinedMembers: 7,
      date: 'Jun 14–15, 2026',
      tags: ['Wildlife', 'Safari', 'Nature'],
      organizer: 'Raju D.',
      tier: _TripTier.premium,
      duration: _TripDuration.weekend,
      partnerHotel: 'Infinity Resort Kaziranga',
    ),
    _TripGroup(
      destination: 'Shillong Weekend Getaway',
      description:
          'Scotland of the East — waterfalls, living root bridges, cafés and the legendary Friday music scene at Police Bazar.',
      imageUrl:
          'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800&h=500&fit=crop&q=80',
      locationLabel: 'Shillong, Meghalaya · 100 km · 3h drive',
      perPerson: 2800,
      maxMembers: 10,
      joinedMembers: 4,
      date: 'Jun 21–22, 2026',
      tags: ['Hills', 'Culture', 'Music'],
      organizer: 'Priya S.',
      tier: _TripTier.standard,
      duration: _TripDuration.weekend,
    ),
    _TripGroup(
      destination: 'Cherrapunji & Mawlynnong',
      description:
          'Visit the wettest place on earth and Asia\'s cleanest village. Root bridge trek, Nohkalikai Falls, and cloud-level stays.',
      imageUrl:
          'https://images.unsplash.com/photo-1432405972618-c60b0225b8f9?w=800&h=500&fit=crop&q=80',
      locationLabel: 'East Khasi Hills · 173 km · 5h drive',
      perPerson: 4200,
      maxMembers: 8,
      joinedMembers: 3,
      date: 'Jul 5–7, 2026',
      tags: ['Waterfall', 'Trekking', 'Village'],
      organizer: 'Aman B.',
      tier: _TripTier.premium,
      duration: _TripDuration.longHoliday,
      partnerHotel: 'Cherrapunjee Holiday Resort',
    ),
    _TripGroup(
      destination: 'Majuli River Island',
      description:
          'World\'s largest river island — Vaishnavite monasteries, Mising tribe culture, bamboo huts and Brahmaputra sunsets.',
      imageUrl:
          'https://images.unsplash.com/photo-1501854140801-50d01698950b?w=800&h=500&fit=crop&q=80',
      locationLabel: 'Jorhat, Assam · 310 km · 5h drive',
      perPerson: 2500,
      maxMembers: 10,
      joinedMembers: 6,
      date: 'Jul 12–13, 2026',
      tags: ['Island', 'Culture', 'Relaxation'],
      organizer: 'Dimpu K.',
      tier: _TripTier.standard,
      duration: _TripDuration.weekend,
    ),
    _TripGroup(
      destination: 'Haflong Hill Station',
      description:
          'Assam\'s only hill station — Haflong Lake boat rides, Jatinga bird mystery trail, and crisp mountain air escapes.',
      imageUrl:
          'https://images.unsplash.com/photo-1518495973542-4542c06a5843?w=800&h=500&fit=crop&q=80',
      locationLabel: 'Dima Hasao, Assam · 340 km · 6h drive',
      perPerson: 3200,
      maxMembers: 8,
      joinedMembers: 2,
      date: 'Jul 19–20, 2026',
      tags: ['Hill Station', 'Lake', 'Peace'],
      organizer: 'Meena R.',
      tier: _TripTier.standard,
      duration: _TripDuration.weekend,
    ),
    _TripGroup(
      destination: 'Pobitora Wildlife Day Trip',
      description:
          'Highest rhino density in the world, just 60 km from Guwahati. Morning safari, birding and packed lunch included.',
      imageUrl:
          'https://images.unsplash.com/photo-1474511320723-9a56873867b5?w=800&h=500&fit=crop&q=80',
      locationLabel: 'Morigaon, Assam · 60 km · 1.5h drive',
      perPerson: 1200,
      maxMembers: 15,
      joinedMembers: 9,
      date: 'Jun 8, 2026',
      tags: ['Day Trip', 'Wildlife', 'Photography'],
      organizer: 'Bikash P.',
      tier: _TripTier.standard,
      duration: _TripDuration.dayTrip,
    ),
    _TripGroup(
      destination: 'Tawang Monastery Long Trip',
      description:
          'Arunachal\'s gem — Tawang Monastery, Sela Pass snow, Madhuri Lake and the ancient Tibetan Buddhist culture. 3N/4D.',
      imageUrl:
          'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=800&h=500&fit=crop&q=80',
      locationLabel: 'Tawang, Arunachal · 540 km · 12h drive',
      perPerson: 7500,
      maxMembers: 8,
      joinedMembers: 2,
      date: 'Aug 2–5, 2026',
      tags: ['Mountains', 'Monastery', 'Snow'],
      organizer: 'Lobsang T.',
      tier: _TripTier.premium,
      duration: _TripDuration.longHoliday,
      partnerHotel: 'Hotel Tawang Abode',
      platformFeePercent: 10,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          _selectedDuration = [
            null,
            _TripDuration.dayTrip,
            _TripDuration.weekend,
            _TripDuration.longHoliday,
          ][_tabController.index];
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<_TripGroup> get _filteredTrips => _selectedDuration == null
      ? _trips
      : _trips.where((t) => t.duration == _selectedDuration).toList();

  int get _totalTravelers =>
      _trips.fold(0, (sum, t) => sum + t.joinedMembers);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F8),
      body: CustomScrollView(
        slivers: [
          _buildSliverHeader(),
          _buildStatsBar(),
          _buildRevenueCallout(),
          _buildTabBar(),
          _buildTripGrid(),
          _buildOrganizerCTA(),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }

  // ── Sliver Header ────────────────────────────────────────────────────────────
  Widget _buildSliverHeader() {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: const Color(0xFF0A7A5E),
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Color(0xFF0A7A5E), size: 18),
        ),
      ),
      actions: [
        GestureDetector(
          onTap: _showCreateTripSheet,
          child: Container(
            margin: const EdgeInsets.all(8),
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
              border:
                  Border.all(color: Colors.white.withValues(alpha: 0.4)),
            ),
            child: const Row(
              children: [
                Icon(Icons.add, color: Colors.white, size: 14),
                SizedBox(width: 3),
                Text('Host',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF0A7A5E),
                Color(0xFF11998E),
                Color(0xFF38EF7D)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 52, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFD700).withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                          color:
                              const Color(0xFFFFD700).withValues(alpha: 0.5)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star_rounded,
                            color: Color(0xFFFFD700), size: 12),
                        SizedBox(width: 4),
                        Text(
                          'Revenue Feature',
                          style: TextStyle(
                              color: Color(0xFFFFD700),
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Lizure Trips',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Hind',
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Group getaways near Assam & Guwahati\nJoin, host, and earn — all in one place.',
                    style: TextStyle(
                        color: Colors.white70, fontSize: 13, height: 1.4),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Stats Bar ────────────────────────────────────────────────────────────────
  Widget _buildStatsBar() {
    return SliverToBoxAdapter(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _StatPill(
                icon: Icons.groups_rounded,
                value: '$_totalTravelers',
                label: 'Travelers'),
            _divider(),
            _StatPill(
                icon: Icons.route_rounded,
                value: '${_trips.length}',
                label: 'Trips'),
            _divider(),
            const _StatPill(
                icon: Icons.hotel_rounded,
                value: '3',
                label: 'Partner Hotels'),
            _divider(),
            const _StatPill(
                icon: Icons.currency_rupee_rounded,
                value: '12%',
                label: 'Platform Fee'),
          ],
        ),
      ),
    );
  }

  Widget _divider() =>
      Container(width: 1, height: 32, color: const Color(0xFFEEEEEE));

  // ── Revenue Callout ──────────────────────────────────────────────────────────
  Widget _buildRevenueCallout() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF11998E).withValues(alpha: 0.08),
                const Color(0xFF38EF7D).withValues(alpha: 0.06),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
                color: const Color(0xFF11998E).withValues(alpha: 0.25)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.info_outline_rounded,
                      color: Color(0xFF11998E), size: 16),
                  SizedBox(width: 6),
                  Text(
                    'How Lizure works',
                    style: TextStyle(
                        color: Color(0xFF0A7A5E),
                        fontWeight: FontWeight.w700,
                        fontSize: 13),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _howItWorksRow('1.', 'Browse & join group trips near you'),
              _howItWorksRow('2.',
                  'Registration fee covers all travel expenses (transport, stays, meals)'),
              _howItWorksRow(
                  '3.', 'Ghorbhara collects 12% platform fee per booking as revenue'),
              _howItWorksRow('4.',
                  'Hosts/organizers earn 5% referral bonus from filled groups'),
              const SizedBox(height: 10),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF11998E),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Example: 12 people @ Rs 3,500 = Rs 42,000 group pool · Rs 5,040 platform revenue',
                  style: TextStyle(
                      color: Colors.white, fontSize: 11, height: 1.4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _howItWorksRow(String num, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(num,
              style: const TextStyle(
                  color: Color(0xFF11998E),
                  fontWeight: FontWeight.w700,
                  fontSize: 12)),
          const SizedBox(width: 6),
          Expanded(
            child: Text(text,
                style: const TextStyle(
                    color: Color(0xFF444444), fontSize: 12, height: 1.4)),
          ),
        ],
      ),
    );
  }

  // ── Tab Bar ──────────────────────────────────────────────────────────────────
  Widget _buildTabBar() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TabBar(
            controller: _tabController,
            indicatorColor: const Color(0xFF11998E),
            indicatorWeight: 2.5,
            labelColor: const Color(0xFF11998E),
            unselectedLabelColor: const Color(0xFF8E8E93),
            labelStyle:
                const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
            unselectedLabelStyle: const TextStyle(fontSize: 12),
            dividerColor: Colors.transparent,
            tabs: const [
              Tab(text: 'All'),
              Tab(text: 'Day Trip'),
              Tab(text: 'Weekend'),
              Tab(text: 'Long Trip'),
            ],
          ),
        ),
      ),
    );
  }

  // ── Trip Grid ────────────────────────────────────────────────────────────────
  Widget _buildTripGrid() {
    final trips = _filteredTrips;
    if (trips.isEmpty) {
      return const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40),
          child: Center(
            child: Text('No trips in this category yet.',
                style: TextStyle(color: Color(0xFF8E8E93), fontSize: 14)),
          ),
        ),
      );
    }
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.72,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final trip = trips[index];
            return _TripGridCard(
              trip: trip,
              onProceed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => _TripDetailPage(
                    trip: trip,
                    onBooked: () => setState(() {
                      if (!trip.hasBooked && trip.spotsLeft > 0) {
                        trip.joinedMembers++;
                        trip.hasBooked = true;
                      }
                    }),
                  ),
                ),
              ),
            );
          },
          childCount: trips.length,
        ),
      ),
    );
  }

  // ── Organizer CTA ────────────────────────────────────────────────────────────
  Widget _buildOrganizerCTA() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
        child: GestureDetector(
          onTap: _showCreateTripSheet,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6246EA), Color(0xFF9B79FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6246EA).withValues(alpha: 0.3),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Become a Trip Host',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Hind',
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Organize a group trip, fill 10 spots and earn up to Rs 1,750 referral bonus.',
                        style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            height: 1.4),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Create a Trip →',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                const Icon(Icons.explore_rounded,
                    size: 52, color: Colors.white38),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showCreateTripSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _CreateTripSheet(),
    );
  }
}

// ─── Trip Grid Card ────────────────────────────────────────────────────────────

class _TripGridCard extends StatelessWidget {
  final _TripGroup trip;
  final VoidCallback onProceed;
  const _TripGridCard({required this.trip, required this.onProceed});

  @override
  Widget build(BuildContext context) {
    final spotsLeft = trip.spotsLeft;
    final isPremium = trip.tier == _TripTier.premium;
    return GestureDetector(
      onTap: onProceed,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.07),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: Stack(
                children: [
                  Image.network(
                    trip.imageUrl,
                    height: 110,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 110,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF11998E), Color(0xFF38EF7D)],
                        ),
                      ),
                      child: const Center(
                        child: Icon(Icons.landscape_rounded,
                            size: 40, color: Colors.white54),
                      ),
                    ),
                  ),
                  if (isPremium)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFD700),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.workspace_premium_rounded,
                                size: 9, color: Color(0xFF7A4A00)),
                            SizedBox(width: 3),
                            Text('FEATURED',
                                style: TextStyle(
                                    color: Color(0xFF7A4A00),
                                    fontSize: 8,
                                    fontWeight: FontWeight.w800)),
                          ],
                        ),
                      ),
                    ),
                  if (trip.hasBooked)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFF34C759),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text('Booked',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.w700)),
                      ),
                    ),
                ],
              ),
            ),
            // Content
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.fromLTRB(10, 8, 10, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      trip.destination,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A2E),
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today_rounded,
                            size: 10, color: Color(0xFF11998E)),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            trip.date,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 10,
                                color: Color(0xFF11998E),
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    // Spots bar
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(3),
                            child: LinearProgressIndicator(
                              value: trip.fillFraction,
                              backgroundColor: const Color(0xFFE8F5F2),
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(
                                spotsLeft <= 3
                                    ? Colors.orange
                                    : const Color(0xFF11998E),
                              ),
                              minHeight: 4,
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '$spotsLeft left',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: spotsLeft <= 3
                                ? Colors.orange
                                : const Color(0xFF8E8E93),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    // Price
                    Text(
                      'Rs ${_fmt(trip.perPerson)}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                    const Text(
                      'per person',
                      style: TextStyle(
                          fontSize: 9, color: Color(0xFF8E8E93)),
                    ),
                    const SizedBox(height: 7),
                    // Proceed button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: onProceed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: trip.hasBooked
                              ? const Color(0xFF34C759)
                              : const Color(0xFF11998E),
                          padding:
                              const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(9)),
                          elevation: 0,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          trip.hasBooked ? 'Booked' : 'Proceed →',
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 12),
                        ),
                      ),
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

// ─── Trip Detail Page ──────────────────────────────────────────────────────────

class _TripDetailPage extends StatelessWidget {
  final _TripGroup trip;
  final VoidCallback onBooked;
  const _TripDetailPage({required this.trip, required this.onBooked});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F8),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              _buildHeader(context),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTagsAndOrganizer(),
                      const SizedBox(height: 12),
                      Text(
                        trip.destination,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1A1A2E),
                          fontFamily: 'Hind',
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.location_on,
                              size: 14, color: Color(0xFF8E8E93)),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              trip.locationLabel,
                              style: const TextStyle(
                                  color: Color(0xFF8E8E93), fontSize: 12),
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      _infoCard(),
                      const SizedBox(height: 14),
                      _descriptionCard(),
                      if (trip.partnerHotel != null) ...[
                        const SizedBox(height: 14),
                        _hotelCard(),
                      ],
                      const SizedBox(height: 14),
                      _spotsCard(),
                      const SizedBox(height: 14),
                      _priceBreakdownCard(),
                      const SizedBox(height: 14),
                      _inclusionsCard(),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Bottom sticky Book Now
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBookBar(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 260,
      pinned: true,
      backgroundColor: const Color(0xFF0A7A5E),
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Color(0xFF0A7A5E), size: 18),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              trip.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF11998E), Color(0xFF38EF7D)],
                  ),
                ),
                child: const Center(
                  child: Icon(Icons.landscape_rounded,
                      size: 80, color: Colors.white38),
                ),
              ),
            ),
            // Dark scrim at bottom for text contrast
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.6),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            // Date badge bottom right
            Positioned(
              bottom: 14,
              right: 14,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.55),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.schedule_rounded,
                        color: Colors.white, size: 13),
                    const SizedBox(width: 5),
                    Text(
                      trip.date,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
            if (trip.tier == _TripTier.premium)
              Positioned(
                bottom: 14,
                left: 14,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFD700),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.workspace_premium_rounded,
                          size: 12, color: Color(0xFF7A4A00)),
                      SizedBox(width: 4),
                      Text('FEATURED',
                          style: TextStyle(
                              color: Color(0xFF7A4A00),
                              fontSize: 10,
                              fontWeight: FontWeight.w800)),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTagsAndOrganizer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Wrap(
          spacing: 6,
          children: trip.tags.map((tag) => _TagChip(tag)).toList(),
        ),
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: const Color(0xFFF0F0F7),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              const Icon(Icons.person_rounded,
                  size: 13, color: Color(0xFF6246EA)),
              const SizedBox(width: 4),
              Text(
                trip.organizer,
                style: const TextStyle(
                    color: Color(0xFF6246EA),
                    fontSize: 11,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _infoCard() {
    return Container(
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
          _infoItem(Icons.groups_rounded, '${trip.maxMembers}', 'Max group'),
          _infoDiv(),
          _infoItem(Icons.event_available_rounded,
              '${trip.spotsLeft}', 'Spots left'),
          _infoDiv(),
          _infoItem(Icons.person_rounded, trip.organizer, 'Organizer'),
        ],
      ),
    );
  }

  Widget _infoItem(IconData icon, String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF11998E), size: 20),
          const SizedBox(height: 4),
          Text(value,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A2E))),
          Text(label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 10, color: Color(0xFF8E8E93))),
        ],
      ),
    );
  }

  Widget _infoDiv() => Container(
      width: 1, height: 40, color: const Color(0xFFEEEEEE));

  Widget _descriptionCard() {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('About this trip',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A2E))),
          const SizedBox(height: 8),
          Text(
            trip.description,
            style: const TextStyle(
                color: Color(0xFF555555), fontSize: 13, height: 1.6),
          ),
        ],
      ),
    );
  }

  Widget _hotelCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: const Color(0xFFFFCC02).withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.hotel_rounded,
                color: Color(0xFFF59E0B), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Partner Stay',
                    style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFFF59E0B),
                        fontWeight: FontWeight.w700)),
                Text(trip.partnerHotel!,
                    style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF92400E),
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text('Included',
                style: TextStyle(
                    color: Color(0xFFF59E0B),
                    fontSize: 10,
                    fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  Widget _spotsCard() {
    final spotsLeft = trip.spotsLeft;
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Group availability',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A2E))),
              Text(
                '$spotsLeft spots remaining',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: spotsLeft <= 3
                      ? Colors.orange
                      : const Color(0xFF11998E),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: LinearProgressIndicator(
              value: trip.fillFraction,
              backgroundColor: const Color(0xFFE8F5F2),
              valueColor: AlwaysStoppedAnimation<Color>(
                spotsLeft <= 3 ? Colors.orange : const Color(0xFF11998E),
              ),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${trip.joinedMembers} joined',
                style: const TextStyle(
                    fontSize: 11, color: Color(0xFF8E8E93)),
              ),
              Text(
                '${trip.maxMembers} total seats',
                style: const TextStyle(
                    fontSize: 11, color: Color(0xFF8E8E93)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _priceBreakdownCard() {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Price breakdown',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A2E))),
          const SizedBox(height: 12),
          _priceRow('Registration fee', 'Rs ${_fmt(trip.perPerson)}',
              isMain: true),
          const SizedBox(height: 6),
          _priceRow(
              'Travel pool (${100 - trip.platformFeePercent}%)',
              'Rs ${_fmt(trip.travelPool)}'),
          _priceRow(
              'Platform fee (${trip.platformFeePercent}%)',
              'Rs ${_fmt(trip.platformFee)}',
              valueColor: const Color(0xFF11998E)),
          const Divider(height: 16, thickness: 0.7),
          _priceRow(
            'Total group pool',
            'Rs ${_fmt(trip.totalGroupPool)}',
            valueColor: const Color(0xFF0A7A5E),
          ),
        ],
      ),
    );
  }

  Widget _priceRow(String label, String value,
      {bool isMain = false, Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  color: const Color(0xFF8E8E93),
                  fontSize: isMain ? 13 : 11)),
          Text(value,
              style: TextStyle(
                  color: valueColor ?? const Color(0xFF1A1A2E),
                  fontWeight:
                      isMain ? FontWeight.w800 : FontWeight.w600,
                  fontSize: isMain ? 18 : 11)),
        ],
      ),
    );
  }

  Widget _inclusionsCard() {
    final items = [
      (Icons.directions_bus_rounded, 'Transport'),
      (Icons.restaurant_rounded, 'All meals'),
      (Icons.person_pin_rounded, 'Expert guide'),
      (Icons.local_activity_rounded, 'Entry tickets'),
      (Icons.medical_services_rounded, 'First aid kit'),
      (Icons.photo_camera_rounded, 'Photography spots'),
    ];
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("What's included",
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A2E))),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 8,
            children: items.map((item) {
              return Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF11998E).withValues(alpha: 0.07),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(item.$1,
                        size: 13, color: const Color(0xFF11998E)),
                    const SizedBox(width: 5),
                    Text(item.$2,
                        style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF0A7A5E),
                            fontWeight: FontWeight.w500)),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildBookBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          16, 12, 16, MediaQuery.of(context).padding.bottom + 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Rs ${_fmt(trip.perPerson)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              const Text('per person',
                  style: TextStyle(
                      fontSize: 11, color: Color(0xFF8E8E93))),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: trip.hasBooked || trip.spotsLeft == 0
                    ? null
                    : () => _showPaymentSheet(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: trip.hasBooked
                      ? const Color(0xFF34C759)
                      : const Color(0xFF11998E),
                  disabledBackgroundColor: trip.hasBooked
                      ? const Color(0xFF34C759)
                      : Colors.grey[300],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13)),
                  elevation: 0,
                ),
                child: Text(
                  trip.hasBooked
                      ? 'Booking Confirmed'
                      : trip.spotsLeft == 0
                          ? 'Group Full'
                          : 'Book Now · Rs ${_fmt(trip.perPerson)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPaymentSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _PaymentSheet(
        trip: trip,
        onSuccess: () {
          onBooked();
          Navigator.pop(context); // close sheet
        },
      ),
    );
  }
}

// ─── Payment Sheet ─────────────────────────────────────────────────────────────

class _PaymentSheet extends StatefulWidget {
  final _TripGroup trip;
  final VoidCallback onSuccess;
  const _PaymentSheet({required this.trip, required this.onSuccess});

  @override
  State<_PaymentSheet> createState() => _PaymentSheetState();
}

class _PaymentSheetState extends State<_PaymentSheet> {
  int _selectedMethod = 0; // 0=UPI, 1=Card, 2=NetBanking
  bool _paying = false;

  final List<(IconData, String, String)> _methods = [
    (Icons.account_balance_wallet_rounded, 'UPI', 'Google Pay · PhonePe · Paytm'),
    (Icons.credit_card_rounded, 'Credit / Debit Card', 'Visa · Mastercard · RuPay'),
    (Icons.account_balance_rounded, 'Net Banking', 'SBI · HDFC · ICICI · Axis'),
  ];

  Future<void> _pay() async {
    setState(() => _paying = true);
    await Future.delayed(const Duration(milliseconds: 1600));
    if (!mounted) return;
    setState(() => _paying = false);
    Navigator.pop(context); // close payment sheet
    widget.onSuccess();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded,
                color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Booking confirmed for ${widget.trip.destination}! Check your email for details.',
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF11998E),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final trip = widget.trip;
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
          24, 0, 24, MediaQuery.of(context).viewInsets.bottom + 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF11998E).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.lock_rounded,
                    color: Color(0xFF11998E), size: 20),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Secure Payment',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1A1A2E))),
                  Text('256-bit encrypted · Demo mode',
                      style:
                          TextStyle(fontSize: 11, color: Color(0xFF8E8E93))),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Order summary
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F5F8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _summaryRow('Trip', trip.destination, isBold: false),
                const SizedBox(height: 6),
                _summaryRow('Date', trip.date, isBold: false),
                const SizedBox(height: 6),
                _summaryRow('Organizer', trip.organizer, isBold: false),
                const Divider(height: 14, thickness: 0.6),
                _summaryRow('Registration fee',
                    'Rs ${_fmt(trip.perPerson)}',
                    isBold: true),
                const SizedBox(height: 3),
                _summaryRow(
                    'Platform fee (${trip.platformFeePercent}%)',
                    'Rs ${_fmt(trip.platformFee)}',
                    valueColor: const Color(0xFF11998E)),
                const Divider(height: 14, thickness: 0.6),
                _summaryRow('Total payable',
                    'Rs ${_fmt(trip.perPerson)}',
                    isBold: true,
                    fontSize: 16,
                    valueColor: const Color(0xFF1A1A2E)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Payment method
          const Text('Payment method',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A2E))),
          const SizedBox(height: 10),
          ..._methods.asMap().entries.map((entry) {
            final i = entry.key;
            final method = entry.value;
            final selected = _selectedMethod == i;
            return GestureDetector(
              onTap: () => setState(() => _selectedMethod = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: selected
                      ? const Color(0xFF11998E).withValues(alpha: 0.07)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: selected
                        ? const Color(0xFF11998E)
                        : const Color(0xFFE0E0E0),
                    width: selected ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(method.$1,
                        color: selected
                            ? const Color(0xFF11998E)
                            : const Color(0xFF8E8E93),
                        size: 22),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(method.$2,
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: selected
                                      ? const Color(0xFF0A7A5E)
                                      : const Color(0xFF1A1A2E))),
                          Text(method.$3,
                              style: const TextStyle(
                                  fontSize: 10,
                                  color: Color(0xFF8E8E93))),
                        ],
                      ),
                    ),
                    if (selected)
                      const Icon(Icons.check_circle_rounded,
                          color: Color(0xFF11998E), size: 18),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 16),
          // Pay button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _paying ? null : _pay,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF11998E),
                disabledBackgroundColor:
                    const Color(0xFF11998E).withValues(alpha: 0.6),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
              child: _paying
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2.5),
                    )
                  : Text(
                      'Pay Rs ${_fmt(trip.perPerson)}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 16),
                    ),
            ),
          ),
          const SizedBox(height: 10),
          const Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.shield_rounded,
                    size: 12, color: Color(0xFF8E8E93)),
                SizedBox(width: 4),
                Text(
                  'Secured by Ghorbhara Pay · Demo only, no real charge',
                  style: TextStyle(fontSize: 10, color: Color(0xFF8E8E93)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value,
      {bool isBold = false, double fontSize = 12, Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: fontSize - 1,
                color: const Color(0xFF8E8E93))),
        Flexible(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
              color: valueColor ?? const Color(0xFF1A1A2E),
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Tag Chip ──────────────────────────────────────────────────────────────────

class _TagChip extends StatelessWidget {
  final String label;
  const _TagChip(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFF11998E).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: const TextStyle(
            color: Color(0xFF11998E),
            fontSize: 10,
            fontWeight: FontWeight.w600),
      ),
    );
  }
}

// ─── Stats Pill ────────────────────────────────────────────────────────────────

class _StatPill extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  const _StatPill(
      {required this.icon, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF11998E), size: 18),
        const SizedBox(height: 2),
        Text(value,
            style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 14,
                color: Color(0xFF1A1A2E))),
        Text(label,
            style: const TextStyle(
                fontSize: 10, color: Color(0xFF8E8E93))),
      ],
    );
  }
}

// ─── Create Trip Sheet ─────────────────────────────────────────────────────────

class _CreateTripSheet extends StatelessWidget {
  const _CreateTripSheet();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
          24, 20, 24, MediaQuery.of(context).viewInsets.bottom + 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Host a Lizure Trip',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A2E),
              fontFamily: 'Hind',
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Fill a group of 8–15 and earn 5% referral bonus on all registrations.',
            style: TextStyle(color: Color(0xFF8E8E93), fontSize: 13),
          ),
          const SizedBox(height: 20),
          _earnRow(Icons.terrain_rounded, 'Weekend trip (10 pax @ Rs 3,000)',
              'Earn Rs 1,500'),
          _earnRow(Icons.landscape_rounded, 'Long trip (8 pax @ Rs 6,000)',
              'Earn Rs 2,400'),
          _earnRow(Icons.pets_rounded, 'Day trip (15 pax @ Rs 1,200)',
              'Earn Rs 900'),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                        const Text('Trip hosting coming soon! We\'ll notify you.'),
                    backgroundColor: const Color(0xFF11998E),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF11998E),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: const Text('Register as a Host',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 15)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _earnRow(IconData icon, String desc, String earn) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, size: 22, color: const Color(0xFF11998E)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(desc,
                style: const TextStyle(
                    color: Color(0xFF555555), fontSize: 13)),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFF11998E).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(earn,
                style: const TextStyle(
                    color: Color(0xFF0A7A5E),
                    fontWeight: FontWeight.w700,
                    fontSize: 11)),
          ),
        ],
      ),
    );
  }
}
