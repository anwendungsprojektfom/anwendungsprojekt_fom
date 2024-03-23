import 'package:flutter/material.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final bool? onBack;
  final bool showChatIcon;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.onBack,
    this.showChatIcon = true,
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
        leading: widget.onBack != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  if (widget.onBack != null) {
                    Navigator.pop(context);
                  } else {
                    null;
                  }
                })
            : null,
        actions: widget.showChatIcon
            ? <Widget>[
                IconButton(
                  icon: const Icon(Icons.chat_bubble_outline),
                  onPressed: () {
                    Navigator.pushNamed(context, '/chatscreen');
                  },
                )
              ]
            : null);
  }
}
