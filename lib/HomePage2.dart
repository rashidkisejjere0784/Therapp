import 'package:therapp/Library.dart';
import 'package:therapp/NotificationPage.dart';
import 'package:flutter/material.dart';
import 'package:therapp/Pallete.dart';
import 'package:therapp/Article.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:avatar_glow/avatar_glow.dart';

class HomePage2 extends StatefulWidget {
  const HomePage2({Key? key}) : super(key: key);
  @override
  _WidgetState createState() => _WidgetState();
}

class _WidgetState extends State<HomePage2> {
  // ignore: non_constant_identifier_names
  List<List<String>> All_Articles = [
    [
      "cdc.gov/mentalhealth/learn/index.htm",
      "Mental Health",
      "health",
      "0",
      "CDC"
    ],
    [
      "https://www.britannica.com/topic/happiness",
      "Importance of being happy",
      "happiness",
      "1",
      'britannicca'
    ],
    [
      "https://medicine.yale.edu/news-article/yale-study-probes-connection-between-excessive-screen-media-activity-and-mental-health-problems-in-youth/", //link
      "The connection between Social Media and Mental Health", //title
      "health-socials", //image
      "2", //article-number
      "Yale School of Medicine" //author
    ],
    [
      "https://www.mayoclinic.org/tests-procedures/meditation/in-depth/meditation/art-20045858",
      "Importance of meditation",
      "health-matters",
      "3",
      "mayo clinic"
    ],
    [
      "https://www.who.int/news-room/fact-sheets/detail/depression",
      "Depression",
      "depression-smile",
      "4",
      'WHO'
    ],
    [
      "https://www.webmd.com/depression/guide/causes-depression",
      "Causes of depression",
      "depression",
      "5",
      "author name"
    ],
    [
      "https://www.mayoclinichealthsystem.org/hometown-health/speaking-of-health/addressing-your-mental-health-by-identifying-the-signs-of-anxiety-and-depression",
      "Identifying signs of anxiety and depression",
      "anxiety2",
      "6",
      '2018 - 2023 Mayo Clinic Health Systems'
    ],
    [
      "https://www.mayoclinichealthsystem.org/hometown-health/speaking-of-health/overwhelmed-by-anxiety",
      "Overwhelmed by anxiety?",
      "anxiety",
      "7",
      '2018 - 2023 Mayo Clinic Health Systems'
    ],
    [
      "https://www.mayoclinichealthsystem.org/hometown-health/speaking-of-health/tips-to-help-ease-anxiety",
      "Tips to help ease anxiety",
      "anxiety-relief", //change this
      "8",
      '2018 - 2023 Mayo Clinic Health Systems'
    ],
    [
      "https://www.who.int/news-room/questions-and-answers/item/stress",
      "What is Stress",
      "anxiety3",
      "9",
      'WHO'
    ],
    [
      "https://www.mayoclinichealthsystem.org/hometown-health/speaking-of-health/5-tips-to-manage-stress",
      "Tips to manage stress",
      "anxiety-free",
      "10",
      '2018 - 2023 Mayo Clinic Health Systems'
    ],
    [
      "https://www.mayoclinichealthsystem.org/hometown-health/speaking-of-health/college-students-and-depression",
      "College students and depression",
      "depression-college",
      "11",
      '2018 - 2023 Mayo Clinic Health Systems'
    ],
    [
      "https://www.talkspace.com/blog/relationship-problems/",
      "15 Most Common Relationship Problems & Solutions",
      "health-relationship",
      "12",
      'Meaghan Rice PsyD., LPC'
    ],
    [
      "https://www.talkspace.com/blog/the-state-of-our-mental-health-relationships/",
      "The State of Our Mental Health",
      "health-gates",
      "13",
      'Reina Gattuso'
    ],
    [
      "https://www.talkspace.com/blog/coronavirus-quarantine-relationships-conflict-roommate-partner/",
      "Household Conflict When You’re Stuck at Home",
      "anxiety-family",
      "14",
      'Reina Gattuso'
    ],
  ];
  // ignore: non_constant_identifier_names
  var _Article_list = <List<String>>[];

