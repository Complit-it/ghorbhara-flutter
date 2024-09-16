import 'package:flutter/material.dart';

class NoDataWidget extends StatelessWidget {
  final String msg;
  const NoDataWidget({super.key, required this.msg});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.info_outline,
            color: Color(0xFF6246EA),
            size: 50,
          ),
          const SizedBox(height: 16),
          Text(
            msg,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Please check back later.',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
