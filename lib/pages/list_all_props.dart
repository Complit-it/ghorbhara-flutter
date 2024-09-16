import 'package:flutter/material.dart';
// import 'package:hello_world/constant.dart';
// import 'package:hello_world/models/api_response.dart';
import 'package:hello_world/models/facility.dart';
import 'package:hello_world/pages/components/reusables/property_card.dart';
import 'package:hello_world/pages/filter_screen.dart';
import 'package:hello_world/services/property_functions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/property.dart';

class ListAllProp extends StatefulWidget {
  const ListAllProp({super.key});

  @override
  State<ListAllProp> createState() => _ListAllPropState();
}

class _ListAllPropState extends State<ListAllProp> {
  List<String> locations = [];
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
              // print('propsss: $filteredProps');
            }
          });
        }
      } else {
        // print('Error fetching properties');
        setState(() {
          props = [];
          isLoading = false;
        });
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
        // backgroundColor: Colors.amber,
        title: Row(
          children: [
            Expanded(
              child: Container(
                // height: 200,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: TextField(
                    controller: _searchController,
                    // autofocus: true,
                    style: const TextStyle(
                        fontSize: 14.0, color: Color.fromARGB(255, 0, 0, 0)),
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 8),
                      hintText: 'Search address, city, location',
                      hintStyle:
                          const TextStyle(color: Color.fromARGB(179, 0, 0, 0)),
                      // border: InputBorder.none,
                      filled: true,
                      fillColor: const Color.fromARGB(255, 231, 225, 225),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        // borderSide: const BorderSide(
                        //   color: Colors
                        //       .grey, // Change the color to your desired unfocused border color
                        // ),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: Colors.blue,
                          width: 0,
                        ),
                      ),
                      // border: OutlineInputBorder(
                      //   borderRadius: BorderRadius.circular(10.0),
                      //   borderSide: BorderSide(
                      //     color: Color.fromARGB(255, 231, 225,
                      //         225), // Change the color to your desired unfocused border color
                      //   ),
                      // ),
                    ),
                    onSubmitted: (String value) {
                      // Trigger search or any other action
                      setState(() {
                        isLoading = true;
                        // Update the search text
                        searchText = value;
                        // Perform the search again
                        // getSearchLocations();
                      });
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 24,
            ),
            GestureDetector(
                onTap: () async {
                  // final prefs = await SharedPreferences.getInstance();
                  // final String? token = prefs.getString("token");
                  // print(token);

                  // get_all_property();
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FilterScreen(),
                    ),
                  );
                  // print(props);
                  if (result != null) {
                    // print('res: ${result}');

                    setState(() {
                      filteredProps = props!.where((property) {
                        final price = double.tryParse(property.price ?? '0');
                        return price != null &&
                            price >= result.values.start &&
                            price <= result.values.end &&
                            result.selectedFacilities
                                .every((Facility facility) {
                              final List<HomeFacility>? homeFacilities =
                                  property.homeFacilities;
                              return homeFacilities != null &&
                                  homeFacilities.any(
                                      (HomeFacility homeFacility) =>
                                          homeFacility.facility.id ==
                                          facility.id);
                            });
                      }).toList();
                    });

                    // setState(() {
                    //   filteredProps = props!.where((property) {
                    //     final price = double.tryParse(property.price ?? '0');
                    //     return price != null &&
                    //         price >= result.values.start &&
                    //         price <= result.values.end &&
                    //         result.selectedFacilities!.every((Facility
                    //                 facility) =>
                    //             property.homeFacilities?.any((HomeFacility?
                    //                     homeFacility) => // Note the nullable HomeFacility
                    //                 homeFacility?.facility.id ==
                    //                 facility
                    //                     .id)); // Use ?. to access nullable property safely
                    //   }).toList();
                    // });
                  }
                },
                child: const Icon(Icons.align_vertical_center)
                // Image.asset(
                //   'assets/filter.png',
                //   width: 50.0,
                //   height: 40.0,
                // ),
                ),
          ],
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
                            'Something went wrong!',
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
