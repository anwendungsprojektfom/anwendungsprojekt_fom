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
      );
}
