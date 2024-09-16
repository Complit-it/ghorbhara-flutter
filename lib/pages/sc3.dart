import 'package:flutter/material.dart';

class ScreenThree extends StatefulWidget {
  const ScreenThree({super.key});

  @override
  State<ScreenThree> createState() => _ScreenThreeState();
}

class _ScreenThreeState extends State<ScreenThree> {
  final List<Map<String, dynamic>> gridData = [
    {'icon': Icons.star, 'text': 'Item 1'},
    {'icon': Icons.favorite, 'text': 'Item 2'},
    {'icon': Icons.shopping_cart, 'text': 'Item 3'},
    {'icon': Icons.camera, 'text': 'Item 4'},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 400,
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Set the number of columns in each row
            crossAxisSpacing: 0, // Set the spacing between columns
            mainAxisSpacing: 1.0, // Set the spacing between rows
          ),
          shrinkWrap: true,
          itemCount: gridData.length,
          itemBuilder: (context, index) {
            final IconData icon = gridData[index]['icon'];
            final String text = gridData[index]['text'];
            return GridItem(
              icon: icon,
              text: text,
            );
          },
        ),
      ),
    );
  }
}

class GridItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const GridItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.all(16.0),
      // decoration: BoxDecoration(
      // border: Border.all(color: Colors.grey),
      // borderRadius: BorderRadius.circular(8.0),
      // color: Colors.amber,
      // ),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 16.0,
            color: Colors.blue,
          ),
          // SizedBox(height: 8.0),
          Text(
            text,
            style: TextStyle(
              fontSize: 12.0,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
