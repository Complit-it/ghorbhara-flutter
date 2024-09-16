import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  TextEditingController _controller = TextEditingController();
  var uuid = Uuid();
  String sessionToken = '12345';
  List<dynamic> _places = [];

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      onChange();
    });
  }

  void onChange() {
    if (sessionToken == null) {
      setState(() {
        sessionToken = uuid.v4();
      });
    }
    getSuggestion(_controller.text);
  }

  void getSuggestion(String input) async {
    String kPLACES_API_KEY = 'AIzaSyBrHj_sx1JcYBCU_ckrGTp2iK97YqKe5oI';
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String location = '26.1445,91.7362'; // Guwahati, Assam
    String radius = '50000'; // 50 km radius

    String request =
        '$baseURL?input=$input&key=$kPLACES_API_KEY&location=$location&radius=$radius&components=country:IN';

    var response = await http.get(Uri.parse(request));
    if (response.statusCode == 200) {
      setState(() {
        _places = jsonDecode(response.body.toString())['predictions'];
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  String _extractSpecificLocation(String description) {
    List<String> parts = description.split(', ');
    if (parts.length >= 2) {
      return '${parts[0]}, ${parts[1]}';
    }
    return description;
  }

  Future<Map<String, dynamic>> _getPlaceDetails(
      String placeId, String locName) async {
    String kPLACES_API_KEY = 'AIzaSyBrHj_sx1JcYBCU_ckrGTp2iK97YqKe5oI';
    String request =
        'https://maps.googleapis.com/maps/api/place/details/json?placeid=$placeId&key=$kPLACES_API_KEY';

    var response = await http.get(Uri.parse(request));
    var data = jsonDecode(response.body.toString());
    print(data);
    if (response.statusCode == 200) {
      return {
        'name': locName,
        'lat': data['result']['geometry']['location']['lat'],
        'lng': data['result']['geometry']['location']['lng'],
      };
    } else {
      throw Exception('Failed to load place details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 21.0, vertical: 60),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(33.0),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 21.0, vertical: 1),
                child: Row(
                  children: [
                    const Icon(Icons.search),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        style: const TextStyle(fontSize: 14.0),
                        cursorColor: Colors.blue.shade300,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.lightBlue.withOpacity(0.0),
                          hintText: 'Search location',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _places.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 0.0),
                    title: Text(
                      _extractSpecificLocation(_places[index]['description']),
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.blue.shade300,
                      size: 16.0,
                    ),
                    onTap: () async {
                      // print(_places[index]['place_id']);
                      String locName = _extractSpecificLocation(
                          _places[index]['description']);

                      final placeDetails = await _getPlaceDetails(
                          _places[index]['place_id'], locName);
                      Navigator.pop(context, placeDetails);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
