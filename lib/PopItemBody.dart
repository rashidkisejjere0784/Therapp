
// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:therapp/Pallete.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'Event.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class PopItemBody extends StatefulWidget {
  String Category = "";
  PopItemBody(String category, {Key? key}) : super(key: key) {
    Category = category;
  }
  @override
  _PopItemBodyState createState() => _PopItemBodyState();
}

class _PopItemBodyState extends State<PopItemBody> {
  String Event_date = "dd/mm/yr hr/min - hr/min";
  DateTime start = DateTime.now();
  DateTime end = DateTime.now();

  final EventNameController = TextEditingController();
  final DescriptionController = TextEditingController();
  final GoogleMeetController = TextEditingController();

  List<DateTime>? dateTime;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
                child: Text(
              "Create a new ${widget.Category} Support group",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            )),
            const Divider(
              color: Pallete.background,
              thickness: 0.2,
            ),
            Padding(
                padding: const EdgeInsets.all(1.0),
                child: BuildTextField(
                    Icons.event, "Event name", EventNameController)),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: BuildTextField(
                    Icons.description, "Description", DescriptionController)),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: BuildTextField(
                    Icons.link,
                    "Copy and paste your google meeting link here",
                    GoogleMeetController)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () async {
                  Uri url = Uri.parse("https://meet.google.com");
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  } else {
                    throw "Could not launch $url";
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Pallete.dark_purple),
                child: const Text("Get Link"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(1),
              child: Text(
                Event_date,
                style: const TextStyle(color: Pallete.text_color1, fontSize: 15),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () async {
                  dateTime = await showOmniDateTimeRangePicker(
                      context: context, primaryColor: Pallete.dark_purple);

                  setState(() {
                    if (dateTime != null) {
                      start = dateTime?[0] ?? DateTime.now();
                      end = dateTime?[1] ?? DateTime.now();

                      Event_date =
                          DateFormat('yyyy-MM-dd : h:m').format(start) +
                              " - " +
                              DateFormat('yyyy-MM-dd : h:m').format(end);
                    }
                  });
                },
                style: ElevatedButton.styleFrom(backgroundColor: Pallete.dark_purple),
                child: const Text("Select the date and time"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  createGroup();
                },
                style: ElevatedButton.styleFrom(backgroundColor: Pallete.dark_purple),
                child: const Text("Create"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future createGroup() async {
    final docEvent =
        FirebaseFirestore.instance.collection("SupportGroups").doc();

    String meetLink = GoogleMeetController.text.trim();
    if (!meetLink.startsWith("https://")) {
      meetLink = "https://" + meetLink;
    }

    //validate link
    if (!meetLink.contains("meet.google")) {
      meetLink = "https://Invalid" + meetLink;
    }
    final json = {
      'name': EventNameController.text.trim(),
      'Category': widget.Category,
      'Details': DescriptionController.text.trim(),
      'start time': start,
      'meet link': meetLink,
      'end time': end
    };

    await docEvent.set(json);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Event(widget.Category)),
    );
  }

  Widget BuildTextField(
      IconData icon, String hintText, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2, left: 10),
      child: TextField(
          controller: controller,
          minLines: 1,
          maxLines: 5,
          decoration: InputDecoration(
              prefixIcon: Icon(icon, color: Pallete.light_purple),
              enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Pallete.text_color1),
                  borderRadius: BorderRadius.all(Radius.circular(35.0))),
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Pallete.text_color1),
                  borderRadius: BorderRadius.all(Radius.circular(35.0))),
              contentPadding: const EdgeInsets.all(10),
              hintText: hintText,
              hintStyle: const TextStyle(fontSize: 14, color: Pallete.text_color2))),
    );
  }
}
