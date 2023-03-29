import 'package:flutter/material.dart';
import 'package:therapp/Pallete.dart';
import 'Calender.dart';
import 'package:popup_card/popup_card.dart';
import 'PopItemBody.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:avatar_glow/avatar_glow.dart';

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
    final collection_name = "pinned " + (userEmail.toString() ?? " ");

    FirebaseFirestore.instance
        .collection(collection_name)
        .get()
        .then((querySnapshot) {
      List<String> documentIds = [];

      querySnapshot.docs.forEach((document) {
        documentIds.add(document.id);
      });

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
                builder: (context) => Calender(),
              ));
        },
        child: Icon(Icons.calendar_month),
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
          this.widget.Event_name,
          style: TextStyle(
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
              margin: EdgeInsets.all(10),
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
                Spacer(),
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
                Spacer(),
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
    return Container(
      child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('SupportGroups')
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              default:
                return new ListView(
                  shrinkWrap: true,
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    //check whether event is on going or not
                    if (document['Category'] == this.widget.Event_name) {
                      Timestamp currentTimestamp = Timestamp.now();

                      Timestamp event_start = document['start time'];

                      Timestamp event_end = document['end time'];

                      bool isOnGoing =
                          (currentTimestamp.compareTo(event_start) >= 0) &&
                              (currentTimestamp.compareTo(event_end) <= 0);
                      bool isUpcoming =
                          (currentTimestamp.compareTo(event_start) < 0);

                      bool isVisited =
                          (currentTimestamp.compareTo(event_end) > 0);

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
                        } catch (Exception) {
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
                        } catch (Exception) {
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
                      duration: Duration(seconds: 0),
                    );
                  }).toList(),
                );
            }
          }),
    );
  }

  AnimatedContainer BuildEvent(
      String name,
      Timestamp startTime,
      Timestamp endTime,
      String meetLink,
      bool isUpcoming,
      bool isOnGoing,
      String id,
      String details) {
    bool viewDetails = true;
    DateTime Event_Start_Date = startTime.toDate();
    DateTime Event_End_Date = endTime.toDate();

    String eventDateStr =
        DateFormat('yyyy-MM-dd : h:m').format(Event_Start_Date) +
            " to " +
            DateFormat('yyyy-MM-dd : h:m').format(Event_End_Date);

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
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Text(
                eventDateStr,
                style: TextStyle(color: Colors.white, fontSize: 15),
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
                      } else
                        activeDocument = id;
                    });
                  },
                  child: Text(
                    (activeDocument != id) ? "Details" : "Close",
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ),
              Spacer(),
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
                                    builder: (context) => Calender(),
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
                                    builder: (context) => Calender(),
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
                            if (await canLaunchUrl(url))
                              await launchUrl(url,
                                  mode: LaunchMode.externalApplication);
                            else
                              // can't launch url, there is some error
                              throw "Could not launch $url";
                          },
                          child: Text("Join", style: TextStyle(fontSize: 15))),
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
    final collection_name = "pinned " + (userEmail.toString() ?? " ");
    final CollectionReference collection =
        FirebaseFirestore.instance.collection(collection_name);
    await collection
        .doc(id)
        .set({'date': strDate, 'name': name})
        .then((_) => print("success"))
        .catchError((error) => print);
  }

  void removePinnedEvent(String id) async {
    final userEmail = user?.email.toString();
    final collection_name = "pinned " + (userEmail.toString() ?? " ");
    FirebaseFirestore.instance
        .collection(collection_name)
        .doc(id)
        .delete()
        .then((_) {
      print("Document successfully deleted!");
    }).catchError((error) {
      print("Error deleting document: $error");
    });
  }
}
