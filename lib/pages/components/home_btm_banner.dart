// ignore_for_file: avoid_unnecessary_containers, sized_box_for_whitespace

import 'package:flutter/material.dart';

class BtmBanner extends StatefulWidget {
  const BtmBanner({super.key});

  @override
  State<BtmBanner> createState() => _BtmBannerState();
}

class _BtmBannerState extends State<BtmBanner> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 21, right: 21, top: 54),
      child: Container(
        // color: Colors.black26,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.6),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(0),
          // padding: const EdgeInsets.only(left: 21, right: 21),
          child: Row(
            children: [
              Container(
                height: 240,
                width: 200,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF917AFD), // Start color
                      Color(0xFF6246EA), // End color
                    ],
                    stops: [0.0261, 0.9658], // Gradient stops
                  ),
                ),
                child: Column(
                  children: [
                    const Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 24.0, top: 24),
                          child: Text(
                            "Want to host \nyour own \nplace?",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 21,
                              fontFamily: 'Hind',
                              height: 1.15,
                            ),
                          ),
                        )),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 24.0, top: 10),
                        // padding: EdgeInsets.only(left: 0, top: 14),
                        child: Text(
                          "Earn passive income \nby renting  or selling \nyour properties!",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                          padding: const EdgeInsets.only(left: 24.0, top: 15),
                          // padding: EdgeInsets.only(left: 0, top: 14),
                          child: TextButton(
                            onPressed: () {
                              // Your action here
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      50.0), // Adjust the border radius
                                ),
                              ),
                            ),
                            child: Container(
                              height: 20,
                              width: 100.0, // Adjust the width as needed
                              child: Center(
                                child: Text(
                                  'Active as Landlord',
                                  style: TextStyle(
                                    // color: Colors.white,
                                    fontSize: 11.5,
                                    foreground: Paint()
                                      ..shader = const LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Color(0xFF917AFD), // Start color
                                          Color(0xFF6246EA), // End color
                                        ],
                                        stops: [
                                          0.0261,
                                          0.9658
                                        ], // Gradient stops
                                      ).createShader(const Rect.fromLTWH(
                                          0.0, 0.0, 200.0, 70.0)), //
                                  ),
                                ),
                              ),
                            ),
                          )),
                    ),
                  ],
                ),
              ),
              Container(
                color: Colors.white,
                height: 240,
                width: 150,
                // width: ,
                child: Image.asset(
                  "assets/ghor.png",
                  fit: BoxFit.cover,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';

// class BtmBanner extends StatefulWidget {
//   const BtmBanner({super.key});

//   @override
//   State<BtmBanner> createState() => _BtmBannerState();
// }

// class _BtmBannerState extends State<BtmBanner> {
//   @override
//   Widget build(BuildContext context) {
//     return const Text("data");
//   }
// }
