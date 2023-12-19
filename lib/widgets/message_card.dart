import 'package:chatly/api/apis.dart';
import 'package:chatly/helper/my_date_util.dart';
import 'package:chatly/models/message.dart';
import 'package:flutter/material.dart';

import '../main.dart';
class MessageCard extends StatefulWidget {
  const MessageCard({super.key, required this.message});
  final Message message;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return APIs.user.uid == widget.message.fromId ?
    _greenMessage() :
    _blueMessage();
  }
  Widget _blueMessage() {

    if(widget.message.read.isEmpty)
      {
        APIs.updateMessageReadStatus(widget.message);
      }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(mq.width * .04),
            margin: EdgeInsets.symmetric(
              horizontal: mq.width * .04,
              vertical: mq.height * .01
            ),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              border: Border.all(color: Colors.blue.shade400),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomRight: Radius.circular(30)
              )
            ),
            child: Padding(
              padding:  EdgeInsets.only(right: mq.width * .04),
              child: Text(
                widget.message.msg,
                style: TextStyle(fontSize: 15,color: Colors.black),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: mq.width * .04 ),
          child: Text(MyDateUtil.getFormattedTime(context: context, time: widget.message.sent),
            style: TextStyle(fontSize: 13,color: Colors.black),),
        ),

      ],
    );
  }
  Widget _greenMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [

        Row(
          children: [
            SizedBox(width: mq.width * .04),
            Text(MyDateUtil.getFormattedTime(context: context, time: widget.message.sent),
              style: TextStyle(fontSize: 13,color: Colors.black),),
            const SizedBox(width: 2),
            if(widget.message.read.isNotEmpty)
            const Icon(
              Icons.done_all_outlined,
              color: Colors.blue,
              size: 20,
            )

          ],
        ),
        Flexible(
          child: Container(
            padding: EdgeInsets.all(mq.width * .04),
            margin: EdgeInsets.symmetric(
                horizontal: mq.width * .04,
                vertical: mq.height * .01
            ),
            decoration: BoxDecoration(
                color: Colors.green.shade100,
                border: Border.all(color: Colors.lightGreen.shade400),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30)
                )
            ),
            child: Padding(
              padding:  EdgeInsets.only(left: mq.width * .04),
              child: Text(
                widget.message.msg,
                style: TextStyle(fontSize: 15,color: Colors.black),
              ),
            ),
          ),
        ),

      ],
    );
  }
  void _showMessageUpdateDialog() {
    String updatedMsg = widget.message.msg;

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
          contentPadding: const EdgeInsets.only(
              left: 24, right: 24, top: 20, bottom: 10),

          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),

          //title
          title: Row(
            children: const [
              Icon(
                Icons.message,
                color: Colors.blue,
                size: 28,
              ),
              Text(' Update Message')
            ],
          ),

          //content
          content: TextFormField(
            initialValue: updatedMsg,
            maxLines: null,
            onChanged: (value) => updatedMsg = value,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15))),
          ),

          //actions
          actions: [
            //cancel button
            MaterialButton(
                onPressed: () {
                  //hide alert dialog
                  Navigator.pop(context);
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.blue, fontSize: 16),
                )),

            //update button
            MaterialButton(
                onPressed: () {
                  //hide alert dialog
                  Navigator.pop(context);
                  APIs.updateMessage(widget.message, updatedMsg);
                },
                child: const Text(
                  'Update',
                  style: TextStyle(color: Colors.blue, fontSize: 16),
                ))
          ],
        ));
  }
}

