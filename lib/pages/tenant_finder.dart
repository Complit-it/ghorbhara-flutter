// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
// import 'package:hello_world/pages/test_pg.dart';

class FindTenant extends StatefulWidget {
  const FindTenant({super.key});

  @override
  State<FindTenant> createState() => _FindTenantState();
}

class _FindTenantState extends State<FindTenant> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70),
          child: Container(
            padding: EdgeInsets.only(top: 10, right: 1.5, left: 1.5),
            child: AppBar(
              surfaceTintColor: Colors.transparent,
              leading: BackButton(),
              actions: [
                IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () {
                    // Add your onPressed logic here
                  },
                ),
              ],
            ),
          ),
        ),
        body: SafeArea(
            child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left: 21, right: 21),
            child: Container(
                // width: 100,
                // height: 300,
                // color: Colors.amber[50],
                child: Column(children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Tenant Finder",
                  style: TextStyle(
                    fontFamily: 'Hind',
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                    height: 1,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Find perfect tanent for your property!",
                  style: TextStyle(
                    fontFamily: 'Hind',
                    fontSize: 16,
                    color: Colors.grey[400],
                    // fontWeight: FontWeight.w700,
                    // height: 1.0,
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),

                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 28.0, bottom: 0),
                      child: Container(

                          // height: 50,
                          // width: 250,
                          decoration: BoxDecoration(
                            color: Colors.blue[100],
                            borderRadius: BorderRadius.circular(
                                10.0), // Adjust the border radius
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  // height: 50,
                                  // width: 0,
                                  // color: Colors.pink[50],
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                        // mainAxisAlignment:
                                        // MainAxisAlignment.center,

                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              CircleAvatar(
                                                backgroundImage: AssetImage(
                                                    'assets/avt.png'),
                                              ),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              Text(
                                                "Lal Bahadur",
                                                style: TextStyle(
                                                    fontFamily: 'Hind',
                                                    fontWeight:
                                                        FontWeight.w600),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.02, // Responsive gap (20% of the screen height)
                                          ),
                                          RichText(
                                            text: TextSpan(
                                              style:
                                                  DefaultTextStyle.of(context)
                                                      .style,
                                              children: <TextSpan>[
                                                TextSpan(
                                                  text: 'Looking for apartment',
                                                  style: TextStyle(
                                                    fontSize: 12.0,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: '\nin Balwatar',
                                                  style: TextStyle(
                                                    fontSize: 18.0,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ]),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 12.0, right: 12, left: 8, bottom: 8),
                                  child: Container(
                                    // height: 70,
                                    // color: Colors.green[50],
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            "14min",
                                            style: TextStyle(
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey[400],
                                            ),
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.055, // Responsive gap (20% of the screen height)
                                          ),
                                          ElevatedButton(
                                              onPressed: () {},
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Color(0xFF315EE7),
                                                minimumSize: Size(100, 30),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0), // Adjust the border radius
                                                ),
                                              ),
                                              child: Text(
                                                "View",
                                                style: TextStyle(
                                                  // fontSize: 12.0,
                                                  // fontWeight: FontWeight.w500,
                                                  color: Colors.white,
                                                ),
                                              ))
                                        ]),
                                  ),
                                ),
                              )
                            ],
                          )),
                    );
                  },
                  itemCount: 6,
                  // itemExtent: 300,
                ),
              )
            ])),
          ),
        )));
  }
}
