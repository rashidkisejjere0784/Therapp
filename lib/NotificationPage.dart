import 'package:flutter/material.dart';
import 'package:therapp/Pallete.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Event.dart';

void main() => runApp(const Notifications());

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);
  @override
  State<Notifications> createState() => NotificationState();
}

class NotificationState extends State<Notifications> {
  bool isChecked = false;

  Map<String, IconData> getIcon = {
    "Grief": Icons.beach_access,
    "Relationships": Icons.favorite,
    "Family": Icons.group,
    "Addiction": Icons.medication,
    "Work": Icons.work,
    "Health": Icons.healing,
    "Studies": Icons.book
  };

  Set<String> upcomingEvents = Set();

  @override
  void initState() {
    super.initState();

    try {
      FirebaseFirestore.instance
          .collection("SupportGroups")
          .get()
          .then((snapshots) {
        setState(() {
          snapshots.docs.forEach((document) {
            Timestamp dt_start = document.data()["start time"];
            Timestamp dt_end = document.data()["end time"];
            Timestamp now = Timestamp.now();

            bool isUpcoming = (now.compareTo(dt_start) < 0);

            bool isOnGoing =
                (now.compareTo(dt_start) >= 0) && (now.compareTo(dt_end) <= 0);

            if (isUpcoming || isOnGoing) {
              upcomingEvents.add(document.data()["Category"]);
            }
          });
        });
      });
    } catch (err) {
      print(err.toString());
    }
  }

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
          "Notifications",
          style: TextStyle(
            color: Pallete.dark_purple,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                "Upcoming Events",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Pallete.light_purple),
              ),
              Container(
                height: 200,
                margin: const EdgeInsets.all(10),
                child: (upcomingEvents.length > 0)
                    ? ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          for (var event in upcomingEvents)
                            buildEvent(
                              event,
                              getIcon[event],
                              const Color(0xFFD7D2F2),
                            ),
                        ],
                      )
                    : const Center(
                        child: Text(
                          "There are currently no upcoming Events",
                          style: TextStyle(color: Pallete.dark_purple),
                        ),
                      ),
              ),
              const Text(
                "Your To-Do List",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Pallete.light_purple),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 5, 0, 15),
                margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                width: 330,
                decoration: BoxDecoration(
                  color: const Color(0xFFEDEAFF),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 5,
                        spreadRadius: 2),
                  ],
                ),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                          icon: const Icon(
                            Icons.create_rounded,
                          ),
                          onPressed: () {}),
                    ),
                    createTask("Make a new Friend",
                        "This helps you to be more happy in life"),
                    createTask("Laugh a bit",
                        "Spend some time with a funny friend or watch some comedy. This can help reduce your anxiety"),
                    createTask("Try out something new",
                        "Try painting something or a new sport. Creative expression and overall well-being are linked."),
                    createTask("Breathe in",
                        "Forget about anything that’s stressing you for a moment and take a deep breath for 5 seconds"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  GestureDetector buildEvent(String name, IconData? icon, Color color) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Event(name),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.all(10),
        width: 146,
        decoration: BoxDecoration(
          color: color,
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
          children: [
            Text(
              name,
              textAlign: TextAlign.left,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Icon(icon, color: Colors.white, size: 40),
          ],
        ),
      ),
    );
  }

  CheckboxListTile createTask(String title, String description) {
    return CheckboxListTile(
      controlAffinity: ListTileControlAffinity.leading,
      title: Text(title),
      subtitle: Text(description),
      value: isChecked,
      onChanged: (value) {
        setState(() {});
      },
      activeColor: Pallete.light_purple,
      checkColor: Colors.white,
    );
  }
}
