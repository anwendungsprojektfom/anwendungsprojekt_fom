import 'package:flutter/material.dart';
import 'package:sth_app/main.dart';
import 'package:sth_app/pages/chatscreen/channelscreen.dart';
import 'package:sth_app/pages/homescreen/homescreen.dart';
import 'package:sth_app/pages/profilescreen/profilescreen.dart';
import 'package:sth_app/technical/technical.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final bool? onBack;
  final bool showChatIcon;
  final bool showSettings;

  const CustomAppBar({
    Key? key,
    required this.title,
    required this.onBack,
    required this.showChatIcon,
    required this.showSettings,
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
                if (ModalRoute.of(context)?.settings.name == '/settingsscreen') {
                  Navigator.pushReplacement(context, CustomPageRoute(builder: (context) => const ProfileScreen()));
                } else {
                  Navigator.pushReplacement(context, CustomPageRoute(builder: (context) => const HomeScreen()));
                }
              },
            )
          : null,
      actions: [
        if (widget.showChatIcon)
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
          ),
        if (widget.showSettings)
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/settingsscreen');
            },
          ),
      ],
    );
  }
}
