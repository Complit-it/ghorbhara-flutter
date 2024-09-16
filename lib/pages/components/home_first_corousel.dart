import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hello_world/constant.dart';
import 'package:hello_world/models/property.dart';
import 'package:hello_world/pages/list_all_props.dart';
import 'package:hello_world/pages/property_main.dart';
import 'package:hello_world/services/property_functions.dart';
import 'package:hello_world/services/user_service.dart';

// import 'package:hello_world/constant.dart';

class CorouselOne extends StatefulWidget {
  final List<Property> properties;
  const CorouselOne({super.key, required this.properties});
  //
  @override
  State<CorouselOne> createState() => _CorouselOneState();
}

class _CorouselOneState extends State<CorouselOne> {
  late bool _isFav;
  int? userId;

  @override
  void initState() {
    super.initState();
    loadUserId();
  }

  Color getColor(String? colorHex) {
    // Check if the color is null or empty
    if (colorHex == null || colorHex.isEmpty) {
      return Color(0xFF6246EA); // Default color
    } else {
      return hexToColor(colorHex); // Convert hex string to Color object
    }
  }

// Function to convert a hex color string to a Flutter Color object
  Color hexToColor(String hexString) {
    hexString = hexString.replaceAll('#', ''); // Remove '#' if present
    if (hexString.length == 6) {
      hexString = 'FF$hexString'; // Add alpha value if not present
    }
    return Color(int.parse('0x$hexString'));
  }

  Future<void> loadUserId() async {
    userId = await getUserId();
    // print(userId);
    // Perform any other initializations that depend on userId here
  }

  Future<void> _favToggle(Property property) async {
    // await loadUserId();
    if (userId == null) {
      return;
    }
    if (!property.isFav!) {
      final apiResponse =
          await add_to_fav(prop_id: property.id, user_id: userId!);
      if (apiResponse.error == null) {
        if (mounted) {
          setState(() {
            property.isFav = true;
          });
        }
      }
    } else {
      final apiResponse =
          await remove_fav(prop_id: property.id, user_id: userId!);
      if (apiResponse.error == null) {
        if (mounted) {
          setState(() {
            property.isFav = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 21.0, left: 21),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Near your location",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontFamily: 'Hind',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 21, right: 21),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Discover top nearby properties",
                  style: TextStyle(
                    color: Colors.grey[400],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ListAllProp()));
                  },
                  child: const Text(
                    "See all",
                    style: TextStyle(
                      color: Color(0xFF7879F1),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            height: 230,
            child: (widget.properties == null || widget.properties.isEmpty)
                ? const Center(
                    child: Text(
                      'No data available',
                      style: TextStyle(color: Colors.black),
                    ),
                  )
                : ListView.builder(
                    itemCount: widget.properties.length > 6
                        ? 6
                        : widget.properties.length,
                    // itemCount: 3,
                    itemBuilder: (context, index) {
                      Property property = widget.properties[index];
                      print('property :: $property');

                      final imageUrl = baseUrl + property.image!.imagePath!;
                      _isFav = property.isFav!;
                      return widget.properties.isEmpty
                          ? const Text('Oops, no property available')
                          : GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PropertyMainScreen(
                                          property: property)),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(21.0),
                                child: Container(
                                  height: 250,
                                  width: 290,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.3),
                                        spreadRadius: 1,
                                        blurRadius: 5,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        height: 200, //200
                                        width: 100, //90

                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(7),
                                            bottomLeft: Radius.circular(7),
                                          ),
                                          child: CachedNetworkImage(
                                            // imageUrl:
                                            //     'https://images.unsplash.com/photo-1532264523420-881a47db012d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9',
                                            imageUrl: imageUrl,
                                            placeholder: (context, url) =>
                                                const Center(
                                                    child:
                                                        CircularProgressIndicator()),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                      Container(
                                          height: 170,
                                          width: 190,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15, top: 0, right: 8),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Align(
                                                  alignment: Alignment.topRight,
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 8,
                                                        vertical: 4),
                                                    decoration: BoxDecoration(
                                                      color: getColor(property
                                                          .propertyType!
                                                          .color), // Background color
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12), // Rounded corners
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.grey
                                                              .withOpacity(
                                                                  0.25),
                                                          spreadRadius: 1,
                                                          blurRadius: 1,
                                                          offset: const Offset(
                                                              0,
                                                              1.5), // Shadow position
                                                        ),
                                                      ],
                                                    ),
                                                    child: Text(
                                                      property.propertyType!
                                                          .propertyType,
                                                      style: const TextStyle(
                                                        fontSize: 8,
                                                        color: Colors
                                                            .white, // You can adjust this based on the background color
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 8.0),
                                                  child: Text(
                                                    property.title
                                                        .toUpperCase(),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 16,
                                                        fontFamily: 'Hind',
                                                        color:
                                                            Colors.grey[700]),
                                                  ),
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 11.0),
                                                    child: Text(
                                                      property.location
                                                              ?.location ??
                                                          'Location Unavailable',
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          color:
                                                              Colors.grey[700]),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 6),
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.bed_rounded,
                                                        color: Colors.grey[700],
                                                        size: 20,
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      if (property.rooms !=
                                                              null &&
                                                          property
                                                              .rooms.isNotEmpty)
                                                        Text(
                                                          "${property.rooms} rooms",
                                                          style: TextStyle(
                                                            color: Colors
                                                                .grey[700],
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Icon(
                                                        Icons.house_rounded,
                                                        color: Colors.grey[700],
                                                        size: 20,
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      if (property.area !=
                                                              null &&
                                                          property
                                                              .area.isNotEmpty)
                                                        Text(
                                                          "${property.area} m2",
                                                          style: TextStyle(
                                                            color: Colors
                                                                .grey[700],
                                                            fontSize: 12,
                                                          ),
                                                        )
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 34),
                                                  child: Row(
                                                      // mainAxisAlignment:
                                                      //     MainAxisAlignment.spaceAround,
                                                      children: [
                                                        RichText(
                                                          text: TextSpan(
                                                            style: DefaultTextStyle
                                                                    .of(context)
                                                                .style,
                                                            children: <TextSpan>[
                                                              TextSpan(
                                                                text:
                                                                    'Rs ${property.price}',
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              ),
                                                              TextSpan(
                                                                text: ' /month',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                          .grey[
                                                                      400],
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 35,
                                                        ),
                                                        GestureDetector(
                                                          onTap: () async {
                                                            await _favToggle(
                                                                property);
                                                            debugPrint(
                                                                'Favorite toggled');
                                                          },
                                                          child: Icon(
                                                            property.isFav!
                                                                ? Icons.favorite
                                                                : Icons
                                                                    .favorite_border,
                                                            color: property
                                                                    .isFav!
                                                                ? Colors.red
                                                                : Colors
                                                                    .grey[700],
                                                            size: 18,
                                                          ),
                                                        ),
                                                      ]),
                                                )
                                              ],
                                            ),
                                          ))
                                    ],
                                  ),
                                ),
                              ),
                            );
                    },
                    scrollDirection: Axis.horizontal,
                    // itemCount: 3,
                    // itemExtent: 340,
                  ),
          ),
        ],
      ),
    );
  }
}
