import 'package:flutter/material.dart';
// import 'package:sth_app/pages/homescreen/homescreen.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    // Hier wird nach einer Verzögerung von 4 Sekunden zum Homescreen navigiert
    Future.delayed(const Duration(seconds: 4), () {
      Navigator.pushReplacementNamed(context, '/homescreen');
    });
  }

  @override
  Widget build(BuildContext context) {
    // Hier kannst du dein Logo importieren und anzeigen
    final logo = Image.asset('assets/logo.png');
    return Scaffold(
      // Ein einfaches Scaffold mit einem weißen Hintergrund
      backgroundColor: Colors.white,
      body: Center(
        child:
            CircularProgressIndicator(), // Ein Lade-Indikator, um anzuzeigen, dass die App lädt
      ),
    );
  }
}
