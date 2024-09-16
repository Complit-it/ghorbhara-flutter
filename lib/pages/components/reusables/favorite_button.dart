// // widgets/favorite_button.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import 'package:hello_world/services/property_cunt.dart';
// import 'package:hello_world/providers/user_provider.dart';
// import 'package:hello_world/services/property_functions.dart';

// class FavoriteButton extends ConsumerWidget {
//   final int propId;

//   FavoriteButton({required this.propId});

//   @override
//   Widget build(BuildContext context, Ref watch) {
//     final userIdAsyncValue = watch(userProvider);

//     return userIdAsyncValue.when(
//       data: (userId) {
//         return IconButton(
//           icon: Icon(Icons.favorite_border),
//           onPressed: () async {
//             try {
//               await add_to_fav(propId, userId);
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text('Property added to favorites successfully')),
//               );
//             } catch (e) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text('Failed to add property to favorites')),
//               );
//             }
//           },
//         );
//       },
//       loading: () => CircularProgressIndicator(),
//       error: (error, stack) => Icon(Icons.error),
//     );
//   }
// }
