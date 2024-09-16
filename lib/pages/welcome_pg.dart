import 'package:flutter/material.dart';
import 'sign_in.dart';

class WelcomePg extends StatelessWidget {
  const WelcomePg({super.key});

  void _navigateToSignIn(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignIn()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Center(
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 90),
          Image.asset(
            'assets/welcome_.png', // Replace with your image asset path
            height: 210, // Adjust the height as needed
          ),
          const SizedBox(height: 50),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 21),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Welcome to ',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.italic,
                          height: -0.5,
                          color: Color(0xFF22215B)),
                    ),
                    const Text(
                      // crossAxisAlignment: CrossAxisAlignment.start
                      'Ghorbhara',
                      style: TextStyle(
                          fontSize: 46,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF22215B)),
                    ),
                    const Text(
                      'Find the tenant, list your property in just a simple steps, in your hand.',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                        color: Color(0xFF22215B),
                      ),
                    ),
                    const SizedBox(height: 25),
                    const Text(
                      'You are one step away.',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                          color: Color(0xFF22215B)),
                    ),
                    const SizedBox(height: 50),
                    ElevatedButton(
                      onPressed: () {
                        // Add your "Get Started" button logic here
                        _navigateToSignIn(context);
                        // print("Button pressed!");
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.blue),
                        minimumSize: MaterialStateProperty.all<Size>(
                            const Size(double.infinity, 48)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(8.0), // Customize
                          ),
                        ),
                      ),
                      child: const Text(
                        'Get Started',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFFFFFFFF)),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    )));
  }
}
