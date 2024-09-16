import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:hello_world/constant.dart';
// import 'package:hello_world/models/api_response.dart';
// import 'package:hello_world/models/user.dart';
// import 'package:hello_world/pages/chat_list_screen.dart';
// import 'package:hello_world/pages/home_main.dart';
// import 'package:hello_world/pages/loading.dart';
// import 'package:hello_world/pages/new_property.dart';
// // import 'package:hello_world/pages/signup_otp.dart';
// import 'package:hello_world/pages/signupp.dart';
// import 'package:hello_world/pages/test.dart';
// import 'pages/sign_in.dart';
// import 'pages/signupp.dart';
import 'pages/splash_screen.dart';
// import 'pages/welcome_pg.dart';
// import 'pages/signup_form.dart';
// import 'pages/home.dart';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';

// ...

//

// late Size mq;
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  _initializeFireb();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
  ));
  // await Firebase.initializeApp();
  runApp(const MyApp());
  // runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // theme: ThemeData(fontFamily: 'Hind'),

      // home: HomeMain(),
      // home: Location(),
      // home: WelcomePg(),
      home: SplashScreenWithCheck(),

      // home: ChatList(),
    );
  }
}

void _initializeFireb() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

//---------------------------------------------------------------------------------------------------------------------------------------

//----------------------------------------------------------------------------------------------
// import 'package:flutter/material.dart';
// import 'package:another_carousel_pro/another_carousel_pro.dart';

// void main() {
//   runApp(MaterialApp(
//     debugShowCheckedModeBanner: false,
//     title: 'Carousel Pro',
//     home: CarouselPage(),
//   ));
// }

// class CarouselPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: SizedBox(
//           height: 150.0,
//           width: 300.0,
//           child: AnotherCarousel(
//             boxFit: BoxFit.cover,
//             autoplay: false,
//             // animationCurve: Curves.fastOutSlowIn,
//             // animationDuration: Duration(milliseconds: 1000),
//             dotSize: 6.0,
//             // dotIncreasedColor: Color(0xFFFF335C),
//             dotBgColor: Colors.transparent,
//             dotPosition: DotPosition.bottomCenter,
//             dotVerticalPadding: 10.0,
//             showIndicator: false,
//             indicatorBgPadding: 7.0,
//             images: [
//               NetworkImage(
//                   'https://i.pinimg.com/originals/a2/4e/29/a24e29fc5ee1ef69ab11777f1d28641a.jpg'),
//               NetworkImage(
//                   'https://i.pinimg.com/originals/93/a0/ae/93a0aeb22c7e27da4796efb4b2297ea4.jpg'),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
