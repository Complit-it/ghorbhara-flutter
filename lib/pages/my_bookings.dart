import 'package:flutter/material.dart';
import 'package:hello_world/constant.dart';
import 'package:hello_world/models/property.dart';
import 'package:hello_world/services/property_functions.dart';

import '../services/user_service.dart';
import 'components/reusables/no_data.dart';
import 'components/reusables/property_card.dart';

class Bookings extends StatefulWidget {
  const Bookings({super.key});

  @override
  State<Bookings> createState() => _BookingsState();
}

class _BookingsState extends State<Bookings> {
  bool isLoading = true;
  int? userId;
  List<Property> properties = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchProp();
  }

  // void fetchProp() async {
  //   userId = await getUserId();
  //   // print(userId);
  //   if (userId != null) {
  //     final apiResponse = await getBookedProps(userId!);
  //     if (apiResponse.error == null) {
  //       if (mounted) {
  //         // setState(() {});
  //         setState(() {
  //           properties = apiResponse.data as List<Property>;
  //           isLoading = false;
  //         });
  //       }

  //       print('properties : $properties');
  //     } else {
  //       if (mounted) {
  //         setState(() {
  //           properties = [];
  //           isLoading = false;
  //         });
  //       }
  //     }
  //   } else {
  //     print('User ID is null');
  //     setState(() {
  //       properties = [];
  //       isLoading = false;
  //     });
  //   }
  // }

  void fetchProp() async {
    userId = await getUserId();
    if (userId != null) {
      final apiResponse = await getBookedProps(userId!);
      if (apiResponse.error == null) {
        if (mounted) {
          setState(() {
            if (apiResponse.data != null &&
                (apiResponse.data as List).isNotEmpty) {
              properties = apiResponse.data as List<Property>;
            } else {
              // Handle the case where no properties are found
              properties = [];
              print('No properties found for this user.');
            }
            isLoading = false;
          });
        }

        print('properties : $properties');
      } else {
        if (mounted) {
          setState(() {
            properties = [];
            isLoading = false;
          });
        }
      }
    } else {
      print('User ID is null');
      setState(() {
        properties = [];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12),
              child: (properties == null || properties.isEmpty)
                  ? NoDataWidget(
                      msg: 'No data available',
                    )
                  : ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: properties.length,
                      itemBuilder: (context, index) {
                        Property property = properties[index];
                        // final imageUrl = baseUrl + property.image!.imagePath;
                        return PropertyCard(
                          property: property,
                        );
                      })),
    );
  }
}
