import 'package:flutter/material.dart';
// import 'package:hello_world/pages/property_main.dart';

class CorouselTwo extends StatefulWidget {
  const CorouselTwo({super.key});

  @override
  State<CorouselTwo> createState() => _CorouselTwoState();
}

class _CorouselTwoState extends State<CorouselTwo> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Column(
        children: [
          // const Padding(
          //   padding: EdgeInsets.only(top: 21.0, left: 21),
          //   child: Align(
          //     alignment: Alignment.centerLeft,
          // child: Text(
          //   "Near your location",
          //   style: TextStyle(
          //     color: Colors.black,
          //     fontSize: 14,
          //     fontFamily: 'Hind',
          //     fontWeight: FontWeight.w800,
          //   ),
          // ),
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.only(top: 21, left: 21, right: 21),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Top rated",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: 'Hind',
                    fontWeight: FontWeight.w800,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    debugPrint('Container tapped!');
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
            height: 250, //200
            // width: 100,
            // color: Colors.blue,

            // width: 200,

            child: GestureDetector(
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => PropertyMainScreen()),
                // );
              },
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(21.0),
                    //------------whole card container-----------
                    child: Container(
                      height: 250,
                      width: 290,

                      // width: MediaQuery.of(context).size.width - 222,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        // color: Colors.pink,
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
                            height: 230, //200
                            width: 100, //90

                            child: Image.asset(
                              'assets/Frame.png',
                              fit: BoxFit.fill,
                              // height: 245.0,
                            ),
                          ),
                          // const SizedBox(width: 15),

                          //----------container for inner contents of the card-----------
                          Container(
                              height: 200, //200
                              width: 190, //150
                              // color: Colors.purple,
                              //  // width: MediaQuery.of(context).size.width - 42 - 90,
                              //
                              // decoration: const BoxDecoration(
                              //   borderRadius: BorderRadius.only(
                              //     topRight: Radius.circular(10),
                              //     bottomRight: Radius.circular(10),
                              //   ),
                              //

                              //   // color: Colors.pink, // Adjust the radius as needed
                              // ),
                              // Adjust the radius as needed

                              child: Padding(
                                //_________padding for inner contents of the card________
                                padding:
                                    const EdgeInsets.only(left: 15, top: 21),
                                child: Column(
                                  children: [
                                    const Row(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: Colors.yellow,
                                          size: 18,
                                        ),
                                        SizedBox(width: 3),
                                        Text(
                                          '4.8 (73)',
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        'Small cottege with great view of bagmati',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 14, fontFamily: 'Hind'),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 6.0),
                                        child: Text(
                                          'Kadaghari, Kathmandu',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[400]),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.bed_rounded,
                                            color: Colors.grey[400],
                                            size: 20,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            "2 room",
                                            style: TextStyle(
                                              color: Colors.grey[400],
                                              fontSize: 12,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Icon(
                                            Icons.house_rounded,
                                            color: Colors.grey[400],
                                            size: 20,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            "673 m2",
                                            style: TextStyle(
                                              color: Colors.grey[400],
                                              fontSize: 12,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 21),
                                      child: Row(
                                          // mainAxisAlignment:
                                          //     MainAxisAlignment.spaceAround,
                                          children: [
                                            RichText(
                                              text: TextSpan(
                                                style:
                                                    DefaultTextStyle.of(context)
                                                        .style,
                                                children: <TextSpan>[
                                                  const TextSpan(
                                                    text: '\$526',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                            const SizedBox(
                                              width: 40,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                debugPrint('Added to Wishlist');
                                              },
                                              child: const Icon(
                                                Icons.favorite_border,
                                                color: Color.fromARGB(
                                                    255, 166, 164, 164),
                                                size: 18,
                                              ),
                                            )
                                          ]),
                                    )
                                  ],
                                ),
                              ))
                        ],
                      ),
                    ),
                  );
                },
                scrollDirection: Axis.horizontal,
                itemCount: 3,
                // itemExtent: 340,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
