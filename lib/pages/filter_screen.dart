// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:hello_world/constant.dart';
import 'package:hello_world/models/facility.dart';
import 'package:hello_world/models/filterscreenresult.dart';

import '../models/options.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  RangeValues values = RangeValues(0, 20000);
  bool isLoading = true;
  List<Facility> facilities = [];
  var _isSelected = false;
  List<Facility> selectedFacilities = [];
  List<Options> propertyTypes = [];
  List<Options> selectedPropertyTypes = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getHomeFacility();
    fetchPropertyTypes();
  }

  Future<void> getHomeFacility() async {
    try {
      final response = await http.get(Uri.parse(getHomeFacUrl));
      // print(response.body);
      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body) as Map<String, dynamic>;
        if (decodedData['success']) {
          setState(() {
            facilities = (decodedData['data'] as List)
                .map((item) => Facility(
                      id: item['id'],
                      facility: item['facility'],
                    ))
                .toList();
            isLoading = false;
          });
          // print(facilities);
        } else {
          // print("Error: ${decodedData['message']}");
        }
      } else {
        // print("Error: ${response.statusCode}");
      }
    } catch (e) {
      // print(e);
    }
  }

  Future<void> fetchPropertyTypes() async {
    final response = await http.get(Uri.parse(getPropTypeUrl));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> data = jsonData['data'];

      setState(() {
        propertyTypes = data
            .map((item) => Options(
                  id: item['id'],
                  name: item['property_type'],
                ))
            .toList();
        print(propertyTypes);
      });
    } else {
      throw Exception('Failed to load property types');
    }
  }

  @override
  Widget build(BuildContext context) {
    RangeLabels labels =
        // RangeLabels(values.start.toString(), values.end.toString());
        RangeLabels(
      'Rs ${values.start.round()}',
      'Rs ${values.end.round()}',
    );
    // List<bool> selectedStates = List.filled(filterOptions.length, false);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: Container(
          padding: EdgeInsets.only(top: 10, right: 15, left: 1.5),
          // padding: EdgeInsets.all(0),
          child: AppBar(
            surfaceTintColor: Colors.transparent,
            leading: BackButton(
              color: Color(0xFF6246EA),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.align_vertical_center_rounded,
                  color: Color(0xFF6246EA),
                ),
                onPressed: () {
                  // Add your onPressed logic here
                },
              ),
            ],
          ),
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Padding(
                          //   padding: const EdgeInsets.fromLTRB(21, 8, 21, 0),
                          //   child: Text(
                          //     textAlign: TextAlign.left,
                          //     "Property type",
                          //     style: TextStyle(
                          //         fontWeight: FontWeight.w700,
                          //         fontFamily: 'Hind',
                          //         fontSize: 20),
                          //   ),
                          // ),
                          // Container(
                          //   height: 90,
                          //   // color: Colors.amber,
                          //   child: ListView.builder(
                          //     scrollDirection: Axis.horizontal,
                          //     // itemExtent: 500,
                          //     shrinkWrap: true,
                          //     // physics: NeverScrollableScrollPhysics(),
                          //     itemCount: 5,
                          //     itemBuilder: (context, index) {
                          //       return Padding(
                          //         padding: EdgeInsets.fromLTRB(21, 0, 14, 12),
                          //         // padding: EdgeInsets.all(0),
                          //         child: FilterChip(
                          //           label: Text('Filter 1'),
                          //           onSelected: (bool selected) {},
                          //         ),
                          //       );
                          //     },
                          //   ),
                          // ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(21, 5, 21, 1),
                            child: Text(
                              textAlign: TextAlign.left,
                              "Price range",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Hind',
                                  fontSize: 20),
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.fromLTRB(21, 4, 21, 4),
                              child: RichText(
                                text: TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                  children: [
                                    TextSpan(
                                      text: 'Rs ${values.start.round()} - ',
                                      style: TextStyle(
                                        fontFamily: 'Hind',
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18,
                                        color: Colors.grey[850],
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                    // TextSpan(text: '  '),
                                    TextSpan(
                                      text: 'Rs ${values.end.round()} ',
                                      style: TextStyle(
                                        fontFamily: 'Hind',
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18,
                                        color: Colors.grey[850],
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' /month',
                                      style: TextStyle(
                                        fontFamily: 'Hind',
                                        fontWeight: FontWeight.w400,
                                        fontSize: 18,
                                        color: Colors.grey,
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                            child: RangeSlider(
                                values: values,
                                labels: labels,
                                divisions: 10,
                                min: 0,
                                max: 20000,
                                onChanged: (newVal) {
                                  values = newVal;
                                  setState(() {
                                    values = newVal;
                                  });
                                }),
                          ),

                          Padding(
                            padding:
                                EdgeInsets.only(left: 21, right: 21, top: 12),
                            child: Text(
                              "Property facilities",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Hind',
                                  fontSize: 20),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(21.0),
                            child: Wrap(
                              spacing: 8.0,
                              children: facilities.map((facility) {
                                return FilterChip(
                                  label: Text(facility.facility),
                                  selected: facility.isSelected,
                                  onSelected: (bool selected) {
                                    setState(() {
                                      facility.isSelected = selected;
                                      if (selected) {
                                        selectedFacilities.add(facility);
                                        // print(selectedFacilities);
                                      } else {
                                        selectedFacilities.remove(facility);
                                        // print(selectedFacilities);
                                      }
                                    });
                                  },
                                  selectedColor: Colors.blue.withOpacity(0.5),
                                );
                              }).toList(),
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsets.only(left: 21, right: 21, top: 12),
                            child: Text(
                              "Property Type",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Hind',
                                  fontSize: 20),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(21.0),
                            child: Wrap(
                              spacing: 8.0,
                              children: propertyTypes.map((propertyType) {
                                return FilterChip(
                                  label: Text(propertyType.name),
                                  selected: selectedPropertyTypes
                                      .contains(propertyType),
                                  onSelected: (bool selected) {
                                    setState(() {
                                      if (selected) {
                                        selectedPropertyTypes.add(propertyType);
                                      } else {
                                        selectedPropertyTypes
                                            .remove(propertyType);
                                      }
                                    });
                                  },
                                  selectedColor: Colors.blue.withOpacity(0.5),
                                );
                              }).toList(),
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(21, 21, 21, 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                // TextButton(
                                //   onPressed: () {},
                                //   child: Text("Reset All",
                                //       style: TextStyle(
                                //           fontSize: 18,
                                //           fontFamily: 'Hind',
                                //           color: Colors.grey,
                                //           decoration: TextDecoration.underline)),
                                // ),
                                ElevatedButton(
                                  onPressed: () {
                                    // print(FilterScreenResult);
                                    Navigator.pop(
                                      context,
                                      // values,
                                      FilterScreenResult(
                                        values: values,
                                        selectedFacilities: selectedFacilities,
                                        selectedPropType: selectedPropertyTypes,
                                      ),
                                    );
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Color(0xFF6246EA)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0),
                                    child: Text(
                                      "Submit",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
