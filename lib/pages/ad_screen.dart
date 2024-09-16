import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:hello_world/constant.dart';
import 'package:hello_world/helper/dialogs.dart';
import 'package:hello_world/services/property_functions.dart';
import '../models/ad.dart';
import '../services/user_service.dart';

class AdScreen extends StatefulWidget {
  final Ad ad;
  const AdScreen({super.key, required this.ad});

  @override
  State<AdScreen> createState() => _AdScreenState();
}

class _AdScreenState extends State<AdScreen> {
  bool _isLoading = true;
  Ad? ad;
  int? userId;

  @override
  void initState() {
    super.initState();
    fetchdata();
  }

  Future<void> fetchdata() async {
    final apiResponse = await getAdd(widget.ad.id);
    if (apiResponse.error == null) {
      if (mounted) {
        setState(() {
          ad = apiResponse.data as Ad;
          _isLoading = false;
        });
      }
    }
  }

  Future<void> saveInquiry() async {
    userId = await getUserId();
    final apiResponse = await saveInq(userId!, ad!.id);

    if (apiResponse.error == null) {
      Dialogs.showSnackbar(context, 'You will be contacted soon.',
          backgroundColor: Colors.green);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 250,
                              child: AnotherCarousel(
                                boxFit: BoxFit.contain,
                                autoplay: false,
                                dotSize: 6.0,
                                dotBgColor: Colors.transparent,
                                dotPosition: DotPosition.bottomCenter,
                                dotVerticalPadding: 10.0,
                                showIndicator: false,
                                indicatorBgPadding: 7.0,
                                images: ad?.allImages?.map((image) {
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
                        Padding(
                          padding: EdgeInsets.only(
                              left: 21, right: 21, top: 33, bottom: 14),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    ad!.title,
                                    style: TextStyle(
                                      fontFamily: 'Hind',
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      height: 1.3,
                                    ),
                                  ),
                                ),
                              ]),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 21, right: 21, top: 1, bottom: 14),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    ad!.desc!,
                                    style: TextStyle(
                                      fontFamily: 'Hind',
                                      fontSize: 16,
                                      height: 1.3,
                                    ),
                                  ),
                                ),
                              ]),
                        ),
                        // Spacer to push the button to the bottom of the screen
                        SizedBox(height: 80),
                      ],
                    ),
                  ),
            Positioned(
              bottom: 0,
              left: 16,
              right: 16,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 6, right: 6, top: 22, bottom: 20),
                child: GestureDetector(
                  onTap: () {
                    // Add your button tap logic here
                    print("Book Now button tapped!");
                    saveInquiry();
                  },
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color(0xFF6246EA),
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Send Inquiry",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Hind',
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
