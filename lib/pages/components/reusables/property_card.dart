import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hello_world/constant.dart';
import 'package:hello_world/models/property.dart';

import '../../../services/property_functions.dart';
import '../../../services/user_service.dart';
import '../../property_main.dart';

class PropertyCard extends StatefulWidget {
  final Property property;
  final bool? showFavBtn;
  const PropertyCard({super.key, required this.property, this.showFavBtn});

  @override
  State<PropertyCard> createState() => _PropertyCardState();
}

class _PropertyCardState extends State<PropertyCard> {
  // final imageUrl = baseUrl + widget.property.image!.imagePath;
  late bool showFavBtn;
  int? userId;

  @override
  void initState() {
    super.initState();
    showFavBtn = widget.showFavBtn ?? true;
    loadUserId();
    // print('explore: ${widget.property}');
  }

  Future<void> loadUserId() async {
    userId = await getUserId();
    // print(userId);
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

  @override
  Widget build(BuildContext context) {
    const String defaultUrl =
        'https://images.unsplash.com/photo-1532264523420-881a47db012d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9';
    final String? imagePath = widget.property.image?.imagePath;
    final String imageUrl =
        imagePath != null ? baseUrl + imagePath : defaultUrl;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  PropertyMainScreen(property: widget.property)),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        child: Container(
          height: 150,
          width: 120,

          // width: MediaQuery.of(context).size.width - 222,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            // color: Colors.pink,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 0.3,
                blurRadius: 1,
                // offset: Offset(0, 6),
              ),
            ],
          ),

          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 150, //200
                width: 120, //90
                // decoration: BoxDecoration(
                //   borderRadius: BorderRadius.circular(27),
                // ),
                // child: Image.network(
                //   imageUrl,
                //   // property.image!.imagePath,
                //   fit: BoxFit.fill,
                //   // height: 245.0,
                // ),
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
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => const Icon(
                      Icons.broken_image,
                      size: 50,
                      color: Colors.grey,
                    ),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Container(
                  height: 200,
                  width: 180,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, top: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // const Row(
                        //   children: [
                        //     Icon(
                        //       Icons.star,
                        //       color: Colors.yellow,
                        //       size: 18,
                        //     ),
                        //     SizedBox(width: 3),
                        //     Text(
                        //       '4.8 (73)',
                        //       style: TextStyle(fontSize: 12),
                        //     ),
                        //   ],
                        // ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: getColor(widget
                                      .property.propertyType?.color ??
                                  "#6246EA"), // Use default hex string if null
                              borderRadius:
                                  BorderRadius.circular(12), // Rounded corners
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.25),
                                  spreadRadius: 1,
                                  blurRadius: 1,
                                  offset:
                                      const Offset(0, 1.5), // Shadow position
                                ),
                              ],
                            ),
                            child: Text(
                              widget.property.propertyType?.propertyType ??
                                  'Residential Property',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            widget.property.title.toUpperCase(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                fontFamily: 'Hind',
                                color: Colors.grey[700]),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: Text(
                              widget.property.location?.location ??
                                  'Location unavailable',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 13, color: Colors.grey[700]),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
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
                              if (widget.property.rooms.isNotEmpty)
                                Text(
                                  "${widget.property.rooms} rooms",
                                  style: TextStyle(
                                    color: Colors.grey[700],
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
                              if (widget.property.area.isNotEmpty)
                                Text(
                                  "${widget.property.area} m2",
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 12,
                                  ),
                                )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Row(
                              // mainAxisAlignment:
                              //     MainAxisAlignment.spaceAround,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    style: DefaultTextStyle.of(context).style,
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: 'Rs ${widget.property.price}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        ),
                                      ),
                                      TextSpan(
                                        text: ' /month',
                                        style: TextStyle(
                                          color: Colors.grey[400],
                                          fontSize: 12,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 40,
                                ),
                                // GestureDetector(
                                //   onTap: () {
                                //     debugPrint('Added to Wishlist');
                                //   },
                                //   child: Icon(
                                //     Icons.favorite_border,
                                //     color: Colors.grey[700],
                                //     size: 18,
                                //   ),
                                // )
                                if (showFavBtn == true)
                                  GestureDetector(
                                    onTap: () async {
                                      await _favToggle(widget.property);
                                      debugPrint('Favorite toggled');
                                    },
                                    child: Icon(
                                      widget.property.isFav!
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: widget.property.isFav!
                                          ? Colors.red
                                          : Colors.grey[700],
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
  }
}
