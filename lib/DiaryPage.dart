import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'Pallete.dart';
import 'DiaryNoteBook.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Note.dart';
import 'package:google_fonts/google_fonts.dart';

class DiaryPage extends StatefulWidget {
  const DiaryPage({Key? key}) : super(key: key);
  _DiaryPageState createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Pallete.dark_purple,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DiaryNoteBook()),
            );
          },
          child: Icon(Icons.add),
        ),
        body: SingleChildScrollView(
          child: Center(
              child: Column(
            children: [
              Align(
                alignment: AlignmentDirectional.topCenter,
                child: Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                  child: Text(
                    "How are you feeling today?",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Color(0xFF765FCF),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection(user?.email.toString() ?? " ")
                      .orderBy('date', descending: true)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError)
                      return new Text('Error: ${snapshot.error}');
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Center(child: CircularProgressIndicator());
                      default:
                        return new ListView(
                          shrinkWrap: true,
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot document) {
                            //check whether event is on going or not
                            return BuildNote(
                                document['content'],
                                generateIcon(document['feelings']),
                                document['date']);
                          }).toList(),
                        );
                    }
                  })
            ],
          )),
        ));
  }

  IconData generateIcon(String selectedEmoji) {
    IconData icon = Icons.sentiment_neutral;

    if (selectedEmoji == "Neutral") {
      icon = Icons.sentiment_neutral;
    }
    if (selectedEmoji == "Sad") {
      icon = Icons.sentiment_dissatisfied;
    }
    if (selectedEmoji == "Angry") {
      icon = Icons.sentiment_very_dissatisfied;
    }
    if (selectedEmoji == "Happy") {
      icon = Icons.sentiment_satisfied;
    }
    if (selectedEmoji == "Excited") {
      icon = Icons.sentiment_very_satisfied;
    }

    return icon;
  }

  GestureDetector BuildNote(String content, IconData icon, Timestamp date) {
    DateTime note_Date = date.toDate();

    String noteDateStr = DateFormat('yyyy-MM-dd').format(note_Date);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Note(
                    content: content,
                    date: noteDateStr,
                    icon: icon,
                  )),
        );
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 5, 20, 5),
        padding: const EdgeInsets.all(10),
        width: (MediaQuery.of(context).size.width) - 10,
        height: 50,
        decoration: BoxDecoration(
          color: const Color(0xFFE2DDFF),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 1,
                spreadRadius: 1),
          ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: Pallete.dark_purple,
            ),
            Spacer(),
            Text(
              noteDateStr,
              style: TextStyle(
                color: Pallete.dark_purple,
              ),
            ),
            Spacer(),
            Icon(Icons.keyboard_arrow_right_sharp, color: Color(0xFF634EB1))
          ],
        ),
      ),
    );
  }
}
