import 'package:flutter/material.dart';
import 'package:hello_world/data/dummy_data.dart';
import 'package:hello_world/models/booking.dart';
import 'package:hello_world/models/property.dart';
import 'package:hello_world/pages/chat_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookingRequests extends StatefulWidget {
  const BookingRequests({super.key});

  @override
  State<BookingRequests> createState() => _BookingRequestsState();
}

class _BookingRequestsState extends State<BookingRequests> {
  bool isLoading = true;
  // Map of property → its bookings (for owners viewing requests on their props)
  List<MapEntry<Property, List<Booking>>> _propBookings = [];

  @override
  void initState() {
    super.initState();
    _loadRequests();
  }

  Future<void> _loadRequests() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId') ?? 0;
    final myProps = DummyData.dummyProperties
        .where((p) => p.userId == userId.toString())
        .toList();
    final result = myProps
        .map((p) => MapEntry(p, DummyData.getPropertyBookings(p.id)))
        .where((e) => e.value.isNotEmpty)
        .toList();
    if (mounted) {
      setState(() {
        _propBookings = result;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
          child: CircularProgressIndicator(color: Color(0xFF6246EA)));
    }
    if (_propBookings.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_rounded, size: 64, color: Color(0xFFDDDDDD)),
            SizedBox(height: 16),
            Text('No booking requests',
                style:
                    TextStyle(color: Color(0xFF8E8E93), fontSize: 16)),
            SizedBox(height: 8),
            Text('Requests on your properties appear here.',
                style:
                    TextStyle(color: Color(0xFFAAAAAA), fontSize: 13)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _propBookings.length,
      itemBuilder: (context, index) {
        final entry = _propBookings[index];
        final property = entry.key;
        final bookings = entry.value;
        return _PropertyRequestCard(
            property: property, bookings: bookings);
      },
    );
  }
}

class _PropertyRequestCard extends StatelessWidget {
  final Property property;
  final List<Booking> bookings;
  const _PropertyRequestCard(
      {required this.property, required this.bookings});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFF6246EA),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                const Icon(Icons.home_rounded, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    property.title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        fontFamily: 'Hind'),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${bookings.length} request${bookings.length != 1 ? 's' : ''}',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          ...bookings.map((booking) {
            final tenant =
                DummyData.getUserById(int.tryParse(booking.userId ?? '0') ?? 0);
            final tenantName = tenant?.name ?? 'Unknown Tenant';
            final tenantId = tenant?.id ?? 0;
            return Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor:
                        const Color(0xFF6246EA).withValues(alpha: 0.12),
                    child: Text(
                      tenantName[0].toUpperCase(),
                      style: const TextStyle(
                          color: Color(0xFF6246EA),
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(tenantName,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1A1A2E))),
                        Text(
                          'Booked: ${booking.bookingDate ?? 'N/A'}',
                          style: const TextStyle(
                              color: Color(0xFF8E8E93), fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => LocalChatScreen(
                            otherUserId: tenantId,
                            otherUserName: tenantName,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6246EA).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.chat_bubble_outline_rounded,
                          color: Color(0xFF6246EA), size: 18),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
