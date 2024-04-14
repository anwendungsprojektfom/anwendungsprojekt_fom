import 'package:flutter/material.dart';
import 'package:sth_app/pages/chatscreen/channelscreen.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:sth_app/pages/homescreen/homescreen.dart';
import 'package:sth_app/pages/loadingscreen/loadingscreen.dart';
import 'package:sth_app/pages/profilescreen/profilescreen.dart';
import 'package:sth_app/pages/searchscreen/searchscreen.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:sth_app/firebase_options.dart';

late StreamChatClient globalClient;
late Channel globalChannel;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final client = StreamChatClient('ujgtsxqgs2kv');

  await client.connectUser(User(id: 'test2'),
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoidGVzdDIifQ.hfNj5j67fyf4z2UBwxQcOqQD6hT74F6bBY6x-aYXzrg');

  final channel = client.channel('messaging', id: 'flutterdevs');

  channel.watch();

  globalClient = client;
  globalChannel = channel;

  runApp(SthApp(client: client, channel: channel));
}

class SthApp extends StatelessWidget {
  final StreamChatClient client;
  final Channel channel;
  const SthApp({
    Key? key,
    required this.client,
    required this.channel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamChatTheme(
        data: StreamChatThemeData.fromColorAndTextTheme(
          StreamColorTheme.light(accentPrimary: Colors.blue),
          StreamTextTheme.light(),
        ),
        child: MaterialApp(
          title: 'STH App',
          debugShowCheckedModeBanner: false,
          initialRoute: '/loadingscreen',
          routes: {
            '/loadingscreen': (context) => const LoadingScreen(),
            '/homescreen': (context) => const HomeScreen(),
            '/channelscreen': (context) => ChannelListPage(client: client),
            '/profilescreen': (context) => const ProfileScreen(),
            '/searchscreen': (context) => const SearchScreen(),
          },
          builder: (context, child) {
            final currentRouteName = ModalRoute.of(context)?.settings.name;
            // Conditionally wrap the child with StreamChat based on the route
            if (currentRouteName == '/channelscreen') {
              return StreamChat(
                client: client,
                child: child!,
              );
            } else {
              return child!;
            }
          },
        ));
  }
}
