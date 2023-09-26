import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:health_app/app_colors.dart';
import 'package:health_app/views/chats/components/message_card.dart';

import '../../constant.dart';
import 'components/chatroom_appbar.dart';
import 'components/chatroom_bottom_sheet.dart';

class ChatRoomPage extends StatefulWidget {
  const ChatRoomPage({super.key});

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  late TextEditingController messageController;

  List<Message> messages = [
    Message(fromMe: true, text: "Hello"),
    Message(fromMe: true, text: "How are doing today?"),
    Message(fromMe: false, text: "Hi"),
    Message(fromMe: true, text: "How are doing today?"),
    Message(fromMe: false, text: "Hi"),
    Message(fromMe: true, text: "How are doing today?"),
    Message(fromMe: false, text: "Hi"),
    Message(fromMe: true, text: "How are doing today?"),
    Message(fromMe: false, text: "Hi"),
    Message(fromMe: false, text: "I am good."),
  ];

  @override
  void initState() {
    // TODO: implement initState
    messageController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    d.init(context);
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage("assets/images/wallpaper.jpg")),
          ),
          child: Column(
            children: [
              const ChatRoomAppBar(),
              Expanded(
                  child: Container(
                color: Colors.transparent,
                child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      final message = messages[index];

                      return MessageCard(
                          text: message.text, fromMe: message.fromMe);
                    },
                    separatorBuilder: (context, index) => SizedBox(
                          height: d.pSH(5),
                        ),
                    itemCount: messages.length),
              )),
              ChatroomBottomSheet(messageController: messageController),
            ],
          ),
        ),
      ),
    );
  }
}

class Message {
  bool fromMe;
  String text;

  Message({required this.fromMe, required this.text});
}