  List<String> bookMarked = [];

  @override
  void initState() {
    super.initState();
    _Article_list = All_Articles;
    final user = FirebaseAuth.instance.currentUser;
    final userEmail = user?.email.toString();
    final collectionName = "bookmarked " + (userEmail.toString());

    FirebaseFirestore.instance
        .collection(collectionName)
        .get()
        .then((querySnapshot) {
      List<String> documentIds = [];

      querySnapshot.docs.forEach((document) {
        documentIds.add(document.id);
      });

      setState(() {
        bookMarked = documentIds;
      });
    });
  }

  String _getGreeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  void addBookmark(String name, String id, String category, String link,
      // ignore: non_constant_identifier_names
      String Author) async {
    final user = FirebaseAuth.instance.currentUser;
    final userEmail = user?.email.toString();
    final collectionName = "bookmarked " + (userEmail.toString());
    final CollectionReference collection =
        FirebaseFirestore.instance.collection(collectionName);
    await collection
        .doc(id)
        .set({
          'category': category,
          'name': name,
          'link': link,
          'author': Author
        })
        .then((_) => print("success"))
        .catchError((error) => print);
  }

  void removeBookmark(String id) async {
    final user = FirebaseAuth.instance.currentUser;
    final userEmail = user?.email.toString();
    final collectionName = "bookmarked " + (userEmail.toString());
    FirebaseFirestore.instance
        .collection(collectionName)
        .doc(id)
        .delete()
        .then((_) {
      print("Document successfully deleted!");
    }).catchError((error) {
      print("Error deleting document: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 100,
        title: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getGreeting(),
                  style: const TextStyle(
                    fontSize: 30,
                    color: Pallete.dark_purple,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  "Articles for you",
                  style: TextStyle(
                    fontSize: 15,
                    color: Pallete.dark_purple,
                  ),
                )
              ],
            ),
            const Spacer(),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Notifications()),
                  );
                },
                child: const AvatarGlow(
                  endRadius: 30.0,
                  glowColor: Pallete.dark_purple,
                  child: Icon(
                    Icons.notifications,
                    color: Pallete.dark_purple,
                    size: 40,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Container(
            margin: const EdgeInsets.all(8),
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              items: <String>[
                'all',
                'health',
                'depression',
                'happiness',
                'anxiety'
              ].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _Article_list = [];
                  for (var article in All_Articles) {
                    if (article[2].startsWith(value ?? "")) {
                      _Article_list.add(article);
                    } else if (value == "all") {
                      _Article_list.add(article);
                    }
                  }
                });
              },
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView(
              scrollDirection: Axis.vertical,
              children: [
                for (List<String> article in _Article_list)
                  buildArticle(article[0], article[1], article[2], article[3],
                      article[4]),
              ],
            ),
          )
        ],
      ),
    );
  }

//method used for article building
  Stack buildArticle(
    String webLink,
    String name,
    String image,
    String id,
    String authorName,
  ) {
    return Stack(
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
                      Web_link: webLink,
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
        Container(
          margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width - 85,
              (MediaQuery.of(context).size.height / 2) - 280, 0, 0),
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(100),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 4,
                spreadRadius: 2,
              ),
            ],
            // border: Border.all(width: 2),
          ),
          child: GestureDetector(
            onTap: () {
              setState(() {
                if (!bookMarked.contains(id)) {
                  bookMarked.add(id);
                  addBookmark(name, id, image, webLink, authorName);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Article Added To Library'),
                      action: SnackBarAction(
                        label: 'View',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Library(),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                } else {
                  bookMarked.remove(id);
                  removeBookmark(id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Article Removed From Library'),
                      action: SnackBarAction(
                        label: 'View',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Library(),
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
              (bookMarked.contains(id))
                  ? Icons.bookmark
                  : Icons.bookmark_add_outlined,
              color: Pallete.dark_purple,
            ),
          ),
        )
      ],
    );
  }
}
