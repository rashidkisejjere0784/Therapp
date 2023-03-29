import 'package:flutter/material.dart';
import 'Pallete.dart';

class Note extends StatefulWidget {
  String content;
  String date;
  IconData icon;
  Note({required this.content, required this.date, required this.icon});

  @override
  State<Note> createState() => _NoteState();
}

class _NoteState extends State<Note> {
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
          "Note",
          style: TextStyle(
            color: Pallete.dark_purple,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.fromLTRB(20, 30, 20, 0),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 10, 5),
                    child: Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Icon(
                        this.widget.icon,
                        color: Pallete.dark_purple,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Text(
                      this.widget.date,
                      style: const TextStyle(
                        color: Pallete.dark_purple,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 15, 0, 50),
                width: MediaQuery.of(context).size.width - 20,
                height: MediaQuery.of(context).size.height - 170,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 3,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Text(this.widget.content),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
