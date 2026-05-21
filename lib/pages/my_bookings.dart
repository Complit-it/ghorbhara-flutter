import 'package:flutter/material.dart';
import 'package:hello_world/data/dummy_data.dart';
import 'package:hello_world/models/property.dart';
import 'package:hello_world/pages/components/reusables/property_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Bookings extends StatefulWidget {
  const Bookings({super.key});

  @override
  State<Bookings> createState() => _BookingsState();
}

class _BookingsState extends State<Bookings> {
  bool isLoading = true;
  List<Property> properties = [];

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId') ?? 0;
    final bookings = DummyData.getUserBookings(userId);
    final bookedProps = bookings
        .map((b) => DummyData.getPropertyById(int.tryParse(b.propId ?? '0') ?? 0))
        .whereType<Property>()
        .toList();
    if (mounted) {
      setState(() {
        properties = bookedProps;
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
    if (properties.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_today_rounded,
                size: 64, color: Color(0xFFDDDDDD)),
            SizedBox(height: 16),
            Text('No bookings yet',
                style:
                    TextStyle(color: Color(0xFF8E8E93), fontSize: 16)),
            SizedBox(height: 8),
            Text('Properties you book will appear here.',
                style:
                    TextStyle(color: Color(0xFFAAAAAA), fontSize: 13)),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      itemCount: properties.length,
      itemBuilder: (context, index) =>
          PropertyCard(property: properties[index]),
    );
  }
}
