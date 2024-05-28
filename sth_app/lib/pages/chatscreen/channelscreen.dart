import 'package:flutter/material.dart';
import 'package:sth_app/pages/chatscreen/chatscreen.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class ChannelListPage extends StatefulWidget {
  const ChannelListPage({
    Key? key,
    required this.client,
  }) : super(key: key);

  final StreamChatClient client;

  @override
  State<ChannelListPage> createState() => _ChannelListPageState();
}

class _ChannelListPageState extends State<ChannelListPage> {
  late final _controller = StreamChannelListController(
    client: widget.client,
    channelStateSort: const [SortOption('last_message_at')],
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<Channel> createChannel(String otherUserId) async {
    final channel = widget.client.channel(
      'messaging',
      extraData: {
        'members': ['John', otherUserId],
      },
    );

    await channel.create();
    await channel.watch();

    return channel;
  }

  void _handleNewChat() async {
    const otherUserId = 'students_organisation';
    Channel channel = await createChannel(otherUserId);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => StreamChannel(
          channel: channel,
          child: const ChatScreen(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: StreamChannelHeader(
          showBackButton: true,
          onBackPressed: () {
            Navigator.of(context).pushReplacementNamed('/homescreen');
          },
          onImageTap: () {
            Navigator.of(context).pushReplacementNamed('/profilescreen');
          },
          title: const Text("Chats"),
        ),
        body: RefreshIndicator(
          onRefresh: _controller.refresh,
          child: StreamChannelListView(
            controller: _controller,
            onChannelTap: (channel) => Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => StreamChannel(
                  channel: channel,
                  child: const ChatScreen(),
                ),
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _handleNewChat,
          child: const Icon(Icons.add),
        ),
      );
}
