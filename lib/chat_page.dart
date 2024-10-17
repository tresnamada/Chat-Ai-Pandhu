import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import 'widgets/chat_bubble.dart';

const apiKey = "AIzaSyD3dqlu-l5Irc98mE-Dt7IDru-MdHethEw";

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);

  TextEditingController messageController = TextEditingController();

  bool isLoading = false;

  List<ChatBubble> chatBubbles = [
    const ChatBubble(
      direction: Direction.left,
      message: 'Halo! Apakah ada yang ingin dibantu?',
      type: BubbleType.alone,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CupertinoButton(
          child: Image.asset("assets/img/arrow-left.png"),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white, shape: BoxShape.circle),
                  child: Image.asset("assets/img/aibot.png"),
                ),
                SizedBox(
                  width: 5,
                ),
                const Column(
                  children: [
                    Text(
                      "SiPandhu",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Plus Jakarta Sans',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Teman AI Anda',
                      style: TextStyle(
                        color: Color(0xFFFBC1B1),
                        fontSize: 10,
                        fontFamily: 'Plus Jakarta Sans',
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  ],
                ),
              ],
            ),
            Image.asset("assets/img/more.png")
          ],
        ),
        backgroundColor: const Color(0xFFF6643C),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics()),
              reverse: true,
              padding: const EdgeInsets.all(10),
              children: chatBubbles.reversed.toList(),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: TextField(
                      controller: messageController,
                      decoration: const InputDecoration(
                        hintText: 'Ketik Pesan',
                      ),
                    ),
                  ),
                ),
                isLoading
                    ? const CircularProgressIndicator.adaptive()
                    : Stack(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: ShapeDecoration(
                                color: Color(0xFFF6643C),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(58))),
                          ),
                          IconButton(
                            icon: const Image(
                                image: AssetImage("assets/img/send-2.png")),
                            onPressed: () async {
                              setState(() {
                                isLoading = true;
                              });

                              final content = [
                                Content.text(messageController.text)
                              ];

                              final GenerateContentResponse responseAi =
                                  await model.generateContent(content);

                              chatBubbles = [
                                ...chatBubbles,
                                ChatBubble(
                                    direction: Direction.right,
                                    message: messageController.text,
                                    photoUrl: null,
                                    type: BubbleType.alone)
                              ]; //Bubblechat

                              chatBubbles = [
                                ...chatBubbles,
                                ChatBubble(
                                    direction: Direction.left,
                                    message: responseAi.text ??
                                        'Maaf, saay tidak mengerti',
                                    photoUrl:
                                        'https://i.pravatar.cc/150?img=47',
                                    type: BubbleType.alone)
                              ];

                              messageController.clear();
                              setState(() {
                                isLoading = false;
                              });
                            },
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
