import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatly/api/apis.dart';
import 'package:chatly/helper/my_date_util.dart';
import 'package:chatly/models/chatuser.dart';
import 'package:chatly/models/message.dart';
import 'package:flutter/material.dart';
import 'package:chatly/screens/chatscreen.dart';
import '../main.dart';

class chatusercard extends StatefulWidget {
  final chatuser user;
  const chatusercard({super.key, required this.user});

  @override
  State<chatusercard> createState() => _chatusercardState();
}

class _chatusercardState extends State<chatusercard> {

  Message? _message;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen(user: widget.user)));
        },
        child: StreamBuilder(
          stream: APIs.getLastMessages(widget.user),
          builder: (context,snapshot) {

            final data = snapshot.data?.docs;
            final list =
                data?.map((e) => Message.fromJson(e.data())).toList() ??
                    [];
           if(list.isNotEmpty) _message = list[0];

          return  ListTile(
            // leading: const CircleAvatar(child: Icon(Icons.person_2_outlined)),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(mq.height * 0.3),
              child: CachedNetworkImage(
                width: mq.height * 0.055,
                height: mq.height * 0.055,
                imageUrl: widget.user.image,
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => CircleAvatar(child: Icon(Icons.person_2_outlined)),
              ),
            ),
            title: Text(widget.user.name),
            subtitle: Text(_message != null? _message!.msg : widget.user.about ,maxLines: 1),
            // trailing: const Text(
            //     '12:00 PM'),
            trailing: _message == null ? null :
            _message!.read.isEmpty && _message!.fromId != APIs.user.uid
                ?

            Container(
              width: 15,
              height: 15,
              decoration: BoxDecoration(
                  color: Colors.greenAccent.shade400,
                  borderRadius: BorderRadius.circular(10)),
            )
            :Text(MyDateUtil.getLastMessageTime(context: context, time: _message!.sent),
            style: TextStyle(color: Colors.black),),
          );
        },)
      ),
    );
  }
}