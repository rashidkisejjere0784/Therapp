import 'package:flutter/material.dart';
import 'package:therapp/Pallete.dart';
import 'package:therapp/Calender.dart';
import 'Library.dart';
import 'ContactUs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'signin.dart';

class User extends StatefulWidget {
  const User({Key? key}) : super(key: key);
  @override
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
            title: const Text(
              "me",
              style: TextStyle(color: Pallete.dark_purple, fontSize: 20),
            ),
            centerTitle: true,
            backgroundColor: Colors.white),
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(height: 5),
          GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ContactUs()),
                );
              },
              child: Container(
                  padding: const EdgeInsets.all(15),
                  color: Colors.white,
                  // ignore: prefer_const_literals_to_create_immutables
                  child: Row(children: [
                    const Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(Icons.email, color: Pallete.light_purple),
                    ),
                    const Text(
                      "Contact Us",
                      style:
                          TextStyle(color: Pallete.dark_purple, fontSize: 20),
                    ),
                  ]))),
          const SizedBox(height: 5),
          GestureDetector(
            child: Container(
                padding: const EdgeInsets.all(15),
                color: Colors.white,
                // ignore: prefer_const_literals_to_create_immutables
                child: Row(children: [
                  const Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(Icons.event, color: Pallete.light_purple),
                  ),
                  const Text(
                    "Your Events",
                    style: TextStyle(color: Pallete.dark_purple, fontSize: 20),
                  ),
                ])),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Calender()),
              );
            },
          ),
          const SizedBox(height: 5),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Library()),
              );
            },
            child: Container(
                padding: const EdgeInsets.all(15),
                color: Colors.white,
                // ignore: prefer_const_literals_to_create_immutables
                child: Row(children: [
                  const Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(Icons.library_books_rounded,
                        color: Pallete.light_purple),
                  ),
                  const Text(
                    "Your Library",
                    style: TextStyle(color: Pallete.dark_purple, fontSize: 20),
                  ),
                ])),
          ),
          const SizedBox(height: 5),
          GestureDetector(
            onTap: () async {
              print("tapped");
              await FirebaseAuth.instance.signOut().then((value) =>
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const SignIn()),
                      (route) => false));
            },
            child: Container(
                padding: const EdgeInsets.all(15),
                color: Colors.white,
                // ignore: prefer_const_literals_to_create_immutables
                child: Row(children: [
                  const Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(Icons.logout, color: Pallete.light_purple),
                  ),
                  const Text(
                    "Logout",
                    style: TextStyle(color: Pallete.dark_purple, fontSize: 20),
                  ),
                ])),
          )
        ]));
  }
}
