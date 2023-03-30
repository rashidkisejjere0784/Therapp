// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'Pallete.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({Key? key}) : super(key: key);
  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final bodyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Pallete.background,
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Pallete.dark_purple),
          elevation: 0,
          title: const Center(
            child: Text(
              "Leave a Feedback",
              style: TextStyle(color: Pallete.dark_purple, fontSize: 20),
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
            const SizedBox(height: 10),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: TextFormField(
                  controller: nameController,
                  style: const TextStyle(
                      color: Pallete.dark_purple,
                      fontWeight: FontWeight.bold,
                      fontSize: 22),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: const Icon(Icons.person, color: Pallete.dark_purple),
                      labelText: "NAME",
                      labelStyle: TextStyle(
                          color: Colors.grey[400], fontWeight: FontWeight.w800))),
            ),
            const SizedBox(height: 10),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: TextFormField(
                controller: phoneController,
                style: const TextStyle(
                    color: Pallete.dark_purple,
                    fontWeight: FontWeight.bold,
                    fontSize: 22),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  icon: const Icon(Icons.phone),
                  hintText: "Phone Number",
                  labelText: "Phone",
                  labelStyle: TextStyle(
                      color: Colors.grey[400], fontWeight: FontWeight.w800),
                  prefixText: '+256 ',
                ),
                keyboardType: TextInputType.phone,
                onSaved: (value) {},
                maxLength: 9,
                // TextInputFormatters are applied in sequence.
              ),
            ),
            const SizedBox(height: 10),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(
                      color: Pallete.dark_purple,
                      fontWeight: FontWeight.bold,
                      fontSize: 22),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: const Icon(Icons.email, color: Pallete.dark_purple),
                      labelText: "EMAIL",
                      labelStyle: TextStyle(
                          color: Colors.grey[400], fontWeight: FontWeight.w800))),
            ),
            const SizedBox(height: 10),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: TextFormField(
                controller: bodyController,
                decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: "Enter Your Message",
                    helperText: "Your FeedBack is highly appreciated",
                    labelText: "Message",
                    labelStyle: TextStyle(
                        color: Colors.grey[400], fontWeight: FontWeight.w800)),
                maxLines: 7,
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  await _launchURL();
                },
                child: const Text("Submit"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Pallete.dark_purple,
                  textStyle: const TextStyle(
                      color: Pallete.dark_purple,
                      fontSize: 30,
                      fontStyle: FontStyle.normal),
                ),
              ),
            ),
          ]),
        ));
  }

  _launchURL() async {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String body = bodyController.text.trim();
    String toMailId = "rashidkisejjere0784@gmail.com";
    String subject = "Therapp Feedback From User $name";

    var url = 'mailto:$toMailId?subject=$subject&body=$body&from=$email';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
