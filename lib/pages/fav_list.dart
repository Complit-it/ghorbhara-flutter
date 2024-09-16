import 'package:flutter/material.dart';
import 'package:hello_world/models/property.dart';
import 'package:hello_world/pages/components/reusables/property_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/property_functions.dart';

class FavProps extends StatefulWidget {
  const FavProps({super.key});

  @override
  State<FavProps> createState() => _FavPropsState();
}

class _FavPropsState extends State<FavProps> {
  List<Property>? props;
  List<Property> filteredProps = [];
  bool isLoading = true;
  TextEditingController _searchController = TextEditingController();
  String searchText = "";
  @override
  void initState() {
    super.initState();
    // if (mounted) {
    _initializeData();
    // }
    // _searchController.addListener(_filterProperties);
  }

  Future<void> _initializeData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    int? id = pref.getInt('userId');

    if (id != null) {
      final apiResponse = await get_fav_props(id);
      if (apiResponse.error == null) {
        if (mounted) {
          setState(() {
            // if (mounted) {
            // _initializeData();
            props = apiResponse.data as List<Property>;
            isLoading = false;
            if (props != null) {
              filteredProps = props!;
              print('propsss: $filteredProps');
            }
            // }
          });
        }
      } else {
        // Handle API error (optional)
        print('Error fetching properties');
        if (mounted) {
          setState(() {
            props = [];
            isLoading = false;
          });
        }
      }
    } else {
      print('User ID is null');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 21),
          child: ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [Color(0xFF6246EA), Color(0xFF8E2DE2)], // Gradient colors
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(bounds),
            child: Text(
              'My Favorites',
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
        toolbarHeight: 80,
        // backgroundColor: Colors.teal,
        // elevation: 5.0,
        // shadowColor: Colors.black45,
        // centerTitle: true,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 0.0, horizontal: 12),
              child: (filteredProps.isEmpty)
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Color(0xFF6246EA),
                            size: 50,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No properties saved',
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
                          showFavBtn: false,
                        );
                      })),
    );
  }
}
