import 'package:flutter/material.dart';
import 'Pallete.dart';
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/gestures.dart';

class Article extends StatefulWidget {
  String Web_link, Title, Img_cat, Author;

  Article(
      {required this.Web_link,
      required this.Title,
      required this.Img_cat,
      required this.Author});

  @override
  State<Article> createState() => _ArticleState();
}

class _ArticleState extends State<Article> {
  bool isLoading = true;
  List<String> data = [];
  @override
  void initState() {
    super.initState();

    extractData().then((value) {
      setState(() {
        this.data = value;
        isLoading = false;
      });
    });
  }

  Future<List<String>> extractData() async {
    // Getting the response from the targeted url
    //
    final response = await http.Client().get(Uri.parse(this.widget.Web_link));

    final int maxLength = 1500;
    // Status Code 200 means response has been received successfully
    if (response.statusCode == 200) {
      // Getting the html document from the response
      var document = parser.parse(response.body);

      try {
        // Scraping the first article title
        var responseString = document.getElementsByTagName("p");

        var extracted_data = '';

        for (var text in responseString) {
          extracted_data = extracted_data + text.text;
        }
        var content = extracted_data.substring(0, maxLength) + "...";
        return [content, this.widget.Author];
      } catch (e) {
        return ['ERROR!', ''];
      }
    } else {
      return ['ERROR: ${response.statusCode}.', ''];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          this.widget.Title,
          style: const TextStyle(
            color: Pallete.dark_purple,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                            "lib/images/" + this.widget.Img_cat + ".jpg")),
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () async {
                        Uri url = Uri.parse(this.widget.Web_link);
                        if (await canLaunchUrl(url))
                          await launchUrl(url);
                        else
                          // can't launch url, there is some error
                          throw "Could not launch $url";
                      },
                      child: Text(
                          "Acquired from : " +
                              this.widget.Web_link.substring(0, 25) +
                              "...",
                          style: TextStyle(color: Pallete.light_purple)),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text("Author Name : " + data[1],
                        style: const TextStyle(color: Pallete.light_purple)),
                    const SizedBox(
                      height: 10,
                    ),
                    RichText(
                      text: TextSpan(
                        text: data[0],
                        style:
                            const TextStyle(color: Colors.black, fontSize: 20),
                        children: [
                          TextSpan(
                            text: ' Read more',
                            style: const TextStyle(
                              color: Pallete.dark_purple,
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                Uri url = Uri.parse(this.widget.Web_link);
                                if (await canLaunchUrl(url))
                                  await launchUrl(url);
                                else
                                  // can't launch url, there is some error
                                  throw "Could not launch $url";
                              },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
