// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:therapp/Pallete.dart';
import 'Message.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:bubble/bubble.dart';
import 'DiaryPage.dart';
import 'package:openai_client/openai_client.dart';
// ignore: implementation_imports
import 'package:openai_client/src/model/openai_chat/chat_message.dart';

class Diary extends StatefulWidget {
  const Diary({Key? key}) : super(key: key);
  @override
  _WidgetState createState() => _WidgetState();
}

class _WidgetState extends State<Diary> {
  // ignore: non_constant_identifier_names
  var _Diary = true;
  bool _isloading = false;

  var inputController = TextEditingController();

  int Limit = 7;

  List<ChatMessage> SharedMessages = [
    const ChatMessage(
        role: "system",
        content:
            "You are called \'Therapp Bot\' a proffessional therapist and psychologist. i will provide you with thoughts and feelings. i want to you to give me scientific suggestions that will make me feel better. please make sure to listen first few times before giving any suggestions. get to know that i am very delicate and all your responses should be very proffessional")
  ];

  List<Message> messages = [
    const Message(text: "Hello, Welcome to Lets Chat by TherApp. ", isFromMe: false),
    const Message(
        text:
            "Here you will be able to share and interact with a chatbot that was trained on real world conversations between a Therapist and a patient. ",
        isFromMe: false),
    const Message(
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

  final conf = const OpenAIConfiguration(
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
            GestureDetector(
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
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                setState(() {
                  _Diary = false;
                });
              },
              child: Text(
                "Let's talk",
                style: TextStyle(
                  color:
                      !_Diary ? Pallete.dark_purple : Pallete.text_color1,
                ),
              ),
            ),
          ],
        ),
      ),
      body: _Diary ? const DiaryPage() : buildChat(),
    );
  }

  Column buildChat() {
    return Column(
      children: [
        Expanded(
          child: GroupedListView<Message, DateTime>(
            padding: const EdgeInsets.all(10),
            useStickyGroupSeparators: true,
            elements: messages,
            groupBy: (message) => DateTime(2022),
            groupHeaderBuilder: (Message message) => const SizedBox(),
            itemBuilder: (context, Message message) => Bubble(
              color: message.isFromMe ? Pallete.dark_purple : Colors.white,
              margin: const BubbleEdges.only(top: 10),
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
              margin: const EdgeInsets.only(left: 10),
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: Pallete.dark_purple,
                borderRadius: BorderRadius.circular(20),
              ),
              child: GestureDetector(
                onTap: (() {}),
                child: const Icon(
                  Icons.mic,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(
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
}
