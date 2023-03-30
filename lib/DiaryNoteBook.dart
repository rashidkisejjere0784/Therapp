import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:therapp/Pallete.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(const DiaryNoteBook());

class DiaryNoteBook extends StatefulWidget {
  const DiaryNoteBook({Key? key}) : super(key: key);

  @override
  State<DiaryNoteBook> createState() => FeelingState();
}

class FeelingState extends State<DiaryNoteBook> {
  bool _diaryNoteBook = false;
  String selectedEmoji = "Neutral";
  bool tapped1 = false,
      tapped2 = false,
      tapped3 = false,
      tapped4 = false,
      tapped5 = false;
  final user = FirebaseAuth.instance.currentUser;
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Pallete.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: (() {
            Navigator.pop(context);
          }),
          child: const Icon(
            Icons.arrow_back,
            size: 20,
            color: Pallete.dark_purple,
          ),
        ),
        title: const Text(
          "Your Diary",
          style: TextStyle(
            color: Pallete.dark_purple,
          ),
        ),
        centerTitle: true,
      ),
      body: _diaryNoteBook ? buildNoteBook() : buildFeelings(),
    );
  }

  Center buildFeelings() {
    return Center(
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 80, 20, 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "How are you feeling?",
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Pallete.dark_purple,
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
              margin: const EdgeInsets.all(20),
              width: 323,
              height: 109,
              decoration: BoxDecoration(
                color: const Color(0xFFE2DDFF),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 5,
                      spreadRadius: 2),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (tapped1 == false) {
                              tapped1 = true;
                              tapped2 = false;
                              tapped3 = false;
                              tapped4 = false;
                              tapped5 = false;
                            } else if (tapped1 == true) {
                              tapped1 = false;
                            }
                          });
                          selectedEmoji = "Excited";
                        },
                        child: Icon(
                          Icons.sentiment_very_satisfied,
                          size: tapped1 ? 30 : 24.0,
                          color: tapped1
                              ? Pallete.dark_purple
                              : const Color(0xFF908DA1),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (tapped1 == false) {
                              tapped1 = true;
                              tapped2 = false;
                              tapped3 = false;
                              tapped4 = false;
                              tapped5 = false;
                            } else if (tapped1 == true) {
                              tapped1 = false;
                            }
                          });
                          selectedEmoji = "Excited";
                        },
                        child: Text(
                          'Excited!',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: tapped1
                                ? Pallete.dark_purple
                                : const Color(0xFF908DA1),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (tapped2 == false) {
                              tapped2 = true;
                              tapped1 = false;
                              tapped3 = false;
                              tapped4 = false;
                              tapped5 = false;
                            } else if (tapped2 == true) {
                              tapped2 = false;
                            }
                          });
                          selectedEmoji = "Happy";
                        },
                        child: Icon(
                          Icons.sentiment_satisfied,
                          size: tapped2 ? 30 : 24.0,
                          color: tapped2
                              ? Pallete.dark_purple
                              : const Color(0xFF908DA1),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (tapped2 == false) {
                              tapped2 = true;
                              tapped1 = false;
                              tapped3 = false;
                              tapped4 = false;
                              tapped5 = false;
                            } else if (tapped2 == true) {
                              tapped2 = false;
                            }
                          });
                          selectedEmoji = "Happy";
                        },
                        child: Text(
                          'Happy',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: tapped2
                                ? Pallete.dark_purple
                                : const Color(0xFF908DA1),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (tapped3 == false) {
                              tapped3 = true;
                              tapped1 = false;
                              tapped2 = false;
                              tapped4 = false;
                              tapped5 = false;
                            } else if (tapped3 == true) {
                              tapped3 = false;
                            }
                          });
                          selectedEmoji = "Neutral";
                        },
                        child: Icon(
                          Icons.sentiment_neutral,
                          size: tapped3 ? 30 : 24.0,
                          color: tapped3
                              ? Pallete.dark_purple
                              : const Color(0xFF908DA1),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (tapped3 == false) {
                              tapped3 = true;
                              tapped1 = false;
                              tapped2 = false;
                              tapped4 = false;
                              tapped5 = false;
                            } else if (tapped3 == true) {
                              tapped3 = false;
                            }
                          });
                          selectedEmoji = "Neutral";
                        },
                        child: Text(
                          'Neutral',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: tapped3
                                ? Pallete.dark_purple
                                : const Color(0xFF908DA1),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (tapped4 == false) {
                              tapped4 = true;
                              tapped1 = false;
                              tapped2 = false;
                              tapped3 = false;
                              tapped5 = false;
                            } else if (tapped4 == true) {
                              tapped4 = false;
                            }
                          });
                          selectedEmoji = "Sad";
                        },
                        child: Icon(
                          Icons.sentiment_dissatisfied,
                          size: tapped4 ? 30 : 24.0,
                          color: tapped4
                              ? Pallete.dark_purple
                              : const Color(0xFF908DA1),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (tapped4 == false) {
                              tapped4 = true;
                              tapped1 = false;
                              tapped2 = false;
                              tapped3 = false;
                              tapped5 = false;
                            } else if (tapped4 == true) {
                              tapped4 = false;
                            }
                          });
                          selectedEmoji = "Sad";
                        },
                        child: Text(
                          'Sad',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: tapped4
                                ? Pallete.dark_purple
                                : const Color(0xFF908DA1),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (tapped5 == false) {
                              tapped5 = true;
                              tapped1 = false;
                              tapped2 = false;
                              tapped3 = false;
                              tapped4 = false;
                            } else if (tapped5 == true) {
                              tapped5 = false;
                            }
                          });
                          selectedEmoji = "Angry";
                        },
                        child: Icon(
                          Icons.sentiment_very_dissatisfied,
                          size: tapped5 ? 30 : 24.0,
                          color: tapped5
                              ? Pallete.dark_purple
                              : const Color(0xFF908DA1),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (tapped5 == false) {
                              tapped5 = true;
                              tapped1 = false;
                              tapped2 = false;
                              tapped3 = false;
                              tapped4 = false;
                            } else if (tapped5 == true) {
                              tapped5 = false;
                            }
                          });
                          selectedEmoji = "Angry";
                        },
                        child: Text(
                          'Angry',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: tapped5
                                ? Pallete.dark_purple
                                : const Color(0xFF908DA1),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Text(
              'Your selection will be recorded along side your written feelings',
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.normal,
                fontSize: 14,
                color: const Color(0xFFA58EFF),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _diaryNoteBook = true;
                  });
                },
                child: const Text("Continue"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF765FCF),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData generateIcon() {
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

  Center buildNoteBook() {
    DateTime now = DateTime.now();
    String date = now.day.toString() +
        "-" +
        now.month.toString() +
        "-" +
        now.year.toString();
    return Center(
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(5, 0, 95, 5),
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Icon(
                      generateIcon(),
                      color: Pallete.dark_purple,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(120, 0, 0, 0),
                  child: Text(
                    date,
                    style: const TextStyle(
                      color: Pallete.dark_purple,
                    ),
                  ),
                ),
              ],
            ),
            TextField(
              cursorColor: Pallete.dark_purple,
              controller: textController,
              decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Pallete.light_purple),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Pallete.light_purple),
                ),
                hintText: 'Express your feelings here',
              ),
              keyboardType: TextInputType.multiline,
              minLines: 1,
              maxLines: 15,
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: ElevatedButton(
                onPressed: () async {
                  final userEmail = user?.email.toString();

                  final CollectionReference collection =
                      FirebaseFirestore.instance.collection(userEmail ?? " ");
                  await collection.add({
                    'content': textController.text.trim(),
                    'date': DateTime.now(),
                    'feelings': selectedEmoji
                  });
                  setState(() {
                    textController.text = "";
                  });
                },
                child: const Text("POST!"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF765FCF),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
