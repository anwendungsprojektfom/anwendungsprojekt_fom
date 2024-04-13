import 'package:flutter/material.dart';
import 'package:sth_app/main.dart';
import 'package:sth_app/pages/chatscreen/channelscreen.dart';
import 'package:sth_app/pages/homescreen/homescreen.dart';
import 'package:sth_app/technical/technical.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final bool? onBack;
  final bool showChatIcon;

  const CustomAppBar({
    Key? key,
    required this.title,
    required this.onBack,
    required this.showChatIcon,
  }) : super(key: key);

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
        title: Text(widget.title),
        centerTitle: true,
        leading: widget.onBack == true
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  {
                    Navigator.pushReplacement(context, CustomPageRoute(builder: (context) => const HomeScreen()));
                  }
                })
            : null,
        actions: widget.showChatIcon
            ? <Widget>[
                IconButton(
                  icon: const Icon(Icons.chat_bubble_outline),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      CustomPageRoute(
                        builder: (context) => StreamChat(
                          client: globalClient,
                          child: StreamChannel(
                            channel: globalChannel,
                            child: ChannelListPage(client: globalClient),
                          ),
                        ),
                      ),
                    );
                  },
                )
              ]
            : null);
  }
}
