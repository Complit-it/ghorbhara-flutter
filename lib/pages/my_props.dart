// import 'package:flutter/material.dart';
// import 'package:hello_world/models/api_response.dart';

// class MyPropertiesScreen extends StatefulWidget {
//   const MyPropertiesScreen({super.key});

//   @override
//   State<MyPropertiesScreen> createState() => _MyPropertiesScreenState();
// }

// class _MyPropertiesScreenState extends State<MyPropertiesScreen> {
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _loadProps();
//   }

//   Future<void> _loadProps()async{
//     try{
//       final apiResponse = await getUserProps();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }

import 'package:flutter/material.dart';
import 'package:hello_world/constant.dart';
import 'package:hello_world/models/api_response.dart';
import 'package:hello_world/models/facility.dart';
import 'package:hello_world/pages/components/reusables/property_card.dart';
import 'package:hello_world/pages/filter_screen.dart';
import 'package:hello_world/services/property_functions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/property.dart';

class MyPropertiesScreen extends StatefulWidget {
  const MyPropertiesScreen({super.key});

  @override
  State<MyPropertiesScreen> createState() => _MyPropertiesScreenState();
}

class _MyPropertiesScreenState extends State<MyPropertiesScreen> {
  List<String> locations = [];
  // final List<String> _searchList = [];
  bool isLoading = true;
  List<Property>? props;
  List<Property> filteredProps = [];
  TextEditingController _searchController = TextEditingController();
  String searchText = "";
  @override
  void initState() {
    super.initState();
    _initializeData();
    _searchController.addListener(_filterProperties);
  }

  void _filterProperties() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      filteredProps = props?.where((property) {
            final titleMatch = property.title.toLowerCase().contains(query);
            final addressMatch =
                property.location!.location!.toLowerCase().contains(query);
            return titleMatch || addressMatch;
          }).toList() ??
          [];
    });
  }

  Future<void> _initializeData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    int? id = pref.getInt('userId');

    if (id != null) {
      final apiResponse = await getUserProps(id);
      if (apiResponse.error == null) {
        if (mounted) {
          setState(() {
            // print(apiResponse.data);
            props = apiResponse.data as List<Property>;
            isLoading = false;
            if (props != null) {
              filteredProps = props!;
              print('propsss: $filteredProps');
            }
          });
        }
      } else {
        // Handle API error (optional)
        print('Error fetching properties');
        setState(() {
          props = [];
          isLoading = false;
        });
      }
    } else {
      print('User ID is null');
      setState(() {
        props = [];
        isLoading = false;
      });
    }
  }

  // Future<void> getSearchLocations() async {
  //   ApiResponse apiResponse = (await searched_property(widget.searchText));
  //   // setState(() {
  //   //   locations = fetchedLocations;
  //   //   _isloading = false;
  //   // });
  //   // print(locations);
  //   setState(() {
  //     if (apiResponse.error == null) {
  //       props = apiResponse.data as List<Property>;
  //       if (props != null) {
  //         filteredProps = props!;
  //       }
  //     } else {
  //       props = null;
  //     }
  //     // print(filteredProps);
  //     print(props);
  //     isLoading = false;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.amber,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 21),
          child: ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Color(0xFF6246EA), Color(0xFF8E2DE2)], // Gradient colors
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(bounds),
            child: const Text(
              'My Properties',
              style: TextStyle(
                height: 2,
                letterSpacing: 0.8,
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.white, // This color is a placeholder
                fontFamily: 'Hind', // Your preferred font
              ),
            ),
          ),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12),
              child: (filteredProps.isEmpty)
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.blue,
                            size: 50,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No properties uploaded',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Please check back later.',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: filteredProps.length,
                      itemBuilder: (context, index) {
                        Property property = filteredProps[index];
                        // final imageUrl = baseUrl + property.image!.imagePath;
                        return PropertyCard(
                          property: property,
                        );
                      })),
    );
  }
}
