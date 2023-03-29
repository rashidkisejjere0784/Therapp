import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:therapp/Pallete.dart';
import 'package:therapp/Calender.dart';
import 'Library.dart';
import 'ContactUs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'signin.dart';

class User extends StatefulWidget {
  const User({Key? key}) : super(key: key);
  _WidgetState createState() => _WidgetState();
}

class _WidgetState extends State<User> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Pallete.background,
        appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            title: Text(
              "me",
              style: TextStyle(color: Pallete.dark_purple, fontSize: 20),
            ),
            centerTitle: true,
            backgroundColor: Colors.white),
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(height: 5),
          GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ContactUs()),
                );
              },
              child: Container(
                  padding: EdgeInsets.all(15),
                  color: Colors.white,
                  child: Row(children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(Icons.email, color: Pallete.light_purple),
                    ),
                    Text(
                      "Contact Us",
                      style:
                          TextStyle(color: Pallete.dark_purple, fontSize: 20),
                    ),
                  ]))),
          SizedBox(height: 5),
          GestureDetector(
            child: Container(
                padding: EdgeInsets.all(15),
                color: Colors.white,
                child: Row(children: [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(Icons.event, color: Pallete.light_purple),
                  ),
                  Text(
                    "Your Events",
                    style: TextStyle(color: Pallete.dark_purple, fontSize: 20),
                  ),
                ])),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Calender()),
              );
            },
          ),
          SizedBox(height: 5),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Library()),
              );
            },
            child: Container(
                padding: EdgeInsets.all(15),
                color: Colors.white,
                child: Row(children: [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(Icons.library_books_rounded,
                        color: Pallete.light_purple),
                  ),
                  Text(
                    "Your Library",
                    style: TextStyle(color: Pallete.dark_purple, fontSize: 20),
                  ),
                ])),
          ),
          SizedBox(height: 5),
          GestureDetector(
            onTap: () async {
              print("tapped");
              await FirebaseAuth.instance.signOut().then((value) =>
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => SignIn()),
                      (route) => false));
            },
            child: Container(
                padding: EdgeInsets.all(15),
                color: Colors.white,
                child: Row(children: [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(Icons.logout, color: Pallete.light_purple),
                  ),
                  Text(
                    "Logout",
                    style: TextStyle(color: Pallete.dark_purple, fontSize: 20),
                  ),
                ])),
          )
        ]));
  }
}
