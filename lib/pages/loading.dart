import 'package:flutter/material.dart';
import 'package:hello_world/constant.dart';
import 'package:hello_world/models/api_response.dart';
import 'package:hello_world/pages/home.dart';
import 'package:hello_world/pages/welcome_pg.dart';
import 'package:hello_world/services/user_service.dart';
import 'package:http/http.dart';

class Loading extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _LoadingState createState() {
    return _LoadingState();
  }
}

class _LoadingState extends State<Loading> {
  void _loadUserInfo() async {
    String token = await getToken();
    if (token == '') {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => WelcomePg()),
          (route) => false);
    } else {
      ApiResponse response = await getUserDetail();
      if (response.error == null) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => Home()), (route) => false);
      } else if (response.error == unauthorized) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => WelcomePg()),
            (route) => false);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('${response.error}')));
      }
    }
  }

  @override
  void initState() {
    _loadUserInfo();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: Colors.white,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
