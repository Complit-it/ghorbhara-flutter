import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hello_world/models/property.dart';
import 'package:hello_world/pages/chat_screen.dart';
import 'package:hello_world/services/property_functions.dart';
// import 'package:http/http.dart';

import '../constant.dart';
import '../models/booking.dart';
import '../models/chat_user.dart';
import '../services/user_service.dart';

class BookingRequests extends StatefulWidget {
  const BookingRequests({super.key});

  @override
  State<BookingRequests> createState() => _BookingRequestsState();
}

class _BookingRequestsState extends State<BookingRequests> {
  int? userId;
  List<Property> properties = [];
  Property? props;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    // loadUserId();
    fetchData();
  }

  void fetchData() async {
    userId = await getUserId();
    // print(userId);
    String url = getBookPropUrl;
    String data = 'userId=$userId';
    final apiResponse = await getReq(url, data);
    if (apiResponse.error == null) {
      if (mounted) {
        // setState(() {});
        setState(() {
          properties = apiResponse.data as List<Property>;
          isLoading = false;
        });
      }

      // print('properties : $properties');
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SafeArea(
                child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 21, right: 21),
                  child: Column(children: [
                    Container(
                      child: properties.isEmpty
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
                                    'No properties booked',
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
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: properties.length,
                              itemBuilder: (context, index) {
                                Property property = properties[index];
                                final imageUrl =
                                    baseUrl + property.image!.imagePath!;
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      top: 14.0, bottom: 0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.3),
                                          spreadRadius: 0.3,
                                          blurRadius: 1,
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(0),
                                          child: Container(
                                            height: 200,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topLeft: Radius.circular(7),
                                                topRight: Radius.circular(7),
                                              ),
                                              child: CachedNetworkImage(
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
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12, horizontal: 14),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  property.title.toUpperCase(),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 16,
                                                      fontFamily: 'Hind',
                                                      color: Colors.grey[700]),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 28,
                                              ),
                                              RichText(
                                                text: TextSpan(
                                                  style: DefaultTextStyle.of(
                                                          context)
                                                      .style,
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                      text:
                                                          'Rs ${property.price}',
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: ' /month',
                                                      style: TextStyle(
                                                        color: Colors.grey[400],
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 0, horizontal: 14),
                                          child: Divider(),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12, horizontal: 14),
                                          child: Text(
                                            'Booking Requests',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                                fontFamily: 'Hind',
                                                color: Colors.grey[700]),
                                          ),
                                        ),
                                        ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: property.bookings?.length,
                                          itemBuilder: (context, bookingIndex) {
                                            Booking booking = property
                                                .bookings![bookingIndex];
                                            User? user = booking.user;

                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 14.0,
                                                      vertical: 8.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(7),
                                                  color: const Color.fromARGB(
                                                      255, 104, 121, 220),
                                                  // boxShadow: [
                                                  //   BoxShadow(
                                                  //     color: Colors.grey
                                                  //         .withOpacity(0.3),
                                                  //     spreadRadius: 0.3,
                                                  //     blurRadius: 1,
                                                  //   ),
                                                  // ],
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 12),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            user != null
                                                                ? user.name!
                                                                : 'Unknown User',
                                                            style: const TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                          IconButton(
                                                            onPressed:
                                                                () async {
                                                              try {
                                                                // Fetch user details
                                                                var userDoc = await API
                                                                    .getUserById(
                                                                        user!
                                                                            .google_id!);

                                                                // Convert to ChatUser
                                                                var chatUser =
                                                                    ChatUser.fromJson(
                                                                        userDoc
                                                                            .data()!);

                                                                // Navigate to ChatScreen
                                                                if (mounted) {
                                                                  Navigator
                                                                      .push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder: (_) =>
                                                                          ChatScreen(
                                                                              user: chatUser),
                                                                    ),
                                                                  );
                                                                }
                                                              } catch (e) {
                                                                // print('Error: $e');
                                                                // Handle error (e.g., show a snackbar or dialog)
                                                              }
                                                            },
                                                            icon: const Icon(
                                                              Icons.message,
                                                              size: 18,
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      255,
                                                                      255,
                                                                      255),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      Text(
                                                        booking.bookingDate!,
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Color.fromARGB(
                                                              255,
                                                              255,
                                                              255,
                                                              255),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                    )
                  ]),
                ),
              )));
  }
}
