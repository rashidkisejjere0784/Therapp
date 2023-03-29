import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'Pallete.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CalEvent {
  final String title;

  const CalEvent(this.title);

  @override
  String toString() => title;
}

class Calender extends StatefulWidget {
  const Calender({Key? key}) : super(key: key);
  _CalenderState createState() => _CalenderState();
}

class _CalenderState extends State<Calender> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;
  List<String> Months = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sept",
    "Oct",
    "Nov",
    "Dec"
  ];

  Map<DateTime, List<CalEvent>> events = {};

  List<CalEvent> _getCalEventsForDay(DateTime day) {
    return events[day] ?? [];
  }

  List<Map<String, dynamic>> _data = [];

  @override
  void initState() {
    super.initState();
    final userEmail = user?.email.toString();
    final collection_name = "pinned " + (userEmail.toString() ?? " ");

    try {
      _firestore.collection(collection_name).get().then((snapshots) {
        setState(() {
          snapshots.docs.forEach((document) {
            DateTime dt = document.data()["date"].toDate();
            int year = dt.year;
            int day = dt.day;
            int month = dt.month;

            DateTime new_dt = DateTime.utc(year, month, day);
            events[new_dt] = [new CalEvent(document.data()["name"])];
          });
        });
      });
    } catch (err) {
      print(err.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final userEmail = user?.email.toString();
    final collection_name = "pinned " + (userEmail.toString() ?? " ");
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
            "Your Events",
            style: TextStyle(
              color: Pallete.dark_purple,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            Container(
                child: TableCalendar(
              eventLoader: (day) {
                return _getCalEventsForDay(day);
              },
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay; // update `_focusedDay` here as well
                });
              },
              calendarFormat: _calendarFormat,
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2025, 3, 14),
              focusedDay: DateTime.now(),
            )),
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection(collection_name)
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
                          return buildPinnedEvent(
                              document['name'], document['date'].toDate());
                        }).toList(),
                      );
                  }
                })
          ]),
        ));
  }

  Container buildPinnedEvent(String name, DateTime date) {
    DateTime now = DateTime.now();
    if (date.compareTo(now) > 0)
      return Container(
          width: MediaQuery.of(context).size.width - 10,
          height: 80,
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.only(top: 10, bottom: 10, right: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 5,
                  spreadRadius: 2),
            ],
          ),
          child: Row(
            children: [
              VerticalDivider(
                color: Pallete.dark_purple,
                thickness: 10,
              ),
              Column(
                children: [
                  Text(date.day.toString(),
                      style: TextStyle(
                          color: Pallete.dark_purple,
                          fontWeight: FontWeight.bold,
                          fontSize: 25)),
                  Text(Months[date.month - 1],
                      style: TextStyle(
                          color: Pallete.dark_purple,
                          fontWeight: FontWeight.bold,
                          fontSize: 25))
                ],
              ),
              Spacer(),
              Column(children: [
                Text(name,
                    style: TextStyle(
                        color: Pallete.dark_purple,
                        fontWeight: FontWeight.bold,
                        fontSize: 15)),
                Text(date.year.toString(),
                    style: TextStyle(
                        color: Pallete.dark_purple,
                        fontWeight: FontWeight.bold,
                        fontSize: 25))
              ]),
            ],
          ));

    return Container();
  }
}
