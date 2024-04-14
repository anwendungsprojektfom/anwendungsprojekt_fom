import 'package:flutter/material.dart';
import 'package:sth_app/pages/profilescreen/settings.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final bool? onBack;
  final bool showChatIcon;
  final bool showChatScreen;
  final bool showSettingsIcon;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.onBack,
    this.showChatIcon = true,
    this.showChatScreen = false,
    this.showSettingsIcon = false,
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
      leading: widget.onBack != null && widget.onBack!
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                if (widget.onBack != null && widget.onBack!) {
                  Navigator.pop(context);
                }
              },
            )
          : null,
      actions: <Widget>[
        if (widget.showChatIcon && widget.showChatScreen)
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline),
            onPressed: () {
              Navigator.pushNamed(context, '/chatscreen');
            },
          ),
        if (widget.showSettingsIcon) 
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
          ),
      ],
    );
  }
}