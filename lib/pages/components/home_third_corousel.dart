import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../constant.dart';
import '../../models/ad.dart';
import '../ad_screen.dart';

class CorouselThree extends StatefulWidget {
  final List<Ad> ads;
  const CorouselThree({super.key, required this.ads});

  @override
  State<CorouselThree> createState() => _CorouselThreeState();
}

class _CorouselThreeState extends State<CorouselThree> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 21.0, top: 21),
            child: Text(
              "Lizure",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontFamily: 'Hind',
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
        Container(
          height: 290,
          // color: Colors.amber,
          child: ListView.builder(
            itemCount: widget.ads.length,
            itemBuilder: (context, index) {
              Ad ad = widget.ads[index];
              // final imageUrl = baseUrl + ad.image!.imagePath!;
              final imageUrl = ad.image != null && ad.image!.imagePath != null
                  ? baseUrl + ad.image!.imagePath!
                  : null; // Set imageUrl to null if either is null
              return widget.ads.isEmpty
                  ? const SizedBox(
                      height: 28,
                    )
                  : GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AdScreen(ad: ad)),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 21, top: 21, right: 44, bottom: 4),
                        child: Container(
                          height: 200,
                          width: 200,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(children: [
                            Container(
                              height: 200,
                              width: 200,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(7),
                                  bottomLeft: Radius.circular(7),
                                ),
                                child: imageUrl != null
                                    ? CachedNetworkImage(
                                        imageUrl: imageUrl,
                                        placeholder: (context, url) =>
                                            const Center(
                                                child:
                                                    CircularProgressIndicator()),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                        fit: BoxFit.fill,
                                      )
                                    : const Icon(
                                        Icons.image_not_supported,
                                        size: 50,
                                        color: Colors.grey,
                                      ), // Show a placeholder icon if imageUrl is null
                              ),
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 16),
                                child: Text(
                                  ad.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontFamily: 'Hind',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 0),
                                child: ad.subDesc != null
                                    ? Text(
                                        ad.subDesc!,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[400],
                                        ),
                                      )
                                    : const SizedBox(
                                        height:
                                            20, // Set the height you want for the SizedBox
                                      ),
                              ),
                            ),
                          ]),
                        ),
                      ),
                    );
            },
            scrollDirection: Axis.horizontal,

            // itemExtent: 300,
          ),
        )
      ],
    );
  }
}

// import 'package:flutter/material.dart';

// class CorouselThree extends StatefulWidget {
//   const CorouselThree({super.key});

//   @override
//   State<CorouselThree> createState() => _CorouselThreeState();
// }

// class _CorouselThreeState extends State<CorouselThree> {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(0),
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(top: 21.0, left: 21, right: 21),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   "Top rated",
//                   style: TextStyle(
//                     color: Colors.black,
//                     fontSize: 14,
//                     fontFamily: 'Hind',
//                     fontWeight: FontWeight.w800,
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     debugPrint('Container tapped!');
//                   },
//                   child: const Text(
//                     "See all",
//                     style: TextStyle(
//                       color: Color(0xFF7879F1),
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//           Container(
//             height: 210, //200
//             // width: 100,
//             // color: Colors.blue,

//             // width: 200,
//             child: ListView.builder(
//               itemBuilder: (context, index) {
//                 return Padding(
//                   padding: const EdgeInsets.all(21.0),
//                   child: Container(
//                     height: 200,
//                     width: 260,
//                     // width: MediaQuery.of(context).size.width - 222,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(7),
//                       // color: Colors.pink, // Adjust the radius as needed
//                       color: Colors.grey[300],
//                     ),

//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Container(
//                           height: 210, //200
//                           width: 100, //90

//                           child: Image.asset(
//                             'assets/Frame.png',
//                             fit: BoxFit.fill,
//                             // height: 245.0,
//                           ),
//                         ),
//                         // const SizedBox(width: 15),
//                         Container(
//                             height: 210, //200
//                             width: 160, //150
//                             // width: MediaQuery.of(context).size.width - 42 - 90,
//                             //
//                             // decoration: const BoxDecoration(
//                             //   borderRadius: BorderRadius.only(
//                             //     topRight: Radius.circular(10),
//                             //     bottomRight: Radius.circular(10),
//                             //   ),
//                             //   // color: Colors.purple,

