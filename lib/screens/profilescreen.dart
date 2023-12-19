
import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatly/helper/dialogs.dart';
import 'package:chatly/screens/auth/loginscreen.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

import '../api/apis.dart';
import '../main.dart';
import '../models/chatuser.dart';

class profilescreen extends StatefulWidget {
  final chatuser user ;
  const profilescreen({super.key, required this.user});

  @override
  State<profilescreen> createState() => _profilescreenState();
}

class _profilescreenState extends State<profilescreen> {
  final _formKey = GlobalKey<FormState>();
  String? _image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(

          title: const Text('Profile Screen'),

        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom:10),
          child: FloatingActionButton.extended(
              onPressed: () async{
            Dialogs.showProgressBar(context);
            await APIs.auth.signOut().then((value) async {
              await GoogleSignIn().signOut().then((value) {
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => loginscreen()));
              });
            });
          },
            icon: const Icon(Icons.logout, color: Colors.redAccent),
              label: Text('Logout' , style: const TextStyle(color: Colors.redAccent))),
        ),

        body: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: mq.height * .028),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(width: mq.width, height: mq.height * .03),
                   Stack(
                     children: [
                       _image != null ? ClipRRect(
                   borderRadius: BorderRadius.circular(mq.height * 0.1),
              child: Image.file(
                File(_image!),
                width: mq.height * 0.2,
                height: mq.height * 0.2,
                fit: BoxFit.cover
              ),
            ) :
                       ClipRRect(
                        borderRadius: BorderRadius.circular(mq.height * 0.1),
                        child: CachedNetworkImage(
                          width: mq.height * 0.2,
                          height: mq.height * 0.2,
                          fit: BoxFit.cover,
                          imageUrl: widget.user.image,
                          placeholder: (context, url) => CircularProgressIndicator(),
                          errorWidget: (context, url, error) => CircleAvatar(child: Icon(Icons.person_2_outlined)),
                        ),
                                   ),
                       Positioned(
                         bottom: 0,
                         right: 0,
                         child: MaterialButton(
                           elevation: 1,
                           onPressed: () {
                             _showBottomSheet();
                           },
                           shape: const CircleBorder(),
                           color: Colors.white,
                         child: Icon(Icons.edit_outlined,color: Colors.deepPurple,),),
                       )
                     ],
                   ),
                  SizedBox( height: mq.height * .01),
                  Text(widget.user.email,
                  style: const TextStyle(fontSize: 16)),

                  SizedBox( height: mq.height * .05),


                  TextFormField(
                    initialValue: widget.user.name,
                    onSaved: (val) => APIs.me.name = val ?? '',
                    validator: (val) => val!= null && val.isNotEmpty ? null : 'Can Not Be Empty',
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_2_outlined, color: Colors.deepPurple),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                      hintText: 'eg. Happy Singh',
                      label: const Text('Name')),
                  ),
                  SizedBox( height: mq.height * .02),

                  TextFormField(
                    initialValue: widget.user.about,
                    onSaved: (val) => APIs.me.about = val ?? '',
                    validator: (val) => val!= null && val.isNotEmpty ? null : 'Can Not Be Empty',
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.info_outline_rounded, color: Colors.deepPurple),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        hintText: 'eg. Feeling Happy ',
                        label: const Text('About')),
                  ),

                  SizedBox( height: mq.height * .03),

                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(mq.width * 0.5, mq.height * 0.06)
                    ),
                      onPressed: () {
                      if(_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        APIs.updateUserInfo().then((value) {
                          Dialogs.showSnackbar(context, 'Profile Updated Successfully!');
                        });
                      }
                      },
                      icon: const Icon(Icons.edit_outlined, size: 28,),
                    label: const Text('UPDATE',  style: const TextStyle(fontSize: 16)),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  void _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20))),
        builder: (_){
      return ListView(
        shrinkWrap: true,
        padding: EdgeInsets.only(top:mq.height * .03, bottom: mq.height * .05),
        children: [
          const Text('Pick Profile Picture',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500 )),
          SizedBox(height: mq.height * .02),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              fixedSize: Size(mq.width * .3, mq.height * .15),
              shape: const CircleBorder()),
              onPressed: () async {
                final ImagePicker picker = ImagePicker();
                final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                if (image != null) {
                  log('Image Path: ${image.path} -- MimeType: ${image
                      .mimeType}');
                  setState(() {
                    _image = image.path;
                  });
                  APIs.updateProfilePicture(File(_image!));
                  Navigator.pop(context);
                }
              },
              child: Image.asset('images/addimage.png')),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    fixedSize: Size(mq.width * .3, mq.height * .15),
                    shape: const CircleBorder()),
                onPressed: () async {
                  final ImagePicker picker = ImagePicker();
                  final XFile? image = await picker.pickImage(source: ImageSource.camera);
                  if (image != null) {
                    log('Image Path: ${image.path} -- MimeType: ${image
                        .mimeType}');
                    setState(() {
                      _image = image.path;
                    });
                    APIs.updateProfilePicture(File(_image!));
                    Navigator.pop(context);
                  }
                },
                child: Image.asset('images/camera.png'))],)
          ],);
    });
  }
}
