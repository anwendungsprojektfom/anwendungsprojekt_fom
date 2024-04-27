import 'package:flutter/material.dart';
import 'package:sth_app/main.dart';
import 'package:sth_app/pages/chatscreen/channelscreen.dart';
import 'package:sth_app/technical/technical.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final dynamic title;
  final bool? onBack;
  final bool showChatIcon;
  final bool showSettings;
  final String? route;

  const CustomAppBar({
    Key? key,
    required this.title,
    required this.onBack,
    required this.showChatIcon,
    required this.showSettings,
    this.route,
  }) : super(key: key);

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    print(ModalRoute.of(context)?.settings.name);
    return AppBar(
      title: widget.title,
      centerTitle: true,
      leading: widget.onBack == true
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pushReplacementNamed(widget.route ?? '/homescreen');
              },
            )
          : null,
      actions: [
        if (widget.showChatIcon)
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline),
            onPressed: () {
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
          ),
        if (widget.showSettings)
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/accountprofilescreen');
            },
          ),
      ],
    );
  }
}
