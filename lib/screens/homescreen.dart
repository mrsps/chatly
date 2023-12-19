import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';

import 'package:chatly/api/apis.dart';
import 'package:chatly/screens/profilescreen.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../main.dart';
import '../widgets/chatusercard.dart';
import '../models/chatuser.dart';

class homescreen extends StatefulWidget {
  const homescreen({super.key});

  @override
  State<homescreen> createState() => _homescreenState();
}

class _homescreenState extends State<homescreen> {
  List<chatuser> _list = [];
  final List<chatuser> _searchlist = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    APIs.getSelfInfo();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            appBar: AppBar(
              leading: Icon(Icons.home),
              title: _isSearching
                  ? TextField(
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Name,Email,....',
                        hintStyle: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                      autofocus: true,
                      style: TextStyle(
                          color: Colors.white, fontSize: 17, letterSpacing: .5),
                      cursorColor: Colors.white,
                      onChanged: (val) {
                        _searchlist.clear();
                        for (var i in _list) {
                          if (i.name.toLowerCase().contains(val.toLowerCase()) ||
                              i.name.toLowerCase().contains(val.toLowerCase())) {
                            _searchlist.add(i);
                            setState(() {
                              _searchlist;
                            });
                          }
                        }
                      },
                    )
                  : Text('Chatly'),
              actions: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        _isSearching = !_isSearching;
                      });
                    },
                    icon: Icon(_isSearching ? Icons.clear : Icons.search)),
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => profilescreen(user: APIs.me)));
                    },
                    icon: const Icon(Icons.more_vert)),
              ],
            ),
            floatingActionButton: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: FloatingActionButton(
                onPressed: ()  {
                  _addChatUserDialog();

                },
                child: const Icon(Icons.add_circle_sharp),
              ),
            ),
            body: StreamBuilder(
              stream: APIs.getAllUsers(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return const Center(child: CircularProgressIndicator());
                  case ConnectionState.active:
                  case ConnectionState.done:
                    final data = snapshot.data?.docs;
                    _list =
                        data?.map((e) => chatuser.fromJson(e.data())).toList() ??
                            [];

                    if (_list.isNotEmpty) {
                      return ListView.builder(
                          itemCount:
                              _isSearching ? _searchlist.length : _list.length,
                          padding: EdgeInsets.only(top: mq.height * .008),
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return chatusercard(
                                user: _isSearching
                                    ? _searchlist[index]
                                    : _list[index]);
                            // return Text('Name: ${list[index]}');
                          });
                    } else {
                      return const Center(
                        child: Text('No connections Found!',
                            style: TextStyle(fontSize: 20)),
                      );
                    }
                }
              },
            ),
          ),


    );
  }
  void _addChatUserDialog() {
    String email ='';

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
                Icons.person_2_outlined,
                color: Colors.deepPurple,
                size: 28,
              ),
              Text('  Add User')
            ],
          ),

          //content
          content: TextFormField(
            maxLines: null,
            onChanged: (value) => email = value,
            decoration: InputDecoration(
              hintText: 'Email ID',
                prefixIcon: Icon(Icons.email,color: Colors.deepPurple,),
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
                  style: TextStyle(color: Colors.deepPurple, fontSize: 16),
                )),

            //update button
            MaterialButton(
                onPressed: () {
                  //hide alert dialog
                  Navigator.pop(context);
                  //APIs.updateMessage(widget.message, updatedMsg);
                },
                child: const Text(
                  'ADD',
                  style: TextStyle(color: Colors.deepPurple, fontSize: 16),
                ))
          ],
        ));
  }
}
