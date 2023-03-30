import 'package:flutter/material.dart';
import 'Pallete.dart';
import 'Maps.dart';
import 'Event.dart';
import 'Calender.dart';

class Events extends StatefulWidget {
  const Events({Key? key}) : super(key: key);
  @override
  _WidgetState createState() => _WidgetState();
}

class _WidgetState extends State<Events> {
  bool _isEvents = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Pallete.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
        title: Stack(
          children: [
            Container(
              child: GestureDetector(
                onTap: (() {
                  setState(() {
                    _isEvents = true;
                  });
                }),
                child: Text(
                  'Events',
                  style: TextStyle(
                    color:
                        _isEvents ? Pallete.dark_purple : Pallete.text_color1,
                  ),
                ),
              ),
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            ),
            Align(
              alignment: AlignmentDirectional.topEnd,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isEvents = false;
                  });
                },
                child: Container(
                  child: Text(
                    "Maps",
                    style: TextStyle(
                      color: !_isEvents
                          ? Pallete.dark_purple
                          : Pallete.text_color1,
                    ),
                  ),
                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                ),
              ),
            ),
          ],
        ),
      ),
      body: _isEvents ? BuildEvents() : const Maps(),
    );
  }

  // ignore: non_constant_identifier_names
  Scaffold BuildEvents() {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                margin: const EdgeInsets.all(10),
                child: const Text(
                    "The Events are in the form of virtual support groups. Did you know that participation makes you know that you are not alone !!",
                    style:
                        TextStyle(color: Pallete.light_purple, fontSize: 20))),
            Row(
              children: [
                BuildEvent("Relationships", Icons.favorite, const Color(0xFFE2DDFF)),
                BuildEvent("Grief", Icons.beach_access, const Color(0xFFCBC2FF)),
              ],
            ),
            Row(
              children: [
                BuildEvent("Family", Icons.group, const Color(0xFFD7D2F2)),
                BuildEvent("Addiction", Icons.medication, const Color(0xFFC4BCF0)),
              ],
            ),
            Row(
              children: [
                BuildEvent("Work", Icons.work, const Color(0XFFBFBBD8)),
                BuildEvent("Health", Icons.healing, const Color(0xFFA09AC6)),
              ],
            ),
            Row(children: [
              BuildEvent("Studies", Icons.book, const Color(0xFF908DA1)),
            ])
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Calender(),
              ));
        },
        backgroundColor: Pallete.dark_purple,
        child: const Icon(Icons.calendar_month),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  GestureDetector BuildEvent(String name, IconData icon, Color color) {
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
        margin: const EdgeInsets.fromLTRB(20, 15, 0, 5),
        padding: const EdgeInsets.all(5),
        width: (MediaQuery.of(context).size.width / 2) - 30,
        height: 153,
        decoration: BoxDecoration(
          color: color,
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
              alignment: Alignment.topLeft,
              child: Text(
                name,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 70),
            Align(
              alignment: AlignmentDirectional.bottomEnd,
              child: Icon(icon, color: Colors.white, size: 40),
            ),
          ],
        ),
      ),
    );
  }
}
