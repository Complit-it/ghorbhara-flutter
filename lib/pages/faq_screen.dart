import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  // static final CameraPosition _kGooglePlex = const CameraPosition(
  //   target: LatLng(37.42796133580664, -122.085749655962),
  //   zoom: 14.4746,
  // );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FAQ'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildFAQItem(
              question: 'How do I rent a house?',
              answer:
                  'To rent a house, browse our listings, select a property, and follow the instructions to book it. If you need assistance, contact our support team.',
            ),
            _buildFAQItem(
              question: 'What payment methods are accepted?',
              answer:
                  'We accept various payment methods including credit/debit cards and online payment gateways. Check the payment options available at checkout.',
            ),
            _buildFAQItem(
              question: 'How can I contact support?',
              answer:
                  'You can contact our support team via email at info@complit.in or call us at +91 8753908744.',
            ),
            _buildFAQItem(
              question: 'What is the cancellation policy?',
              answer:
                  'Cancellation policies vary by property. Please review the cancellation policy listed on the property details page before making a booking.',
            ),
            SizedBox(height: 32),
            Text(
              'For more information, please contact COMPLIT:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Phone: +91 8753908744'),
            Text('Email: info@complit.in'),
          ],
        ),
      ),
    );
  }
}

Widget _buildFAQItem({required String question, required String answer}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 16.0),
    child: ExpansionTile(
      title: Text(
        question,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(answer),
        ),
      ],
    ),
  );
}
