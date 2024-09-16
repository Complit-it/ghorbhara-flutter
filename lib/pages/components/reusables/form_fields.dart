import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool? np;
  final bool? obscureFlag;
  final TextInputType keyboardType;

  const CustomInputField({
    Key? key,
    required this.labelText,
    required this.controller,
    this.obscureFlag,
    this.validator,
    this.np, //called by new porperty screen
    this.keyboardType = TextInputType.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: np != null
          ? const EdgeInsets.all(0)
          : const EdgeInsets.only(right: 22.0, left: 22.0, top: 0),
      // padding: const EdgeInsets.only(left: 0),
      child: TextFormField(
        obscureText: obscureFlag ?? false,
        controller: controller,
        cursorColor: Colors.blue.shade300,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
          label: Text(
            labelText,
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 14,
              fontFamily: 'Hind',
              // fontWeight: FontWeight.w400,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue.shade300),
          ),
          border: InputBorder.none,
          filled: true,
          fillColor: const Color.fromARGB(102, 235, 236, 236),
        ),
        validator: validator,
        keyboardType: keyboardType,
      ),
    );
  }
}
