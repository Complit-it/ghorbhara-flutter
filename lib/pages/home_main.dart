import 'package:flutter/material.dart';
import 'package:hello_world/models/ad.dart';
import 'package:hello_world/models/location.dart';
import 'package:hello_world/models/property.dart';
// import 'package:hello_world/pages/filter_screen.dart';
import 'package:hello_world/services/location_function.dart';
import 'package:hello_world/services/property_functions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'components/home_first_corousel.dart';
// import 'components/home_second_corousel.dart';
import 'components/home_third_corousel.dart';
// import 'components/home_btm_banner.dart';
import 'new_property.dart';
// import 'home.dart';
// import 'package:flutter/material.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';

import 'search_page.dart';

class HomeMain extends StatefulWidget {
  const HomeMain({super.key});

  @override
  State<HomeMain> createState() => _HomeMainState();
}

class _HomeMainState extends State<HomeMain> {
  List<Property> properties = [];
  List<Ad> ads = [];
  double? lat;
  double? long;
  String? location;
  bool propertyLoading = true;
  final TextEditingController _controller = TextEditingController();

  final LocationService _locationService = LocationService();

  Future<void> _getLocationData() async {
    if (mounted) {
      setState(() {
        location = 'Loading...';
      });
    }
    kLocation retrievedAddress = await _locationService.getAddress();
    if (retrievedAddress.error == null) {
      if (mounted) {
        setState(() {
          location = retrievedAddress.location!;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          location = retrievedAddress.error!;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeData();
    _initializeData1();
  }

  Future<void> _initializeData() async {
    _getLocationData();
    SharedPreferences pref = await SharedPreferences.getInstance();
    int? id = pref.getInt('userId');
    if (id != null) {
      final apiResponse = await get_all_property(id);
      if (apiResponse.error == null) {
        if (mounted) {
          setState(() {
            properties = apiResponse.data as List<Property>;
            print('properties : $properties');
            propertyLoading = false;
          });
        }
      } else {}
    } else {}
  }

  Future<void> _initializeData1() async {
    final apiResponse = await get_all_ads();
    if (apiResponse.error == null && apiResponse.data != null) {
      if (mounted) {
        setState(() {
          // Cast apiResponse.data to List<Ad>
          ads = apiResponse.data as List<Ad>;
        });
      }
    } else {
      // Handle API error (optional)
      // Set ads to an empty list if there's an error
      if (mounted) {
        setState(() {
          ads = [];
        });
      }

      // Optionally, show an error message to the user
      print('Error fetching ads: ${apiResponse.error}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Your current locations',
              style: TextStyle(
                color: Colors.grey[400],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
          child: Row(
            children: [
              // Image.asset(
              //   'assets/location.png',
              //   height: 50.0,
              // ),
              const Icon(
                Icons.location_on_rounded,
                color: Color(0xFF6246EA),
              ),
              const SizedBox(
                width: 8,
              ),
              Text('$location')
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
          child: Container(
            height: 50.0,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius:
                  BorderRadius.circular(33.0), // Set the border radius
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 21.0, vertical: 1),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.search),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      onSubmitted: (String value) {
                        _controller.clear();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SearchPage(searchText: value),
                          ),
                        );
                      },
                      style: const TextStyle(fontSize: 14.0),
                      cursorColor: Colors.blue.shade300,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.lightBlue.withOpacity(0.0),
                        hintText: 'Search address, city, location',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(21),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Welcome to GhorBhara",
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontFamily: 'Hind',
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Container(
            child: Row(
              children: [
                ElevatedButton(
                    onPressed: () {
                      debugPrint("Button pressed!");
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          return states.contains(MaterialState.pressed)
                              ? const Color(0xFF315EE7)
                              : const Color(0xFF6246EA);
                        },
                      ),
                    ),
                    child: const Text(
                      'I want to rent',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    )),
                const SizedBox(width: 28),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const NewProp()),
                      );
                    },
                    //   onPressed: () {
                    //   // Access the PageController from the parent Home widget
                    //   HomeState? homeState = context.findAncestorStateOfType<HomeState>();
                    //   if (homeState != null) {
                    //     homeState._pageController.jumpToPage(1); // Navigate to NewProp screen (index 1)
                    //   }
                    // },
                    // onPressed: () {
                    //   HomeState? homeState =
                    //       context.findAncestorStateOfType<HomeState>();
                    //   if (homeState != null) {
                    //     homeState.navigateToNewProp();
                    //   }
                    // },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color.fromARGB(255, 255, 255, 255)),
                    ),
                    child: Text(
                      'I want to list',
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    )),
              ],
            ),
          ),
        ),
        // CorouselOne(),
        propertyLoading
            ? const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 38.0),
                  child: CircularProgressIndicator(),
                ),
              )
            : CorouselOne(properties: properties),
        // CorouselTwo(),
        CorouselThree(ads: ads),
        // BtmBanner(),
        const SizedBox(
          height: 20,
        )
      ]),
    );
  }
}
