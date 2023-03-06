//Main.dart
import 'package:flutter/material.dart';
import 'package:notificaciones_push/homScreem.dart';
import 'LoginScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'sign_in.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  await FirebaseMessaging.instance.getToken();
  final fcmToken = await FirebaseMessaging.instance.getToken();
  print("FCM Token: $fcmToken");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inicio"),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(children: <Widget>[
          const UserAccountsDrawerHeader(
              accountName: Text("Equipo 1"),
              accountEmail: Text("equipo1@unideh.edu.mx")),
          Card(
            child: ListTile(
              title: const Text("Inicio"),
              trailing: const Icon(Icons.home),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
        ]),
      ),
      body: Container(
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlutterLogo(size: 150),
                SizedBox(height: 50,),
                _signinButton(),
              ],
            ),
          )
      ),
    );
  }

  _signinButton() {
    return OutlinedButton(
      onPressed: () {
        signWithGoogle().then((user) {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return HomeScreen();
          }));
        });
      },
      style: OutlinedButton.styleFrom(
        shadowColor: Colors.grey,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        elevation: 0,
        side: BorderSide(width: 1, color: Colors.grey),
        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),

      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //Image(image: AssetImage('assets/google_logo.png'), height: 5.0,),
          Padding(padding: const EdgeInsets.only(left: 10),
            child: Text("Sign in with Google",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,

                )),)
        ],
      ),
    );
  }
/*
  _signinButton2() {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () {},
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.grey),
      child: Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 10)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(image: AssetImage('assets/google_logo.png'), height: 35.0,),
          Padding(padding: const EdgeInsets.only(left: 10),
            child: Text("Sign in with Google",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,

                )),)
        ],
      ),
    );
  }*/
}
