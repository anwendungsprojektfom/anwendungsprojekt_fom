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

  await client.connectUser(User(id: 'John'),
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiSm9obiJ9.ZHqRf0hXB38pwMkr8WcnerUdViBRv-um8MEBigs3FXw');

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
      Map<String, dynamic> currentUserData = await getCurrentUserData('JN2dcl4RbBNSs7VGEbYZ');

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
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case '/loadingscreen':
                return CustomPageRoute.generateRoute(const LoadingScreen());
              case '/homescreen':
                return CustomPageRoute.generateRoute(const HomeScreen());
              case '/channelscreen':
                return CustomPageRoute.generateRoute(ChannelListPage(client: globalClient));
              case '/profilescreen':
                return CustomPageRoute.generateRoute(const ProfileScreen());
              case '/searchscreen':
                return CustomPageRoute.generateRoute(const SearchScreen());
              case '/accountprofilescreen':
                return CustomPageRoute.generateRoute(const AccountProfileScreen()); // Using RouteGenerator here
              default:
                return null;
            }
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
