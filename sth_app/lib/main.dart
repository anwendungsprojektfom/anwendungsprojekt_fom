import 'package:flutter/material.dart';
import 'package:sth_app/pages/chatscreen/chatscreen.dart';
import 'package:sth_app/pages/homescreen/homescreen.dart';
import 'package:sth_app/pages/profilescreen/profilescreen.dart';
import 'package:sth_app/pages/searchscreen/searchscreen.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() async{
  final client = StreamChatClient(
    'ujgtsxqgs2kv',
    logLevel: Level.INFO,
  );
  
  await client.connectUser(User(id: 'test2'),
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoidGVzdDIifQ.hfNj5j67fyf4z2UBwxQcOqQD6hT74F6bBY6x-aYXzrg');

  final channel = client.channel('messaging', id: 'flutterdevs');

  channel.watch();

  runApp(SthApp(
    client: client,
    channel: channel,
  ));
}

class SthApp extends StatelessWidget {
  const SthApp({
    Key? key,
    required this.client, 
    required this.channel,
    }) : super(key: key);

    final StreamChatClient client;
    final Channel channel;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      builder: (context, widget) => StreamChat(
          client: client, 
          child: widget,
          ),
      home: StreamChannel(
        channel: channel,
        child: const ChatScreen()
        ),
      title: 'STH App', 
      debugShowCheckedModeBanner: false, 
      initialRoute: '/homescreen', 
      routes: {
      '/homescreen': (context) => const HomeScreen(),
      '/chatscreen': (context) => const ChatScreen(),
      '/profilescreen': (context) => const ProfileScreen(),
      '/searchscreen': (context) => const SearchScreen(),
    });
  }
}
