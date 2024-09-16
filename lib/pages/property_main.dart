// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hello_world/constant.dart';
// import 'package:hello_world/models/api_response.dart';
import 'package:hello_world/models/property.dart';
import 'package:hello_world/services/property_functions.dart';
import 'package:hello_world/services/user_service.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../helper/dialogs.dart';
import '../models/chat_user.dart';
import 'chat_screen.dart';

class PropertyMainScreen extends StatefulWidget {
  final Property property;
  const PropertyMainScreen({super.key, required this.property});

  @override
  State<PropertyMainScreen> createState() => _PropertyMainScreenState();
}

class _PropertyMainScreenState extends State<PropertyMainScreen> {
  Property? propertyNew;
  bool isLoading = true;
  String? errorMessage;
  bool isFav = false;
  int? userId;
  String? mail;
  String? phoneNo;
  //  Future<int> _userId = ;
  late Razorpay _razorpay;
  // static const String _razorpayKey = 'rzp_test_NRUeeNsMSYtl4x';
  static const String _razorpayKey = 'rzp_live_yNTs8q4TxSKx67';

  @override
  void initState() {
    super.initState();
    fetchProperty();
    loadUserId();
    loadEmail();
    loadphone();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    Dialogs.showProgressBar(context);
    final result = await _verifyPayment(
      response.orderId!,
      response.paymentId!,
      response.signature!,
    );

    if (result) {
      // print('Payment Success: ${DateTime.now()}');
      final int price = int.parse(propertyNew!.price!);
      final apiResponse = await bookProp(
          userId.toString(),
          widget.property.id.toString(),
          response.orderId!,
          response.paymentId!,
          price);

      if (apiResponse.error == null) {
        if (mounted) {
          final scaffoldMessenger = ScaffoldMessenger.of(context);
          Navigator.pop(context);
          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Text('Property Booked'),
              backgroundColor: Color(0xFF6246EA),
            ),
          );
        }
      } else {
        if (mounted) {
          Dialogs.showSnackbar(context, 'Payment failed, please try again.',
              backgroundColor: Colors.red);
        }
      }
    } else {
      if (mounted) {
        Dialogs.showSnackbar(context, 'Payment failed, please try again.',
            backgroundColor: Colors.red);
      }
    }
  }

  void _paylater(int userId, int amount, int propId) async {
    // print(userId);
    // print(propId);
    // print(amount);
    final int price = int.parse(propertyNew!.price!);
    final apiResponse = await payLaterBookProp(
        userId,
        widget.property.id,
        // response.orderId!,
        // response.paymentId!,
        amount);

    if (apiResponse.error == null) {
      if (mounted) {
        final scaffoldMessenger = ScaffoldMessenger.of(context);
        Navigator.pop(context);
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text('Property Booked'),
            backgroundColor: Color(0xFF6246EA),
          ),
        );
      }
    } else {
      if (mounted) {
        Dialogs.showSnackbar(context, 'Payment failed, please try again.',
            backgroundColor: Colors.red);
      }
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print('Payment Error: ${response.code} - ${response.message}');
    Dialogs.showSnackbar(context, 'Payment failed, please try again.',
        backgroundColor: Colors.red);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print('External Wallet: ${response.walletName}');
  }

  Future<void> _createOrder(int amount) async {
    Navigator.of(context).pop();
    Dialogs.showProgressBar(context);
    final response = await http.post(
      Uri.parse('$baseURL/create-order'),
      body: jsonEncode({'amount': amount}),
      headers: {'Content-Type': 'application/json'},
    );
    // print(response.toString());
    if (response.statusCode == 200) {
      final orderData = jsonDecode(response.body);
      _openCheckout(orderData['order_id'], orderData['amount']);
    } else {
      if (mounted) {
        Navigator.of(context).pop();
        Dialogs.showSnackbar(
            context, 'Oops, something went wrong. Please try again.');
      }
    }
  }

  Future<bool> _verifyPayment(
      String orderId, String paymentId, String signature) async {
    final response = await http.post(
      Uri.parse('$baseURL/verify-payment'),
      body: jsonEncode({
        'razorpay_order_id': orderId,
        'razorpay_payment_id': paymentId,
        'razorpay_signature': signature,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    final responseData = jsonDecode(response.body);
    return responseData['status'] == 'success';
  }

  void _openCheckout(String orderId, int amount) {
    print('ohonne: $phoneNo');
    var options = {
      'key': _razorpayKey,
      'amount': amount,
      'name': 'Ghorbhara',
      'order_id': orderId,
      'description': 'Ghorbhara',
      'prefill': {'contact': phoneNo, 'email': mail!},
      // 'external': {
      //   'wallets': ['paytm']
      // }
    };

    try {
      if (mounted) {
        Navigator.of(context).pop();
      }
      _razorpay.open(options);
    } catch (e) {
      print('Error: $e');
    }
  }

  static Marker _kMarker = Marker(
    markerId: MarkerId('_kGooglePlexMarker'),
    position: LatLng(37.42796133580664, -122.085749655962),
    // position: LatLng(37.42796133580664, -122.085749655962),
    infoWindow:
        InfoWindow(title: 'Google Plex', snippet: 'Google Headquarters'),
  );

  Future<void> favToogle() async {
    if (userId == null) {
      return;
    }
    if (!isFav) {
      final apiResponse =
          await add_to_fav(prop_id: widget.property.id, user_id: userId!);
      if (apiResponse.error == null) {
        if (mounted) {
          setState(() {
            isFav = true;
            widget.property.isFav = true;
            // print(widget.property.isFav);
          });
        }
      }
    } else {
      final apiResponse =
          await remove_fav(prop_id: widget.property.id, user_id: userId!);
      if (apiResponse.error == null) {
        if (mounted) {
          setState(() {
            isFav = false;
            widget.property.isFav = false;
            // print(widget.property.isFav);
          });
        }
      }
    }
  }

  Future<void> loadUserId() async {
    userId = await getUserId();
    // Perform any other initializations that depend on userId here
  }

  Future<void> loadEmail() async {
    mail = await getEmail();
    // Perform any other initializations that depend on userId here
  }

  Future<void> loadphone() async {
    phoneNo = await getPhone();
    // Perform any other initializations that depend on userId here
  }

  Future<void> fetchProperty() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      int? id = pref.getInt('userId');

      final apiResponse = await get_one_property(widget.property.id, id!);
      if (apiResponse.error == null) {
        if (mounted) {
          setState(() {
            propertyNew = apiResponse.data as Property;
            isLoading = false;
            isFav = propertyNew!.isFav!;
            print(isFav);
            print(propertyNew);

            _kGooglePlex = CameraPosition(
              target: LatLng(double.parse(propertyNew!.location!.lat!),
                  double.parse(propertyNew!.location!.long!)),
              zoom: 14.4746,
            );

            _kMarker = Marker(
              markerId: MarkerId('_kGooglePlexMarker'),
              position: LatLng(double.parse(propertyNew!.location!.lat!),
                  double.parse(propertyNew!.location!.long!)),
              infoWindow: InfoWindow(
                  title: propertyNew!.title,
                  snippet: propertyNew!.location!.location),
            );
          });
          // print('Property Location: $propertyNew');
        }
      } else {
        setState(() {
          errorMessage = 'Error fetching properties';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
    }
  }

  static CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : propertyNew == null
                ? Center(child: Text(errorMessage ?? 'Something went wrong'))
                : SingleChildScrollView(
                    child: Column(
                      // primary: false,
                      // shrinkWrap: true,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 300,
                          child: Stack(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 300,
                                //image slider package to display property images
                                child: AnotherCarousel(
                                  boxFit: BoxFit.contain,
                                  autoplay: false,
                                  dotSize: 8.0,
                                  dotSpacing: 18,
                                  dotIncreaseSize: 1.5,
                                  dotIncreasedColor:
                                      Color.fromARGB(255, 98, 70, 234),
                                  dotColor: Color.fromARGB(255, 128, 108, 226),
                                  dotBgColor: Colors.transparent,
                                  dotPosition: DotPosition.bottomCenter,
                                  dotVerticalPadding: 10.0,
                                  showIndicator: true,
                                  indicatorBgPadding: 7.0,
                                  images: propertyNew?.images?.map((image) {
                                        return NetworkImage(
                                            '${baseUrl}${image.imagePath}');
                                      }).toList() ??
                                      [],
                                ),
                              ),
                              Positioned(
                                top: 0,
                                left: 0,
                                right: 0,
                                child: AppBar(
                                  title: Text(''),
                                  backgroundColor: Colors.transparent,
                                  elevation: 0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          // color: Colors.amber,
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 21, right: 21, top: 21, bottom: 14),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      propertyNew!.title,
                                      style: TextStyle(
                                        fontFamily: 'Hind',
                                        fontSize: 20,
                                        fontWeight: FontWeight.w400,
                                        height: 1.3,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 50,
                                  ),
                                  IconButton(
                                    onPressed: favToogle,
                                    icon: Icon(
                                      isFav
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: isFav ? Colors.red[800] : null,
                                    ),
                                  )
                                ]),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 0, left: 21, right: 54),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Row(children: [
                                  Icon(
                                    Icons.house,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    '${propertyNew?.area} m2',
                                    style: TextStyle(color: Colors.grey),
                                  )
                                ]),
                              ),
                              // Container(
                              //   child: Row(children: [
                              //     Icon(
                              //       Icons.star,
                              //       color: Colors.amber,
                              //     ),
                              //     SizedBox(
                              //       width: 8,
                              //     ),
                              //     Text(
                              //       "4.1 (66 reviews)",
                              //       style: TextStyle(color: Colors.grey),
                              //     )
                              //   ]),
                              // ),
                              Container(
                                child: Row(children: [
                                  Icon(
                                    Icons.bed_outlined,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    '${propertyNew?.rooms} room',
                                    style: TextStyle(color: Colors.grey),
                                  )
                                ]),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 8.0, left: 21, right: 54),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Row(children: [
                                  Icon(
                                    Icons.location_on,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    propertyNew!.location?.location ??
                                        'Location Unavailable',
                                    style: TextStyle(color: Colors.grey),
                                  )
                                ]),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 21, right: 0, bottom: 0, top: 22),
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CircleAvatar(
                                child: Icon(Icons.person_rounded,
                                    size: 32,
                                    color: const Color.fromARGB(
                                        255, 116, 116, 117)),
                              ),
                              SizedBox(width: 12),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${propertyNew?.user?.name}',
                                    textAlign: TextAlign.left,
                                  ),
                                  Text(
                                    "Property owner",
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 10),
                                  )
                                ],
                              ),
                              SizedBox(width: 150),
                              IconButton(
                                onPressed: () async {
                                  try {
                                    // Fetch user details
                                    var userDoc = await API.getUserById(
                                        propertyNew!.user!.google_id!);

                                    // Convert to ChatUser
                                    var chatUser =
                                        ChatUser.fromJson(userDoc.data()!);

                                    // Navigate to ChatScreen
                                    if (mounted) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              ChatScreen(user: chatUser),
                                        ),
                                      );
                                    }
                                  } catch (e) {}
                                },
                                icon: Icon(
                                  Icons.message,
                                  // size: 22,
                                  color: Colors.grey,
                                ),
                              )
                            ],
                          ),
                        ),
                        propertyNew?.homeFacilities != null
                            ? Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 21,
                                        right: 21,
                                        top: 12,
                                        bottom: 12),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Features & Amenities",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontFamily: 'Hind',
                                              fontSize: 18),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount:
                                          propertyNew!.homeFacilities?.length ??
                                              0,
                                      itemBuilder: (context, index) {
                                        // Safely access the facility string
                                        final facility = propertyNew!
                                                .homeFacilities?[index]
                                                .facility
                                                .facility ??
                                            'Unknown Facility';

                                        return Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              21, 0, 21, 12),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.check_circle_outlined,
                                                color: Colors.grey[400],
                                              ),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              Text(
                                                facility,
                                                style: TextStyle(
                                                  fontFamily: 'Hind',
                                                  fontSize: 16,
                                                  color: Colors.grey[850],
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              )
                            : SizedBox
                                .shrink(), // Or any other widget you want to display when homeFacilities is null

                        Padding(
                          padding: const EdgeInsets.only(
                              left: 21, right: 21, top: 14, bottom: 0),
                          child: Text(
                            "About This Home",
                            // "About location's neighborhood",
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Hind',
                                fontSize: 18),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 21, right: 21, top: 8, bottom: 0),
                          child: Text(
                            propertyNew!.about,
                            style: TextStyle(
                                fontFamily: 'Hind',
                                fontSize: 16,
                                color: Colors.grey),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 21, right: 21, top: 14, bottom: 0),
                          child: Text(
                            "Location",
                            // "About location's neighborhood",
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Hind',
                                fontSize: 18),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 21, right: 21, top: 8, bottom: 0),
                          child: Container(
                            height: 200,
                            width: 350,
                            child: GoogleMap(
                              initialCameraPosition: _kGooglePlex,
                              zoomControlsEnabled: false,
                              scrollGesturesEnabled: false,
                              zoomGesturesEnabled: false,
                              tiltGesturesEnabled: false,
                              rotateGesturesEnabled: false,
                              markers: {_kMarker},
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(
                              left: 21, right: 21, top: 22, bottom: 0),
                          child: GestureDetector(
                            onTap: () {
                              // Add your button tap logic here
                              // print("Button tapped!");
                            },
                            child: Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Color(0xFF6246EA),
                                borderRadius: BorderRadius.circular(28),
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        // alignment: Alignment.center,
                                        // title: Text('Payment Options'),
                                        content: Text(
                                          'Choose a payment option:',
                                          style: TextStyle(
                                              // color: Colors.white,
                                              fontFamily: 'Hind',
                                              fontWeight: FontWeight.w700),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              if (propertyNew != null &&
                                                  propertyNew!.price != null) {
                                                final int price = int.parse(
                                                    propertyNew!.price!);

                                                _createOrder(
                                                    price); // Pass the amount you want to charge
                                              } else {
                                                print('Price is null');
                                              }
                                            },
                                            child: Text('Pay Now'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              // Handle "Pay Later" action here
                                              final int price = int.parse(
                                                  propertyNew!.price!);
                                              _paylater(userId!, price,
                                                  propertyNew!.id!);
                                              // print('Pay Later selected');
                                            },
                                            child: Text('Pay at Property'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Monthly Lease",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "Rs${propertyNew!.price}/month",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 32,
                        )
                      ],
                    ),
                  ),
      ),
    );
  }
}
