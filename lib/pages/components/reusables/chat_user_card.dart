// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:fluttermoji/fluttermojiCircleAvatar.dart';
// import 'package:get/get.dart';
// import 'package:hello_world/main.dart';
import 'package:hello_world/models/chat_user.dart';

import '../../chat_screen.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser user;

  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 04),
      child: InkWell(
          onTap: () {
            //for navigating to chatScreen
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ChatScreen(user: widget.user)));
          },
          child: ListTile(
            leading: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Icon(
                  Icons.person_rounded,
                  size: 34,
                  color: Color.fromARGB(255, 69, 69, 239),
                )
                // CachedNetworkImage(
                //   width: 40,
                //   height: 40,
                //   imageUrl: widget.user.image,
                //   fit: BoxFit.cover,
                //   errorWidget: (context, url, error) =>
                //       const CircleAvatar(child: Icon(CupertinoIcons.person)),
                // ),
                ),
            title: Text(widget.user.name),
            subtitle: const Text(
              'Hey, I\'m using Ghorbhara',
              maxLines: 1,
            ),
            // trailing: Text('12:00 PM'),
          )),
    );
  }
}
