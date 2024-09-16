import 'package:flutter/material.dart';
import 'package:hello_world/pages/location_screen.dart';

class LocationContainer extends StatefulWidget {
  final String address;
  final Function(Map<String, dynamic>)
      updateLocation; // Function to update the location in NewProp

  const LocationContainer({
    Key? key,
    required this.address,
    required this.updateLocation,
  }) : super(key: key);

  @override
  State<LocationContainer> createState() => _LocationContainerState();
}

class _LocationContainerState extends State<LocationContainer> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => LocationScreen()),
        );

        if (result != null) {
          widget.updateLocation(result);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(102, 235, 236, 236),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Location',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 14,
                      fontFamily: 'Hind',
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    widget.address,
                    style: TextStyle(
                      fontFamily: 'Hind',
                    ),
                  ),
                ],
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: Colors.grey[500],
              )
            ],
          ),
        ),
      ),
    );
  }
}
