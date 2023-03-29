import 'dart:async';
import 'package:flutter/material.dart';
import 'package:therapp/Pallete.dart';
import 'Message.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:bubble/bubble.dart';
import 'package:therapp/DiaryNoteBook.dart';
import 'DiaryPage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:openai_client/openai_client.dart';
import 'package:openai_client/src/model/openai_chat/chat_message.dart';

class Diary extends StatefulWidget {
  Diary({Key? key}) : super(key: key);
  _WidgetState createState() => _WidgetState();
}

class _WidgetState extends State<Diary> {
  bool _Diary = true;
  bool _isloading = false;

  var inputController = TextEditingController();

  int Limit = 7;

  List<ChatMessage> SharedMessages = [
    ChatMessage(
        role: "system",
        content:
            "You are called \'Therapp Bot\' a proffessional therapist with the aim of making the user feel better")
  ];

  List<Message> messages = [
    Message(text: "Hello, Welcome to Lets Chat by TherApp. ", isFromMe: false),
    Message(
        text:
            "Here you will be able to share and interact with a chatbot that was trained on real world conversations between a Therapist and a patient. ",
        isFromMe: false),
    Message(
        text:
            "Non of the information you share here will be recorded. please note that the model is still in development and some output might not be accurate.",
        isFromMe: false)
  ];

  void AddMessage(String message, String role) {
    if (SharedMessages.length > Limit) {
      SharedMessages.removeAt(1);
    }
    SharedMessages.add(ChatMessage(role: role, content: message));
  }

  final conf = OpenAIConfiguration(
      apiKey: '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');

  Future<void> generate(String message) async {
    String response = "";
    final client = OpenAIClient(
      configuration: conf,
      enableLogging: true,
    );

    AddMessage(message, "user");

    final chat = await client.chat
        .create(
          model: 'gpt-3.5-turbo',
          messages: SharedMessages,
        )
        .data;

    response = chat.choices[0].message.content;

    AddMessage(response, "assistant");

    Message ms = Message(text: response, isFromMe: false);
    setState(() {
      messages.add(ms);
      _isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Pallete.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        //This gives us the bar at the top of the layout
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Container(
                child: GestureDetector(
              onTap: (() {
                setState(
                  () {
                    _Diary = true;
                  },
                );
              }),
              child: Text(
                'Your Diary',
                style: TextStyle(
                  color: _Diary ? Pallete.dark_purple : Pallete.text_color1,
                ),
              ),
            )),
            Spacer(),
            Container(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _Diary = false;
                  });
                },
                child: Container(
                  child: Text(
                    "Let's talk",
                    style: TextStyle(
                      color:
                          !_Diary ? Pallete.dark_purple : Pallete.text_color1,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: _Diary ? DiaryPage() : buildChat(),
    );
  }

  Column buildChat() {
    return Column(
      children: [
        Expanded(
          child: GroupedListView<Message, DateTime>(
            padding: EdgeInsets.all(10),
            useStickyGroupSeparators: true,
            elements: messages,
            groupBy: (message) => DateTime(2022),
            groupHeaderBuilder: (Message message) => SizedBox(),
            itemBuilder: (context, Message message) => Bubble(
              color: message.isFromMe ? Pallete.dark_purple : Colors.white,
              margin: BubbleEdges.only(top: 10),
              alignment:
                  message.isFromMe ? Alignment.topRight : Alignment.topLeft,
              child: Text(
                message.text,
                style: TextStyle(
                    color:
                        message.isFromMe ? Colors.white : Pallete.dark_purple),
              ),
            ),
          ),
        ),
        Row(
          children: [
            Container(
              margin: EdgeInsets.only(left: 10),
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: Pallete.dark_purple,
                borderRadius: BorderRadius.circular(20),
              ),
              child: GestureDetector(
                onTap: (() {}),
                child: Icon(
                  Icons.mic,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width - 100,
              child: TextField(
                cursorColor: Pallete.dark_purple,
                controller: inputController,
                decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Pallete.light_purple),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Pallete.light_purple),
                    ),
                    contentPadding: EdgeInsets.all(12),
                    hintText: "Express your feelings here"),
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 1,
                onSubmitted: (value) {
                  if (!_isloading) {
                    final mess = Message(text: value, isFromMe: true);
                    print("subm");
                    setState(() {
                      inputController.text = "";
                      messages.add(mess);
                      _isloading = true;
                      generate(mess.text);
                    });
                  }
                },
              ),
            ),
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  color: Pallete.dark_purple,
                  borderRadius: BorderRadius.circular(20)),
              child: GestureDetector(
                onTap: (() {
                  if (!_isloading) {
                    final mess = Message(
                        text: inputController.text.trim(), isFromMe: true);
                    setState(() {
                      inputController.text = "";
                      messages.add(mess);
                      _isloading = true;
                      generate(mess.text);
                    });
                  }
                }),
                child: (!_isloading)
                    ? const Icon(
                        Icons.send_rounded,
                        size: 20,
                        color: Colors.white,
                      )
                    : const CircularProgressIndicator(color: Colors.white),
              ),
            )
          ],
        ),
      ],
    );
  }

  // void getMessage(String text) async {
  //   var response = await getResponse(text);
  //   if (response != null) {
  //     Map<String, dynamic> output = json.decode(response.body);
  //     String message = output["output"];
  //     int lindex = message.lastIndexOf("-->");
  //     message = message.substring(lindex);
  //     message = message.replaceAll("<|endoftext|>", "");
  //     message = message.replaceAll("&nbsp;", ".");
  //     message = message.replaceAll("\n", " ");
  //     Message ms = Message(text: message, isFromMe: false);
  //     setState(() {
  //       messages.add(ms);
  //       _isloading = false;
  //     });
  //   } else {
  //     setState(() {
  //       messages.add(Message(
  //           text: "Failed to get response. check your internet connection",
  //           isFromMe: false));
  //       _isloading = false;
  //     });
  //   }
  //   print("done");
  // }

  // Future<http.Response?> getResponse(String text) async {
  //   var url = 'https://therapp-prediction-n5yjitcc5q-lm.a.run.app/predict';
  //   text = text + " -->";

  //   Map data = {'text': text};
  //   //encode Map to JSON
  //   var body = json.encode(data);
  //   print("here");
  //   var response = await http.post(Uri.parse(url),
  //       headers: {"Content-Type": "application/json"}, body: body);

  //   return response;
  // }
}
