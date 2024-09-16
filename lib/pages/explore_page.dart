import 'package:flutter/material.dart';
// import 'package:hello_world/constant.dart';
// import 'package:hello_world/models/api_response.dart';
import 'package:hello_world/models/facility.dart';
import 'package:hello_world/pages/components/reusables/property_card.dart';
import 'package:hello_world/pages/filter_screen.dart';
import 'package:hello_world/services/property_functions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/options.dart';
import '../models/property.dart';

class ExplorePage extends StatefulWidget {
  // String searchText;

  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
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
      final apiResponse = await get_all_property(id);
      if (apiResponse.error == null) {
        if (mounted) {
          setState(() {
            props = apiResponse.data as List<Property>;
            isLoading = false;
            if (props != null) {
              filteredProps = props!;
            }
          });
        }
      } else {
        // Handle API error (optional)
        // print('Error fetching properties');
        if (mounted) {
          setState(() {
            props = [];
            isLoading = false;
          });
        }
      }
    } else {
      // print('User ID is null');
      setState(() {
        props = [];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 80.0,
        surfaceTintColor: Colors.transparent,
        title: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(
                      fontSize: 14.0, color: Color.fromARGB(255, 0, 0, 0)),
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.search,
                        color: Colors.grey[700],
                      ),
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                    hintText: 'Search address, city, location',
                    hintStyle:
                        const TextStyle(color: Color.fromARGB(179, 0, 0, 0)),
                    filled: true,
                    fillColor: const Color.fromARGB(255, 231, 225, 225),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(33.0),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(33.0),
                      borderSide: const BorderSide(
                        color: Colors.blue,
                        width: 0,
                      ),
                    ),
                  ),
                  onSubmitted: (String value) {
                    setState(() {
                      isLoading = true;
                      searchText = value;
                    });
                  },
                ),
              ),
              const SizedBox(
                width: 24,
              ),
              GestureDetector(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FilterScreen(),
                      ),
                    );
                    // print(props);
                    if (result != null) {
                      setState(() {
                        filteredProps = props!.where((property) {
                          final price = double.tryParse(property.price ?? '0');

                          final isPriceInRange = price != null &&
                              price >= result.values.start &&
                              price <= result.values.end;

                          final hasSelectedFacilities =
                              result.selectedFacilities.every(
                            (Facility facility) {
                              final List<HomeFacility>? homeFacilities =
                                  property.homeFacilities;
                              return homeFacilities != null &&
                                  homeFacilities.any(
                                    (HomeFacility homeFacility) =>
                                        homeFacility.facility.id == facility.id,
                                  );
                            },
                          );

                          final hasSelectedPropertyType =
                              result.selectedPropType.isEmpty ||
                                  result.selectedPropType.any(
                                    (Options selectedType) =>
                                        property.propertyType?.id ==
                                        selectedType.id,
                                  );

                          return isPriceInRange &&
                              hasSelectedFacilities &&
                              hasSelectedPropertyType;
                        }).toList();
                      });
                    }
                  },
                  child: Icon(
                    Icons.filter_alt,
                    size: 32,
                    color: Theme.of(context).primaryColor,
                  )),
            ],
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
              child: (filteredProps == null || filteredProps.isEmpty)
                  ? const Center(
                      child: Text(
                        'No data available',
                        style: TextStyle(color: Colors.black),
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
