import 'package:flutter/material.dart';
import 'package:hello_world/constant.dart';
import 'package:hello_world/models/api_response.dart';
import 'package:hello_world/models/facility.dart';
import 'package:hello_world/pages/components/reusables/no_data.dart';
import 'package:hello_world/pages/components/reusables/property_card.dart';
import 'package:hello_world/pages/filter_screen.dart';
import 'package:hello_world/services/property_functions.dart';

import '../models/property.dart';

class SearchPage extends StatefulWidget {
  String searchText;

  SearchPage({super.key, required this.searchText});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<String> locations = [];
  final List<String> _searchList = [];
  bool _isloading = true;
  List<Property>? props;
  List<Property> filteredProps = [];
  TextEditingController _searchController = TextEditingController();
  String searchText = "";
  @override
  void initState() {
    super.initState();
    searchText = widget.searchText; // Set the initial search text
    _searchController.text = searchText;
    getSearchLocations();
    // get_search_locations();
  }

  Future<void> getSearchLocations() async {
    ApiResponse apiResponse = (await searched_property(widget.searchText));
    // setState(() {
    //   locations = fetchedLocations;
    //   _isloading = false;
    // });
    // print(locations);
    setState(() {
      if (apiResponse.error == null) {
        props = apiResponse.data as List<Property>;
        if (props != null) {
          filteredProps = props!;
        }
      } else {
        props = null;
      }
      // print(filteredProps);
      print(props);
      _isloading = false;
    });
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
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                      hintText: 'Search address, city, location',
                      hintStyle: TextStyle(color: Color.fromARGB(179, 0, 0, 0)),
                      // border: InputBorder.none,
                      filled: true,
                      fillColor: Color.fromARGB(255, 231, 225, 225),
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
                        _isloading = true;
                        // Update the search text
                        widget.searchText = value;
                        // Perform the search again
                        getSearchLocations();
                      });
                    },
                  ),
                ),
              ),
            ),
            SizedBox(
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
                      builder: (context) => FilterScreen(),
                    ),
                  );
                  // print(props);
                  if (result != null) {
                    print('res: ${result}');

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
                child: Icon(Icons.align_vertical_center)
                // Image.asset(
                //   'assets/filter.png',
                //   width: 50.0,
                //   height: 40.0,
                // ),
                ),
          ],
        ),
      ),
      body: _isloading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: (props == null || props!.isEmpty)
                  ? NoDataWidget(msg: 'Oops nothing matched your search.')
                  : ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: filteredProps.length,
                      itemBuilder: (context, index) {
                        Property property = filteredProps![index];
                        // final imageUrl = baseUrl + property.image!.imagePath;
                        return PropertyCard(
                          property: property,
                        );
                      })),
    );
  }
}