//                             //   // color: Colors.pink, // Adjust the radius as needed
//                             // ),
//                             // Adjust the radius as needed

//                             child: Padding(
//                               padding: const EdgeInsets.only(left: 15),
//                               child: Column(
//                                 children: [
//                                   const Row(
//                                     children: [
//                                       Icon(
//                                         Icons.star,
//                                         color: Colors.yellow,
//                                         size: 18,
//                                       ),
//                                       SizedBox(width: 3),
//                                       Text(
//                                         '4.8 (73)',
//                                         style: TextStyle(fontSize: 12),
//                                       ),
//                                     ],
//                                   ),
//                                   const Padding(
//                                     padding: EdgeInsets.only(top: 6.0),
//                                     child: Text(
//                                       'Small cottege with great view of bagmati',
//                                       maxLines: 2,
//                                       overflow: TextOverflow.ellipsis,
//                                       style: TextStyle(
//                                         fontSize: 12,
//                                       ),
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.only(top: 4.0),
//                                     child: Text(
//                                       'Kadaghari, Kathmandu',
//                                       maxLines: 1,
//                                       overflow: TextOverflow.ellipsis,
//                                       style: TextStyle(
//                                           fontSize: 14,
//                                           color: Colors.grey[400]),
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.only(top: 6),
//                                     child: Row(
//                                       children: [
//                                         Icon(
//                                           Icons.bed_rounded,
//                                           color: Colors.grey[400],
//                                           size: 20,
//                                         ),
//                                         const SizedBox(
//                                           width: 5,
//                                         ),
//                                         Text(
//                                           "2 room",
//                                           style: TextStyle(
//                                             color: Colors.grey[400],
//                                             fontSize: 12,
//                                           ),
//                                         ),
//                                         const SizedBox(
//                                           width: 10,
//                                         ),
//                                         Icon(
//                                           Icons.house_rounded,
//                                           color: Colors.grey[400],
//                                           size: 20,
//                                         ),
//                                         const SizedBox(
//                                           width: 5,
//                                         ),
//                                         Text(
//                                           "673 m2",
//                                           style: TextStyle(
//                                             color: Colors.grey[400],
//                                             fontSize: 12,
//                                           ),
//                                         )
//                                       ],
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding: EdgeInsets.only(top: 16),
//                                     child: Row(
//                                         // mainAxisAlignment:
//                                         //     MainAxisAlignment.spaceAround,
//                                         children: [
//                                           RichText(
//                                             text: TextSpan(
//                                               style:
//                                                   DefaultTextStyle.of(context)
//                                                       .style,
//                                               children: <TextSpan>[
//                                                 const TextSpan(
//                                                   text: '\$526',
//                                                   style: TextStyle(
//                                                     fontSize: 14,
//                                                     fontWeight: FontWeight.bold,
//                                                     color: Colors.black,
//                                                   ),
//                                                 ),
//                                                 TextSpan(
//                                                   text: ' /month',
//                                                   style: TextStyle(
//                                                     color: Colors.grey[400],
//                                                     fontSize: 12,
//                                                     fontWeight:
//                                                         FontWeight.normal,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                           const SizedBox(
//                                             width: 40,
//                                           ),
//                                           GestureDetector(
//                                             onTap: () {
//                                               debugPrint('Added to Wishlist');
//                                             },
//                                             child: const Icon(
//                                               Icons.favorite_border,
//                                               color: Color.fromARGB(
//                                                   255, 166, 164, 164),
//                                               size: 18,
//                                             ),
//                                           )
//                                         ]),
//                                   )
//                                 ],
//                               ),
//                             ))
//                       ],
//                     ),
//                   ),
//                 );
//               },
//               scrollDirection: Axis.horizontal,
//               itemCount: 1,
//               // itemExtent: 340,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
