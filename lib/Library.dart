import 'package:flutter/material.dart';
import 'Pallete.dart';
import 'Article.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Library extends StatefulWidget {
  const Library({Key? key}) : super(key: key);
  @override
  _LibraryState createState() => _LibraryState();
}

class _LibraryState extends State<Library> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final userEmail = user?.email.toString();
    final collection_name = "bookmarked " + (userEmail.toString() ?? " ");
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
            "Library",
            style: TextStyle(
              color: Pallete.dark_purple,
            ),
          ),
          centerTitle: true,
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection(collection_name)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(child: CircularProgressIndicator());
              default:
                if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                  //print(snapshot.data);
                  return const Text('No events found.');
                }

                return ListView(
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    return buildArticle(document['link'], document['name'],
                        document['category'], document['author']);
                  }).toList(),
                );
            }
          },
        ));
  }

  Column buildArticle(
      String web_link, String name, String image, String authorName) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(8.0),
          child: Card(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8.0),
              ),
            ),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Article(
                      Web_link: web_link,
                      Title: name,
                      Img_cat: image,
                      Author: authorName,
                    ),
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch, // add this
                children: <Widget>[
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      topRight: Radius.circular(8.0),
                    ),
                    child: Image.asset("lib/images/" + image + ".jpg",
                        // width: 300,
                        height: 200,
                        fit: BoxFit.fill),
                  ),
                  ListTile(
                    title: Text(
                      name,
                      style: const TextStyle(
                          color: Pallete.dark_purple, fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
