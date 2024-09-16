// import 'dart:convert';
// import 'dart:io';
// import 'dart:math';

// import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hello_world/models/chat_user.dart';
import 'package:hello_world/pages/components/reusables/message_card.dart';
import 'package:hello_world/services/user_service.dart';

import '../models/message.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;
  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Message> list = [];
  final _textController = TextEditingController();
  late Future<Stream<QuerySnapshot<Map<String, dynamic>>>> _messagesStream;
  bool _showemoji = false;
  // bool _canPop = true;
  @override
  void initState() {
    super.initState();
    _messagesStream = API.getAllMessages(widget.user);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white, // set status bar color to white
      statusBarIconBrightness:
          Brightness.dark, // set status bar icon color to dark
    ));
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: PopScope(
          onPopInvoked: (bool) {
            if (_showemoji) {
              setState(() {
                _showemoji = !_showemoji;
                // return;
              });
            }
          },
          child: Scaffold(
            appBar: AppBar(
              // elevation: 1,
              automaticallyImplyLeading: false,
              flexibleSpace: _appBar(),
            ),
            backgroundColor: Color.fromARGB(255, 223, 223, 255),
            body: Column(
              children: [
                Expanded(
                  child: FutureBuilder<
                          Stream<QuerySnapshot<Map<String, dynamic>>>>(
                      future: _messagesStream,
                      //     // FirebaseFirestore.instance.collection('users').snapshots(),
                      //     API.getAllusers(),
                      //-----------------------------------------
                      // builder: (context, snapshot) {
                      //   switch (snapshot.connectionState) {
                      //     case ConnectionState.waiting:
                      //     case ConnectionState.none:
                      //       return const Center(
                      //         child: CircularProgressIndicator(),
                      //       );

                      //     case ConnectionState.active:
                      //     case ConnectionState.done:
                      //     final messagesStream = snapshot.data!;
                      //       final data = snapshot.data?.docs;
                      //       // print('data: ${jsonEncode(data![0].data())}');
                      //       list = data
                      //               ?.map((e) => Message.fromJson(e.data()))
                      //               .toList() ??
                      //           [];
                      //       // final list = [];
                      //       // print(list);
                      //       if (list.isNotEmpty) {
                      //         return ListView.builder(
                      //           shrinkWrap: true,
                      //           // physics: BouncingScrollPhysics(),
                      //           itemCount: list.length,
                      //           itemBuilder: (context, index) {
                      //             return MessageCard(
                      //               message: list[index],
                      //             );
                      //           },
                      //         );
                      //       } else {
                      //         return Center(child: Text('Say Hi! 👋🏻'));
                      //       }

                      //     // break;
                      //     // default:
                      //   }

                      //   //  else if (snapshot.hasError) {
                      //   //   return Text('Error: ${snapshot.error}');
                      //   // } else {
                      //   //   return CircularProgressIndicator();
                      //   // }
                      // },
                      //--------------------
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
                              return Center(
                                child: Text('Error: ${snapshot.error}'),
                              );
                            }

                            if (!snapshot.hasData) {
                              return const Center(
                                child: Text('No messages found'),
                              );
                            }

                            final messagesStream = snapshot.data!;

                            return StreamBuilder<
                                QuerySnapshot<Map<String, dynamic>>>(
                              stream: messagesStream,
                              builder: (context, streamSnapshot) {
                                switch (streamSnapshot.connectionState) {
                                  case ConnectionState.waiting:
                                  case ConnectionState.none:
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );

                                  case ConnectionState.active:
                                  case ConnectionState.done:
                                    if (streamSnapshot.hasError) {
                                      return Center(
                                        child: Text(
                                            'Error: ${streamSnapshot.error}'),
                                      );
                                    }

                                    if (!streamSnapshot.hasData ||
                                        streamSnapshot.data!.docs.isEmpty) {
                                      return const Center(
                                        child: Text('Say Hi! 👋🏻'),
                                      );
                                    }

                                    final messages = streamSnapshot.data!.docs
                                        .map((e) => Message.fromJson(e.data()))
                                        .toList();

                                    return ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: messages.length,
                                      itemBuilder: (context, index) {
                                        return MessageCard(
                                          message: messages[index],
                                        );
                                      },
                                    );
                                }
                              },
                            );
                        }
                      }),
                ),
                _chatInput(),
                if (_showemoji)
                  SizedBox(
                    height: 240,
                    child: EmojiPicker(
                      textEditingController: _textController,
                      config: const Config(
                          categoryViewConfig: CategoryViewConfig(),
                          emojiViewConfig: EmojiViewConfig(columns: 8),
                          bottomActionBarConfig:
                              BottomActionBarConfig(enabled: false)),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _appBar() {
    return InkWell(
      onTap: () {
        // print(widget.user);
      },
      child: Row(
        children: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black54,
              )),
          ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: const Icon(Icons.person_rounded,
                  size: 32, color: Color.fromARGB(255, 69, 69, 239))
              // CachedNetworkImage(
              //   width: 39,
              //   height: 39,
              //   imageUrl: widget.user.image,
              //   fit: BoxFit.cover,
              //   errorWidget: (context, url, error) =>
              //       const CircleAvatar(child: Icon(CupertinoIcons.person)),
              // ),
              ),
          const SizedBox(
            width: 10,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.user.name,
                style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Hind'),
              ),
              // SizedBox(
              //   height: -2,
              // ),
              // const Text(
              //   'Last seen not available',
              //   style: TextStyle(
              //       fontSize: 13, color: Colors.black54, fontFamily: 'Hind'),
              // ),
            ],
          )
        ],
      ),
    );
  }

  Widget _chatInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        setState(() {
                          FocusScope.of(context).unfocus();
                          _showemoji = !_showemoji;
                        });
                      },
                      icon: const Icon(
                        Icons.emoji_emotions,
                        color: Color.fromARGB(255, 69, 69, 239),
                      )),
                  Expanded(
                      child: TextField(
                    controller: _textController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    onTap: () {
                      if (_showemoji) {
                        if (mounted) {
                          setState(() {
                            _showemoji = !_showemoji;
                          });
                        }
                      }
                    },
                    decoration: const InputDecoration(
                      hintText: 'Type Something...',
                      hintStyle:
                          TextStyle(color: Color.fromARGB(255, 69, 69, 239)),
                      border: InputBorder.none,
                    ),
                  )),
                  // IconButton(
                  //     onPressed: () {},
                  //     icon: Icon(
                  //       Icons.image,
                  //       color: Colors.blueAccent,
                  //     )),
                  // IconButton(
                  //     onPressed: () {
                  //       // API.printUserDetails();
                  //     },
                  //     icon: Icon(
                  //       Icons.camera_alt_rounded,
                  //       color: Colors.blueAccent,
                  //     )),
                ],
              ),
            ),
          ),
          MaterialButton(
            onPressed: () {
              if (_textController.text.isNotEmpty) {
                // print(widget.user);
                API.sendMessage(widget.user, _textController.text);
                _textController.clear();
              }
            },
            minWidth: 0,
            padding:
                const EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 10),
            color: Colors.green,
            shape: const CircleBorder(),
            child: const Icon(Icons.send),
          )
        ],
      ),
    );
  }
}
