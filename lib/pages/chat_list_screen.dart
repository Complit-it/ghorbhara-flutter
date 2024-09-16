// import 'dart:html';

// import 'dart:convert';

// // import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:hello_world/pages/components/reusables/no_data.dart';
// import 'package:hello_world/services/property_functions.dart';
import 'package:hello_world/services/user_service.dart';

import '../models/chat_user.dart';
import 'components/reusables/chat_user_card.dart';

class ChatList extends StatefulWidget {
  const ChatList({super.key});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  List<ChatUser> list = [];
  String hashedEmail = '';

  // for storing searched items
  final List<ChatUser> _searchList = [];
  // for storing search status
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    API.getSelfInfo();
    getHashedMail();
    fetchChatUsers();
    // print("Initial list: $list");
  }

  Future<void> fetchChatUsers() async {
    // Fetch data and update the list
    API.getChatUsers().listen((data) {
      List<ChatUser> fetchedList =
          data?.map((userMap) => ChatUser.fromJson(userMap)).toList() ?? [];
      if (mounted) {
        setState(() {
          list = fetchedList;
          // Initialize search list with all data          _searchList.addAll(list);
        });
      }
    }).onError((error) {
      // print('Error fetching chat users: $error');
    });
  }

  void _search(String query) {
    if (mounted) {
      setState(() {
        _isSearching = query.isNotEmpty;
        _searchList.clear();
        if (_isSearching) {
          _searchList.addAll(list.where((user) =>
              user.name.toLowerCase().contains(query.toLowerCase()) ||
              user.email.toLowerCase().contains(query.toLowerCase())));
        } else {
          _searchList.addAll(list);
        }
      });
    }
  }

  Future<String> getHashedMail() async {
    final user2 = await getUserFromSharedPreferences();
    // print(user2);
    if (user2 != null && user2.email != null) {
      // final hashedEmail = sha256.convert(utf8.encode(user2.email!)).toString();
      // print(hashedEmail);
    }
    return hashedEmail;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        // crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 21.0, vertical: 32),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius:
                    BorderRadius.circular(33.0), // Set the border radius
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 21.0, vertical: 1),
                child: Row(
                  children: [
                    const Icon(Icons.search),
                    Expanded(
                      child: TextField(
                        onChanged: _search,
                        style: const TextStyle(fontSize: 14.0),
                        cursorColor: Colors.blue.shade300,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.lightBlue.withOpacity(0.0),
                          hintText: 'Search name, email',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // StreamBuilder(
          //     stream:
          //         FirebaseFirestore.instance.collection('users').snapshots(),
          //     builder: (context, snapshot) {
          //       if (snapshot.hasData) {
          //         final data = snapshot.data?.docs;
          //         print('data: $data');
          //       }
          //       return ListView.builder(
          //         shrinkWrap: true,
          //         // physics: BouncingScrollPhysics(),
          //         itemCount: 3,
          //         itemBuilder: (context, index) {
          //           return ChatUserCard();
          //         },
          //       );
          //     })

          Expanded(
            child: StreamBuilder(
              stream: API.getChatUsers(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return const Center(
                      child: CircularProgressIndicator(),
                    );

                  case ConnectionState.active:
                  case ConnectionState.done:
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    final List<Map<String, dynamic>>? data = snapshot.data;
                    List<ChatUser> list = data
                            ?.map((userMap) => ChatUser.fromJson(userMap))
                            .toList() ??
                        [];

                    if (list.isNotEmpty) {
                      return ListView.builder(
                        itemCount:
                            _isSearching ? _searchList.length : list.length,
                        itemBuilder: (context, index) {
                          final user =
                              _isSearching ? _searchList[index] : list[index];
                          // print("Displaying user: $user");
                          return ChatUserCard(user: user);
                        },
                      );
                    } else {
                      return const NoDataWidget(msg: 'No Chats');
                    }
                }
              },
            ),
          )
        ],
      ),
    );
  }
}

// Padding(
//                 padding: EdgeInsets.fromLTRB(21, 0, 21, 18),
//                 child: Row(
//                   children: [
//                     CircleAvatar(
//                       backgroundImage: AssetImage('assets/avt.png'),
//                     ),
//                     SizedBox(
//                       width: 14,
//                     ),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "Bhuban K.C",
//                           style: TextStyle(
//                               fontWeight: FontWeight.w700,
//                               fontFamily: 'Hind',
//                               fontSize: 16),
//                         ),
//                         Text("mssg")
//                       ],
//                     )
//                   ],
//                 ),
//               );
