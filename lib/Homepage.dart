import 'package:therapp/HomePage2.dart';
import 'package:flutter/material.dart';
import 'package:therapp/Pallete.dart';
import 'package:therapp/Diary.dart';
import 'package:therapp/Events.dart';
import 'package:therapp/User.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    //list of all of the articles with their links to e cscraped from the internet

    List<Widget> _children = [const HomePage2(), const Diary(), const Events(), const User()];
    return Scaffold(
      backgroundColor: Pallete.background,
      body: _children[currentIndex],
      bottomNavigationBar: GNav(
          gap: 8,
          backgroundColor: Colors.white,
          color: Pallete.text_color1,
          activeColor: Pallete.dark_purple,
          onTabChange: (value) {
            setState(() {
              currentIndex = value;
            });
          },
          tabs: const [
            GButton(icon: Icons.home, text: "home"),
            GButton(icon: Icons.book, text: "Diary"),
            GButton(icon: Icons.group, text: "events"),
            GButton(icon: Icons.person, text: "me"),
          ]),
    );
  }
}
