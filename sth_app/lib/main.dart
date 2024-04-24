import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:sth_app/pages/chatscreen/channelscreen.dart';
import 'package:sth_app/pages/homescreen/homescreen.dart';
import 'package:sth_app/pages/loadingscreen/loadingscreen.dart';
import 'package:sth_app/pages/profilescreen/profilescreen.dart';
import 'package:sth_app/pages/profilescreen/accountprofilescreen.dart';
import 'package:sth_app/pages/searchscreen/searchscreen.dart';
import 'package:sth_app/firebase_options.dart';
import 'package:sth_app/technical/technical.dart';

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

class SthApp extends StatefulWidget {
  final StreamChatClient client;
  final Channel channel;
  const SthApp({
    Key? key,
    required this.client,
    required this.channel,
  }) : super(key: key);

  @override
  _SthAppState createState() => _SthAppState();
}

class _SthAppState extends State<SthApp> {
  Future<void> fetchData() async {
    try {
      Map<String, dynamic> currentUserData = await getCurrentUserData('MtPDCjiV4J3MRwO79mqY');

      saveUserDataToSharedPreferences(currentUserData);
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

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
            '/channelscreen': (context) => ChannelListPage(client: globalClient),
            '/profilescreen': (context) => const ProfileScreen(),
            '/searchscreen': (context) => const SearchScreen(),
            '/accountprofilescreen': (context) => const AccountProfileScreen(),
          },
          builder: (context, child) {
            final currentRouteName = ModalRoute.of(context)?.settings.name;
            if (currentRouteName == '/channelscreen') {
              return StreamChat(
                client: globalClient,
                child: child!,
              );
            } else {
              return child!;
            }
          },
        ));
  }
}
