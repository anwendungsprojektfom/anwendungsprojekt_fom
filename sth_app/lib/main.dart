import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sth_app/firebase_options.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'package:sth_app/pages/chatscreen/channelscreen.dart';
import 'package:sth_app/pages/homescreen/homescreen.dart';
import 'package:sth_app/pages/loadingscreen/loadingscreen.dart';
import 'package:sth_app/pages/profilescreen/profilescreen.dart';
import 'package:sth_app/pages/searchscreen/searchscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
        builder: (context, widget) => StreamChat(
              client: client,
              child: widget,
            ),
        home: StreamChannel(
          channel: channel,
          child: ChannelListPage(client: client),
        ),
        title: 'STH App',
        debugShowCheckedModeBanner: false,
        initialRoute: '/loadingscreen',
        routes: {
          '/loadingscreen': (context) => const LoadingScreen(),
          '/homescreen': (context) => const HomeScreen(),
          '/chatscreen': (context) => ChannelListPage(client: client),
          '/profilescreen': (context) => const ProfileScreen(),
          '/searchscreen': (context) => const SearchScreen(),
        });
  }
}
