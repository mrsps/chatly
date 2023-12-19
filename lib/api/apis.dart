import 'dart:developer';
import 'dart:io';

import 'package:chatly/models/chatuser.dart';
import 'package:chatly/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class APIs {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseStorage storage = FirebaseStorage.instance;
  static User get user => auth.currentUser!;
  static late chatuser me;

  static Future<void> getSelfInfo() async{
    await firestore
        .collection('users')
        .doc(user.uid)
        .get()
        .then((user) async {
          if(user.exists){
            me = chatuser.fromJson(user.data()!);
            log('My Data: ${user.data()}');
          }else {
           await createUser().then((value) => getSelfInfo());
          }
    });
  }
  static Future<bool> userExists() async{
    return (await firestore
        .collection('users')
        .doc(user.uid)
        .get())
        .exists;
  }
  static Future<void> createUser() async{
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final chatUser = chatuser(
        image: user.photoURL.toString(),
        about: "hey, I'm using chatly!",
        name: user.displayName.toString(),
        createdAt: time,
        id: user.uid,
        lastActive: time,
        isOnline: false,
        pushToken: '',
        email: user.email.toString());
    return await firestore
        .collection('users')
        .doc(user.uid)
        .set(chatUser.toJson());

  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return firestore.collection('users')
        .where('id', isNotEqualTo: user.uid)
        .snapshots() ;

  }

  static Future<void> updateUserInfo() async{
    await firestore
        .collection('users')
        .doc(user.uid)
        .update({
      'name' : me.name,
      'about' : me.about,
    });
  }

  static Future<void> updateProfilePicture(File file) async{
    final ext = file.path.split('.').last;
    log('Extension: $ext');
    final ref = storage.ref().child('profile_pictures/${user.uid}.$ext');
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
          log('Data Transferred: ${p0.bytesTransferred/1000} kb');
    });
    me.image = await ref.getDownloadURL();
    await firestore
        .collection('users')
        .doc(user.uid)
        .update({
      'image' : me.image,
    });

  }

  static String getConversationId(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id' : '${id}_${user.uid}';

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(chatuser user) {
    return firestore.collection('chat/${getConversationId(user.id)}/messages/')
        .snapshots() ;

  }

  static Future<void> sendMessage(chatuser chatUser , String msg) async{
    final time= DateTime.now().millisecondsSinceEpoch.toString();

    final Message message = Message(
        msg: msg,
        toId: chatUser.id,
        read: '',
        type: Type.text,
        fromId: user.uid,
        sent: time);

    final ref=firestore.collection('chat/${getConversationId(chatUser.id)}/messages/');
    await ref.doc(time).set(message.toJson());
  }
  
  static Future<void> updateMessageReadStatus(Message message) async{
    firestore
        .collection('chat/${getConversationId(message.fromId)}/messages/')
        .doc(message.sent)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString() });
   
  }
  
  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessages(chatuser user) {
    return firestore.collection('chat/${getConversationId(user.id)}/messages/')
    .orderBy('sent',descending: true)
    .limit(1)
        .snapshots() ;
  }

  static Future<void> updateMessage(Message message, String updatedMsg) async {
    await firestore
        .collection('chats/${getConversationId(message.toId)}/messages/')
        .doc(message.sent)
        .update({'msg': updatedMsg});
  }
}