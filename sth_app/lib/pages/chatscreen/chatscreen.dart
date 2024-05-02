import 'package:flutter/material.dart';
import 'package:sth_app/main.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:sth_app/pages/chatscreen/channelscreen.dart';
import 'package:sth_app/technical/technical.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamChat(
      client: globalClient, // Replace 'your_api_key' with your actual API key
      child: Scaffold(
        appBar: StreamChannelHeader(
          showBackButton: true,
          onBackPressed: () {
            Navigator.of(context).pushReplacement(
              CustomPageRoute.generateRoute(
                StreamChat(
                  client: globalClient,
                  child: StreamChannel(
                    channel: globalChannel,
                    child: ChannelListPage(client: globalClient),
                  ),
                ),
              ),
            );
          },
          onImageTap: () {
            Navigator.of(context).pushReplacementNamed('/profilescreen');
          },
        ),
        body: const Column(
          children: [
            Expanded(
              child: StreamMessageListView(),
            ),
            StreamMessageInput(),
          ],
        ),
      ),
    );
  }
}
