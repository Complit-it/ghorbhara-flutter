// import 'dart:html';

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:hello_world/models/property.dart';
import '../constant.dart';
import '../helper/dialogs.dart';
import '../models/api_response.dart';
import '../models/user.dart';
import '../services/property_functions.dart';
import '../services/user_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  User? _user;
  // bool _isloggingOut = false;
  bool isLoading = true;
  XFile? _pickedImage;
  TextEditingController _phone =
      TextEditingController(); // Declare without initialization
  TextEditingController _name = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    User? user = await getUserFromSharedPreferences();
    setState(() {
      _user = user;
      isLoading = false;
      // print(_user);

      _phone = TextEditingController(text: _user?.phone ?? '');
      _name = TextEditingController(text: _user?.name ?? '');
      // print(_user);
    });
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _pickedImage = image;
      });
      // await _uploadImage(image);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  const CustomAppBar(),
                  Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CircleAvatar(
                          radius: 50,
                          child: _pickedImage != null
                              ? ClipOval(
                                  child: Image.file(
                                    File(_pickedImage!.path),
                                    fit: BoxFit.cover,
                                    width: 100,
                                    height: 100,
                                  ),
                                )
                              : (_user?.imageUrl != null &&
                                      _user!.imageUrl!.isNotEmpty)
                                  ? ClipOval(
                                      child: CachedNetworkImage(
                                        imageUrl: '$baseUrl${_user!.imageUrl!}',
                                        fit: BoxFit.cover,
                                        width: 100,
                                        height: 100,
                                        errorWidget: (context, url, error) =>
                                            const Icon(
                                          Icons.person_rounded,
                                          size: 48,
                                          color: Color.fromARGB(
                                              255, 116, 116, 117),
                                        ),
                                      ),
                                    )
                                  : const Icon(
                                      Icons.person_rounded,
                                      size: 48,
                                      color: Color.fromARGB(255, 116, 116, 117),
                                    ),
                        ),
                      ),
                    ),
                  ),
                  TextButton(onPressed: _pickImage, child: const Text('Edit')),
                  const SizedBox(
                    height: 14,
                  ),
                  Text(
                    _user!.email!,
                    style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontFamily: 'Hind',
                        fontSize: 16,
                        color: Colors.grey),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .07,
                  ),
                  kTextfld(
                    label: 'Name',
                    controller: _name,
                    prefixIcon: Icons.person,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .03,
                  ),
                  kTextfld(
                    label: 'Phone',
                    controller: _phone,
                    prefixIcon: Icons.call,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .07,
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                    ),
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });

                      ApiResponse response = await updateUserProfile(
                        _name.text,
                        _phone.text,
                        // _user!.email!,
                        _pickedImage != null ? File(_pickedImage!.path) : null,
                        _user!.id!,
                      );

                      setState(() {
                        isLoading = false;
                      });

                      if (response.error == null) {
                        if (mounted) {
                          // ScaffoldMessenger.of(context).showSnackBar(
                          //   const SnackBar(
                          //       content: Text('Profile updated successfully!')),
                          // );
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          await prefs.setString('phone', _phone.text);
                          Dialogs.showSnackbar(
                              context, 'Profile updated successfully.',
                              backgroundColor: Colors.green);
                        }
                      } else {
                        if (mounted) {
                          Dialogs.showSnackbar(
                              context, 'Oops, something went wrong!',
                              backgroundColor: Colors.green);
                        }
                      }
                    },
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Update',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 16),
      color: Theme.of(context).primaryColor,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 25,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 8),
          const Text(
            'My Profile',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ],
      ),
    );
  }
}

// class kTextfld extends StatelessWidget {
//   final String? initialValue;
//   final IconData? prefixIcon;
//   final String label;
//   final TextInputType keyboardType;
//   final TextEditingController? controller;

//   kTextfld({
//     this.initialValue,
//     this.prefixIcon,
//     required this.label,
//     this.keyboardType = TextInputType.text,
//     this.controller,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(
//         horizontal: MediaQuery.of(context).size.width * 0.06,
//       ),
//       child: TextFormField(
//         initialValue: initialValue,
//         controller: controller,
//         keyboardType: keyboardType,
//         decoration: InputDecoration(
//             prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//             // labelText: label,
//             label: Text(label)),
//       ),
//     );
//   }
// }

class kTextfld extends StatelessWidget {
  final IconData? prefixIcon;
  final String label;
  final TextInputType keyboardType;
  final TextEditingController? controller;

  kTextfld({
    this.prefixIcon,
    required this.label,
    this.keyboardType = TextInputType.text,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.06,
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          label: Text(label),
        ),
      ),
    );
  }
}
