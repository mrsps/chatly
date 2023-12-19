import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatly/widgets/message_card.dart';
import 'package:flutter/material.dart';
import 'package:chatly/models/chatuser.dart';
import 'package:flutter/services.dart';
import 'package:chatly/models/message.dart';

import '../api/apis.dart';
import '../main.dart';
import '../widgets/chatusercard.dart';

class ChatScreen extends StatefulWidget {
  final chatuser user;
  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
   List<Message> _list = [];

   final _textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: _appBar(),
        ),
        backgroundColor: Colors.deepPurple.shade100,
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: APIs.getAllMessages(widget.user),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                     return const SizedBox();
                    case ConnectionState.active:
                    case ConnectionState.done:
                      final data = snapshot.data?.docs;
                      _list =
                          data?.map((e) => Message.fromJson(e.data())).toList() ??
                              [];

                      if (_list.isNotEmpty) {
                        return ListView.builder(
                            itemCount:
                            _list.length,
                            padding: EdgeInsets.only(top: mq.height * .008),
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                               return MessageCard(message: _list[index]);
                            });
                      } else {
                        return const Center(
                          child: Text('Say Hii!👋🏻',
                              style: TextStyle(fontSize: 20)),
                        );
                      }
                  }
                },
              ),
            ),
            _chatInput()
          ],
        ),
      ),
    );
  }
  Widget _appBar() {
    SystemChrome.setSystemUIOverlayStyle(
         SystemUiOverlayStyle(statusBarColor: Colors.deepPurple));
    return InkWell(
      onTap: () {},
      child: Row(
        children: [
          IconButton(onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white70,
              )),
          ClipRRect(
            borderRadius: BorderRadius.circular(mq.height * 0.3),
            child: CachedNetworkImage(
              width: mq.height * 0.05,
              height: mq.height * 0.05,
              imageUrl: widget.user.image,
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) =>
                  CircleAvatar(child: Icon(Icons.person_2_outlined)),
            ),
          ),

          const SizedBox(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.user.name,
                  style: const TextStyle(
                      fontSize: 17,
                      color: Colors.white,
                      fontWeight: FontWeight.w500)),

              const SizedBox(height: 2),

              Text('last seen  12:15 AM',
                  style: const TextStyle(
                      fontSize: 13,
                      color: Colors.white70))
            ],
          )
        ],
      ),
    );
  }
    Widget _chatInput() {
      return Padding(
        padding:  EdgeInsets.symmetric(
          vertical: mq.height * 0.01,
          horizontal: mq.width * 0.025
        ),
        child: Row(
          children: [
            Expanded(
              child: Card(
                child: Row(children: [
                  IconButton(onPressed: () {},
                      icon: const Icon(
                        Icons.emoji_emotions_outlined,
                        color: Colors.deepPurple,
                        size: 25,
                      )),
                   Expanded(child: TextField(
                     controller: _textController,
                     keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: 'Type Something...',
                      hintStyle: TextStyle(color: Colors.deepPurple.shade300),
                      border: InputBorder.none
                    ),
                  )),
                  IconButton(onPressed: () {},
                      icon: const Icon(
                        Icons.image_outlined,
                        color: Colors.deepPurple,
                        size: 26,
                      )),
                  IconButton(onPressed: () {},
                      icon: const Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.deepPurple,
                        size: 26,
                      )),
                  SizedBox(width: mq.width * .02),
                ],),
              ),
            ),
            MaterialButton(onPressed: (){
              if(_textController.text.isNotEmpty){
                APIs.sendMessage(widget.user, _textController.text);
                _textController.text ='';
              }
            },
              minWidth: 0,
              padding: EdgeInsets.only(
                top: 10,
                bottom: 10,
                  right: 5,
                left: 10
              ),
              shape: CircleBorder(),
              color: Colors.green,
            child:const  Icon(
      Icons.send,
      color: Colors.white,
              size: 30,
      ) ,)
          ],
        ),
      );
    }
}
