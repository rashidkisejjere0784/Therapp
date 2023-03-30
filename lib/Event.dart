import 'package:flutter/material.dart';
import 'package:therapp/Pallete.dart';
import 'Calender.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class Event extends StatefulWidget {
  String Event_name = "";

  Event(String name) {
    Event_name = name;
  }
  _EventState createState() => _EventState();
}

class _EventState extends State<Event> {
  int activeIndex = 1;
  String activeDocument = "";
  List<String> pinnedEvents = [];
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    final userEmail = user?.email.toString();
    final collectionName = "pinned " + (userEmail.toString());

    FirebaseFirestore.instance
        .collection(collectionName)
        .get()
        .then((querySnapshot) {
      List<String> documentIds = [];

      for (var document in querySnapshot.docs) {
        documentIds.add(document.id);
      }

      setState(() {
        pinnedEvents = documentIds;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Pallete.background,
      floatingActionButton:
          // Stack(
          //   children: <Widget>[
          //     Padding(
          //       padding: EdgeInsets.only(left: 60),
          //       child: Align(
          //         alignment: Alignment.bottomCenter,
          //         child: PopupItemLauncher(
          //           tag: 'test',
          //           child: AvatarGlow(
          //             endRadius: 60.0,
          //             glowColor: Pallete.dark_purple,
          //             child: Material(
          //               color: Pallete.dark_purple,
          //               //elevation: 2,
          //               shape: RoundedRectangleBorder(
          //                   borderRadius: BorderRadius.circular(32)),
          //               child: const Icon(
          //                 Icons.add_rounded,
          //                 size: 56,
          //                 color: Colors.white,
          //               ),
          //             ),
          //           ),
          //           popUp: PopUpItem(
          //             padding: EdgeInsets.all(8),
          //             color: Colors.white,
          //             shape: RoundedRectangleBorder(
          //                 borderRadius: BorderRadius.circular(32)),
          //             elevation: 2,
          //             tag: 'test',
          //             child: PopItemBody(this.widget.Event_name),
          //           ),
          //         ),
          //       ),
          //     ),
          //     Align(
          // alignment: Alignment.bottomRight,
          // child:
          FloatingActionButton(
        backgroundColor: Pallete.dark_purple,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Calender(),
              ));
        },
        child: const Icon(Icons.calendar_month),
      ),
      //     ),
      //   ],
      // ),
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
        title: Text(
          widget.Event_name,
          style: const TextStyle(
            color: Pallete.dark_purple,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.white,
              margin: const EdgeInsets.all(10),
              child: Row(children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      activeIndex = 0;
                    });
                  },
                  child: Text(
                    "UPCOMING",
                    style: TextStyle(
                        color: (activeIndex == 0)
                            ? Pallete.dark_purple
                            : Pallete.text_color1,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      activeIndex = 1;
                    });
                  },
                  child: Text("ONGOING",
                      style: TextStyle(
                          color: (activeIndex == 1)
                              ? Pallete.dark_purple
                              : Pallete.text_color1,
                          fontWeight: FontWeight.bold,
                          fontSize: 15)),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      activeIndex = 2;
                    });
                  },
                  child: Text(
                    "VISITED",
                    style: TextStyle(
                        color: (activeIndex == 2)
                            ? Pallete.dark_purple
                            : Pallete.text_color1,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                )
              ]),
            ),
            BuildSection(activeIndex)
          ],
        ),
      ),
    );
  }

  Container BuildSection(int sectionNo) {
    bool showPin = false;
    bool showLink = false;
    if (sectionNo == 0) {
      // the section is for upcoming events
      showPin = true;
    }
    if (sectionNo == 1) {
      showLink = true;
    }
    // ignore: avoid_unnecessary_containers
    return Container(
      child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('SupportGroups')
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) return Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(child: CircularProgressIndicator());
              default:
                // ignore: unnecessary_new
                return new ListView(
                  shrinkWrap: true,
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    //check whether event is on going or not
                    if (document['Category'] == widget.Event_name) {
                      Timestamp currentTimestamp = Timestamp.now();

                      Timestamp eventStart = document['start time'];

                      Timestamp eventEnd = document['end time'];

                      bool isOnGoing =
                          (currentTimestamp.compareTo(eventStart) >= 0) &&
                              (currentTimestamp.compareTo(eventEnd) <= 0);
                      bool isUpcoming =
                          (currentTimestamp.compareTo(eventStart) < 0);

                      bool isVisited =
                          (currentTimestamp.compareTo(eventEnd) > 0);

                      if (isOnGoing && sectionNo == 1) {
                        //Event is
                        return BuildEvent(
                            document['name'],
                            document['start time'],
                            document['end time'],
                            document['meet link'],
                            showPin,
                            showLink,
                            document.id,
                            document['Details']);
                      } else if (isUpcoming && sectionNo == 0) {
                        try {
                          return BuildEvent(
                              document['name'],
                              document['start time'],
                              document['end time'],
                              document['meet link'],
                              showPin,
                              showLink,
                              document.id,
                              document['Details']);
                        } on Exception {
                          return BuildEvent(
                              document['name'],
                              document['start time'],
                              document['end time'],
                              "https://meet.google.com",
                              showPin,
                              showLink,
                              document.id,
                              document['Details']);
                        }
                      } else if (isVisited && sectionNo == 2) {
                        try {
                          return BuildEvent(
                              document['name'],
                              document['start time'],
                              document['end time'],
                              document['meet link'],
                              showPin,
                              showLink,
                              document.id,
                              document['Details']);
                        } on Exception {
                          return BuildEvent(
                              document['name'],
                              document['start time'],
                              document['end time'],
                              "https://mee.com",
                              showPin,
                              showLink,
                              document.id,
                              document['Details']);
                        }
                      }
                    }
                    return AnimatedContainer(
                      duration: const Duration(seconds: 0),
                    );
                  }).toList(),
                );
            }
          }),
    );
  }

  // ignore: non_constant_identifier_names
  AnimatedContainer BuildEvent(
      String name,
      Timestamp startTime,
      Timestamp endTime,
      String meetLink,
      bool isUpcoming,
      bool isOnGoing,
      String id,
      String details) {
    DateTime eventStartDate = startTime.toDate();
    DateTime eventEndDate = endTime.toDate();

    String eventDateStr =
        DateFormat('yyyy-MM-dd : h:m').format(eventStartDate) +
            " to " +
            DateFormat('yyyy-MM-dd : h:m').format(eventEndDate);

    return AnimatedContainer(
      duration: const Duration(seconds: 10),
      curve: Curves.fastOutSlowIn,
      height: (activeDocument == id) ? 200 : 170,
      child: Container(
        margin: const EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width - 20,
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Pallete.light_purple,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 5,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Text(
                name,
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Text(
                eventDateStr,
                style: const TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
            Row(children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50.0),
                ),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (activeDocument == id) {
                        activeDocument = "";
                      } else {
                        activeDocument = id;
                      }
                    });
                  },
                  child: Text(
                    (activeDocument != id) ? "Details" : "Close",
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
              ),
              const Spacer(),
              if (isUpcoming)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (!pinnedEvents.contains(id)) {
                        pinnedEvents.add(id);
                        AddPinnedEvent(name, id, startTime);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Event Pinned To Calender :)'),
                            action: SnackBarAction(
                              label: 'View',
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Calender(),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      } else {
                        pinnedEvents.remove(id);
                        removePinnedEvent(id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                const Text('Event UnPinned From Calender :)'),
                            action: SnackBarAction(
                              label: 'View',
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Calender(),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      }
                    });
                  },
                  child: Icon(
                    Icons.push_pin_rounded,
                    color: (pinnedEvents.contains(id))
                        ? Pallete.dark_purple
                        : Colors.white,
                    size: 25,
                  ),
                ),
              if (isOnGoing)
                ClipRRect(
                  borderRadius: BorderRadius.circular(50.0),
                  child: Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                          onTap: () async {
                            Uri url = Uri.parse(meetLink);
                            if (await canLaunchUrl(url)) {
                              await launchUrl(url,
                                  mode: LaunchMode.externalApplication);
                            } else {
                              throw "Could not launch $url";
                            }
                          },
                          child: const Text("Join", style: TextStyle(fontSize: 15))),
                    ),
                  ),
                ),
            ]),
            if (activeDocument == id)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: AnimatedContainer(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    duration: const Duration(seconds: 20),
                    curve: Curves.fastOutSlowIn,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(details),
                    )),
              )
          ],
        ),
      ),
    );
  }

  void AddPinnedEvent(String name, String id, Timestamp strDate) async {
    final userEmail = user?.email.toString();
    final collectionName = "pinned " + (userEmail.toString());
    final CollectionReference collection =
        FirebaseFirestore.instance.collection(collectionName);
    await collection
        .doc(id)
        .set({'date': strDate, 'name': name})
        // ignore: avoid_print
        .then((_) => print("success"))
        .catchError((error) => print);
  }

  void removePinnedEvent(String id) async {
    final userEmail = user?.email.toString();
    final collectionName = "pinned " + (userEmail.toString());
    FirebaseFirestore.instance
        .collection(collectionName)
        .doc(id)
        .delete()
        .then((_) {
    }).catchError((error) {
    });
  }
}
