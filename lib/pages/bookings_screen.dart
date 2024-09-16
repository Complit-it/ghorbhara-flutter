import 'package:flutter/material.dart';

import 'booking_req.dart';
import 'my_bookings.dart';

class MyBookings extends StatefulWidget {
  @override
  State<MyBookings> createState() => _MyBookingsState();
}

class _MyBookingsState extends State<MyBookings> {
  int _selectedIndex = 0;

  void _onButtonTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(
            selectedIndex: _selectedIndex,
            onButtonTapped: _onButtonTapped,
          ),
          Expanded(
            child: _selectedIndex == 0 ? Bookings() : BookingRequests(),
          ),
        ],
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onButtonTapped;

  const CustomAppBar({
    Key? key,
    required this.selectedIndex,
    required this.onButtonTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 16),
      color: Theme.of(context).primaryColor,
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () => onButtonTapped(0),
                  child: Text(
                    'My Bookings',
                    style: TextStyle(
                      color: selectedIndex == 0 ? Colors.white : Colors.white54,
                      fontWeight: selectedIndex == 0
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                TextButton(
                  onPressed: () => onButtonTapped(1),
                  child: Text(
                    'Booking Requests',
                    style: TextStyle(
                      color: selectedIndex == 1 ? Colors.white : Colors.white54,
                      fontWeight: selectedIndex == 1
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 48), // Placeholder to balance the layout
        ],
      ),
    );
  }
}

// class Bookings extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Text('Bookings Screen'),
//     );
//   }
// }

// class BookingRequests extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Text('Booking Requests Screen'),
//     );
//   }
// }
