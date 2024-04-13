import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:sth_app/pages/chatscreen/channelscreen.dart';
import 'package:sth_app/pages/homescreen/homescreen.dart';
import 'package:sth_app/pages/loadingscreen/loadingscreen.dart';
import 'package:sth_app/pages/profilescreen/profilescreen.dart';
import 'package:sth_app/pages/searchscreen/searchscreen.dart';
import 'package:sth_app/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final client = StreamChatClient(
    'ujgtsxqgs2kv',
  );

  await client.connectUser(
    User(id: 'test2'),
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoidGVzdDIifQ.hfNj5j67fyf4z2UBwxQcOqQD6hT74F6bBY6x-aYXzrg',
  );

  final channel = client.channel('messaging', id: 'flutterdevs');
  channel.watch();

  runApp(SthApp(
    client: client,
    channel: channel,
  ));
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
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<UserData> _data = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('users').get();
      List<UserData> data = querySnapshot.docs.map((doc) {
        return UserData(
          name: doc['name'],
          address: doc['address'],
          email: doc['email'],
        );
      }).toList();
      setState(() {
        _data = data;
      });

      // Save data in shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('data', _data.map((userData) => userData.name).toList());
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, widget) => StreamChat(
        client: StreamChatClient(
          'ujgtsxqgs2kv',
        ),
        child: widget,
      ),
      home: StreamChannel(
        channel: widget.channel,
        child: ChannelListPage(client: widget.client),
      ),
      title: 'STH App',
      debugShowCheckedModeBanner: false,
      initialRoute: '/loadingscreen',
      routes: {
        '/loadingscreen': (context) => const LoadingScreen(),
        '/homescreen': (context) => const HomeScreen(),
        '/channelscreen': (context) => ChannelListPage(client: widget.client),
        '/profilescreen': (context) => const ProfileScreen(),
        '/searchscreen': (context) => const SearchScreen(),
      },
    );
  }
}

class UserData {
  final String name;
  final String address;
  final String email;

  UserData({
    required this.name,
    required this.address,
    required this.email,
  });
}
