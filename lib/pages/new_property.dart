// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_field, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
// import 'package:hello_world/data/property_type.dart';
import 'package:hello_world/data/room.dart';
import 'package:hello_world/models/api_response.dart';
import 'package:hello_world/models/location.dart';
import 'package:http/http.dart' as http;
import 'package:hello_world/models/options.dart';
import 'package:hello_world/pages/components/location_container.dart';
import 'package:hello_world/pages/components/reusables/form_fields.dart';
import 'package:hello_world/services/location_function.dart';
import 'package:hello_world/services/property_functions.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:hello_world/services/user_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
// import 'dart:io';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';

import '../constant.dart';
import '../helper/dialogs.dart';

class NewProp extends StatefulWidget {
  const NewProp({super.key});

  @override
  State<NewProp> createState() => _NewPropState();
}

class _NewPropState extends State<NewProp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<Options> selectedFac = [];
  List<PropTypeOptions> selectedPropType = [];
  bool? isChecked = false;
  // Options? selectedPropertyType;
  int? property_type_id;
  Options? selectedValue;
  int room_id = 0;
  bool loading = false;
  String location = 'Loading...';
  String? lat;
  String? long;
  GlobalKey<FormFieldState<dynamic>> _multiSelectKey =
      GlobalKey<FormFieldState<dynamic>>();
  GlobalKey<FormFieldState<dynamic>> _propTypeKey =
      GlobalKey<FormFieldState<dynamic>>();

  TextEditingController _title = TextEditingController();
  TextEditingController _address = TextEditingController();
  TextEditingController _area = TextEditingController();
  TextEditingController _about = TextEditingController();
  TextEditingController _price = TextEditingController();
  final List<XFile> selectedImages = [];
  bool locationFlag = false;
  final LocationService _locationService = LocationService();
  List<Options> propertyTypes = [];
  Options? selectedPropertyType;
  int? propertyTypeId;

  void _updateLocation(Map<String, dynamic> locationData) {
    setState(() {
      location = locationData['name'];
      lat = locationData['lat'].toString();
      long = locationData['lng'].toString();
      print(lat);
      print(long);
    });
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
      });
    } else {
      throw Exception('Failed to load property types');
    }
  }

  Future<void> _getLocationData() async {
    setState(() {
      location = 'Loading...';
    });
    kLocation retrievedAddress = await _locationService.getAddress();
    if (retrievedAddress.error == null) {
      if (mounted) {
        setState(() {
          location = retrievedAddress.location!; // Update address controller
          lat = retrievedAddress.lat;
          long = retrievedAddress.long;
          locationFlag = true;
          print(lat);
          print(long);
        });
      }
      print(_address.text);
    } else {
      // Handle location retrieval error (optional)
      if (mounted) {
        setState(() {
          location = retrievedAddress.error!;
          locationFlag = false;
          print(retrievedAddress.error);
          print(locationFlag);
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // Call getSubjectData() when the screen is loaded
    getHomeFacility();
    // getPropType();
    fetchPropertyTypes();
    _getLocationData();
  }

  Future<void> addImages() async {
    final picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage(
      maxWidth: 800, // can be customized
      maxHeight: 600, // can be customized
    );

    if (images != null) {
      for (XFile image in images) {
        // selectedImages.add(File(image.path));
        setState(() {
          selectedImages.add(XFile(image.path));
        });
      }
    }
  }

  save() async {
    String title = _title.text;
    String address = _address.text;
    String area = _area.text;
    String about = _about.text;
    int userId = await getUserId();
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    ApiResponse response = await uploadProperty(
        selectedImages,
        title,
        address,
        area,
        about,
        property_type_id!,
        room_id!,
        selectedFac,
        location,
        _price.text,
        userId,
        lat,
        long);

    if (response.error == null) {
      setState(() {
        loading = false;
        selectedImages.clear();
        _title.clear();
        _about.clear();
        _area.clear();
        _address.clear();
        _price.clear();
        selectedPropertyType = null;
        property_type_id = null;
        isChecked = false;
        selectedFac.clear();
        _multiSelectKey = GlobalKey<FormFieldState<dynamic>>();
        // print(selectedFac);
      });
      // scaffoldMessenger.showSnackBar(
      // SnackBar(
      //   content: Text('Property enlisted successfully.'),
      //   // backgroundColor: Colors.red,
      // ),
      if (mounted) {
        Dialogs.showSnackbar(context, 'Property enlisted successfully.',
            backgroundColor: Colors.green);
      }
      // );
    } else {
      setState(() {
        loading = false;
      });
      // scaffoldMessenger.showSnackBar(
      //   SnackBar(
      //     content: Text('Something went wrong.'),
      //     // backgroundColor: Colors.red,
      //   ),
      // );
      if (mounted) {
        Dialogs.showSnackbar(context, 'Something went wrong.',
            backgroundColor: Colors.red);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool isScrolled) => [
          SliverAppBar(
            toolbarHeight: 28,
            surfaceTintColor: Colors.transparent,
            backgroundColor: Colors.white, // Set this to a fixed color
            floating: true, // Optional: keeps the app bar visible
            snap: true, // Optional: animates the app bar
            scrolledUnderElevation: 0,
            elevation: 0, // Removes any elevation shadow
          ),
        ],
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 21, right: 21),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "List new property",
                            style: TextStyle(
                              fontFamily: 'Hind',
                              fontSize: 36,
                              fontWeight: FontWeight.w700,
                              height: 1.0,
                            ),
                          )),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "List in the market where renter are waiting!",
                            style: TextStyle(
                              fontFamily: 'Hind',
                              fontSize: 16,
                              // fontWeight: FontWeight.w700,
                              color: Colors.grey[400],
                              height: 1.0,
                            ),
                          )),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            DropdownButtonHideUnderline(
                              child: DropdownButton2<Options>(
                                isExpanded: true,
                                hint: Row(
                                  children: [
                                    // Icon(
                                    //   Icons.list,
                                    //   size: 16,
                                    //   // color: Colors.yellow, // Uncomment if you want a yellow color
                                    // ),
                                    SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        'Property Types',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[500],
                                          // fontWeight: FontWeight.bold,
                                          fontFamily: 'Hind',
                                          // color: Colors.yellow, // Uncomment if you want a yellow color
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                items: propertyTypes
                                    .map((Options propertyType) =>
                                        DropdownMenuItem<Options>(
                                          value: propertyType,
                                          child: Text(
                                            propertyType.name.toString(),
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[800],
                                              fontFamily: 'Hind',
                                            ),
                                          ),
                                        ))
                                    .toList(),
                                value: selectedPropertyType,
                                onChanged: (Options? newValue) {
                                  // print(newValue?.id);
                                  setState(() {
                                    selectedPropertyType = newValue!;
                                    property_type_id = newValue.id;
                                  });
                                },
                                buttonStyleData: ButtonStyleData(
                                  height: 50,
                                  width: 160,
                                  padding: const EdgeInsets.only(
                                      left: 14, right: 14),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    // border: Border.all(color: Colors.black26),
                                    color: Color.fromARGB(102, 235, 236, 236),
                                  ),
                                  // elevation: 1,
                                ),
                                iconStyleData: IconStyleData(
                                  icon: Icon(Icons.arrow_forward_ios_outlined),
                                  iconEnabledColor: Colors.grey[500],
                                  iconSize: 14,
                                ),
                                dropdownStyleData: DropdownStyleData(
                                  maxHeight: 200,
                                  width: 160,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    color: Colors.grey[300],
                                  ),
                                  offset: const Offset(20, 0),
                                  scrollbarTheme: ScrollbarThemeData(
                                    radius: const Radius.circular(40),
                                    thickness:
                                        MaterialStateProperty.all<double>(6),
                                    thumbVisibility:
                                        MaterialStateProperty.all<bool>(true),
                                  ),
                                ),
                                menuItemStyleData: const MenuItemStyleData(
                                  height: 40,
                                  padding: EdgeInsets.only(left: 14, right: 14),
                                ),
                              ),
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.only(
                            //       left: 0.0, right: 0, top: 14),
                            //   child: MultiSelectDialogField(
                            //     key: _propTypeKey,
                            //     items: propType,
                            //     title: const Text(
                            //       "Select Property Type",
                            //       // style: TextStyle(color: Colors.black),
                            //     ),
                            //     selectedColor: Colors.grey[600],
                            //     decoration: BoxDecoration(
                            //       color: Color.fromARGB(102, 235, 236, 236),
                            //       borderRadius: const BorderRadius.all(
                            //           Radius.circular(30)),
                            //       // border: Border.all(
                            //       //   color: Colors.black,
                            //       //   width: 1,
                            //       // ),
                            //     ),
                            //     buttonIcon: Icon(
                            //       Icons.arrow_drop_down,
                            //       color: Colors.grey[500],
                            //     ),
                            //     buttonText: Text(
                            //       "Select Property Type",
                            //       style: TextStyle(
                            //         color: Colors.grey[500],
                            //         fontSize: 14,
                            //         fontFamily: 'Hind',
                            //       ),
                            //     ),
                            //     onConfirm: (results) {
                            //       selectedPropType.clear();
                            //       for (var item in results) {
                            //         selectedPropType
                            //             .add(item! as PropTypeOptions);
                            //       }
                            //       print(selectedPropType);
                            //       // print("Selected Subjects: $selectedFac");
                            //     },
                            //   ),
                            // ),

                            DropdownButtonHideUnderline(
                              child: DropdownButton2<Options>(
                                isExpanded: true,
                                hint: Row(
                                  children: [
                                    // Icon(
                                    //   Icons.list,
                                    //   size: 16,
                                    //   // color: Colors.yellow,
                                    // ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Expanded(
                                      child: Text(
                                        'Rooms',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'Hind',
                                          // fontWeight: FontWeight.bold,
                                          color: Colors.grey[500],
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                items: items
                                    .map((Options item) =>
                                        DropdownMenuItem<Options>(
                                          value: item,
                                          child: Text(
                                            '${item.name}',
                                            style: TextStyle(
                                              fontSize: 14,
                                              // color: const Color.fromARGB(255, 0, 0, 0),
                                              color: Colors.grey[800],
                                              // fontWeight: FontWeight.bold,
                                              fontFamily: 'Hind',
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ))
                                    .toList(),
                                value: selectedValue,
                                onChanged: (Options? value) {
                                  setState(() {
                                    selectedValue = value!;
                                    room_id = value.id;
                                    // print(room_id);
                                  });
                                },
                                buttonStyleData: ButtonStyleData(
                                  height: 50,
                                  width: 130,
                                  padding: const EdgeInsets.only(
                                      left: 14, right: 14),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    // border: Border.all(
                                    //   color: Colors.black26,
                                    // ),
                                    color: Color.fromARGB(102, 235, 236, 236),
                                  ),
                                  // elevation: 1,
                                ),
                                iconStyleData: IconStyleData(
                                  icon: Icon(
                                    Icons.arrow_forward_ios_outlined,
                                  ),
                                  iconSize: 14,
                                  iconEnabledColor: Colors.grey[500],
                                  // iconDisabledColor: Colors.grey,
                                ),
                                dropdownStyleData: DropdownStyleData(
                                  maxHeight: 200,
                                  width: 150,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    color: Colors.grey[300],
                                  ),
                                  offset: const Offset(-20, 0),
                                  scrollbarTheme: ScrollbarThemeData(
                                    radius: const Radius.circular(40),
                                    thickness:
                                        MaterialStateProperty.all<double>(6),
                                    thumbVisibility:
                                        MaterialStateProperty.all<bool>(true),
                                  ),
                                ),
                                menuItemStyleData: const MenuItemStyleData(
                                  height: 40,
                                  padding: EdgeInsets.only(left: 14, right: 14),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 0.0, right: 0, top: 14),
                        child: MultiSelectDialogField(
                          key: _multiSelectKey,
                          items: dropDownData,
                          title: const Text(
                            "Select Home Facilities",
                            // style: TextStyle(color: Colors.black),
                          ),
                          selectedColor: Colors.grey[600],
                          decoration: BoxDecoration(
                            color: Color.fromARGB(102, 235, 236, 236),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(30)),
                            // border: Border.all(
                            //   color: Colors.black,
                            //   width: 1,
                            // ),
                          ),
                          buttonIcon: Icon(
                            Icons.arrow_drop_down,
                            color: Colors.grey[500],
                          ),
                          buttonText: Text(
                            "Select Home Facilities",
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 14,
                              fontFamily: 'Hind',
                            ),
                          ),
                          onConfirm: (results) {
                            selectedFac.clear();
                            for (var item in results) {
                              selectedFac.add(item! as Options);
                            }
                            // print("Selected Subjects: $selectedFac");
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: CustomInputField(
                          np: true,
                          controller: _title,
                          labelText: 'Property Title',
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a title.';
                            }

                            if (value.length > 50) {
                              return 'Title cannot be longer than 50 characters.';
                            }

                            final RegExp regex = RegExp(r'^[a-zA-Z\s]+$');
                            if (!regex.hasMatch(value)) {
                              return 'Title can only contain letters and spaces.';
                            }

                            return null; // No error
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: CustomInputField(
                          np: true,
                          controller: _address,
                          labelText: 'Address',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an Address.';
                            }

                            if (value.length > 50) {
                              return 'Address cannot be longer than 50 characters';
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: CustomInputField(
                          np: true,
                          controller: _area,
                          labelText: 'Area (sq ft)',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the area.'; // Customize error message for empty field (optional)
                            }
                            final RegExp regex = RegExp(r'^[0-9]+$');
                            if (!regex.hasMatch(value)) {
                              return 'Please enter a valid area (numbers only).';
                            }
                            return null; // No error
                          },
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: CustomInputField(
                          np: true,
                          controller: _about,
                          labelText: 'About',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'About cannot be empty';
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: CustomInputField(
                          np: true,
                          controller: _price,
                          labelText: 'Price',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the area.'; // Customize error message for empty field (optional)
                            }
                            final RegExp regex = RegExp(r'^[0-9]+$');
                            if (!regex.hasMatch(value)) {
                              return 'Please enter a valid area (numbers only).';
                            }
                            return null; // No error
                          },
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: LocationContainer(
                          address: location,
                          updateLocation: _updateLocation,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0, bottom: 28),
                        child: GestureDetector(
                          onTap: () {
                            // Call your function here
                            addImages();
                          },
                          child: selectedImages.isEmpty
                              ? DottedBorder(
                                  color: Colors.black,
                                  strokeWidth: 1,
                                  child: Container(
                                    width: 400,
                                    height: 100,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.upload),
                                        SizedBox(width: 20),
                                        Text("Upload Photo")
                                      ],
                                    ),
                                  ),
                                )
                              : Wrap(
                                  children: selectedImages
                                      .map((image) => buildImage(image))
                                      .toList(),
                                ),
                        ),
                      ),
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Checkbox(
                              value: isChecked,
                              activeColor: Colors.grey[600],
                              onChanged: (newBool) {
                                print(newBool);
                                setState(() {
                                  isChecked = newBool;
                                });
                              }),
                          Text("I agree to the terms and conditions ")
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 0),
                        child: loading
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 12.0),
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Color(0xFF008F17)),
                                  ),
                                ),
                              )
                            : ElevatedButton(
                                onPressed: () {
                                  // save_prop();

                                  if (_formKey.currentState!.validate()) {
                                    if (!isChecked!) {
                                      // Show Snackbar
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              'Please agree to the Terms & Conditions'),
                                          duration: Duration(
                                              seconds:
                                                  3), // Duration for which the Snackbar is visible
                                        ),
                                      );
                                      return; // Exit the function if not checked
                                    }

                                    if (selectedImages.isEmpty) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              'Please select image to upload.'),
                                          duration: Duration(
                                              seconds:
                                                  3), // Duration for which the Snackbar is visible
                                        ),
                                      );
                                      return;
                                    }
                                    if (property_type_id == null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              'Please select a property type.'),
                                          duration: Duration(
                                              seconds:
                                                  3), // Duration for which the Snackbar is visible
                                        ),
                                      );
                                      return;
                                    }

                                    if (locationFlag == false) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content:
                                              Text('Please enter location'),
                                          duration: Duration(
                                              seconds:
                                                  1), // Duration for which the Snackbar is visible
                                        ),
                                      );
                                      return;
                                    }

                                    setState(() {
                                      loading = true;
                                      save();
                                    });
                                    // save();
                                  }
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Color(0xFF008F17)),
                                  minimumSize: MaterialStateProperty.all<Size>(
                                      const Size(double.infinity, 40)),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                ),
                                child: const Text(
                                  'SUBMIT',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                      ),
                    ]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildImage(XFile image) {
    final imageFile = File(image.path);
    // print(imageFile.path);
    return Container(
      width: 50, // Adjust width and height as needed
      height: 50, // Adjust width and height as needed
      margin: EdgeInsets.all(5), // Add spacing between images (optional)
      child: Image(
        image: FileImage(imageFile),
        fit: BoxFit.cover,
      ),
    );
  }
}
