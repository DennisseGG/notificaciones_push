import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'LoginScreen.dart';
import 'MessageScreen.dart';
import 'main.dart';
import 'sign_in.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  late List<DocumentSnapshot> users;

  @override
  void initState() {
    // TODO: implement initState

    _getUsers();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print("onMessage: ${message.data}");
      //_showItemDialog(message);
      _showMessage("Notificación: ", "${message.data}");
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print("onLaunch: ${message.data}");
      //_navigateToItemDetail(message);
      _showMessage("Notificación: ", "${message.data}");
    });
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    /* if(Platform.isIOS){
        _firebaseMessaging.requestNotificationPermissions();
        const IosNotificationSettings(sound: true, badge: true, alert:  true, provisional: true);
    }*/
    super.initState();
  }

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    print("Handling a background message: ${message.data}");
    _showMessage("Notificación: ", "${message.data}");
  }

  _showMessage(title, message) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            title: Text(title),
            content: Text(message),
            actions: <Widget>[
              MaterialButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: Text("Dismiss"),
              )
            ],
          );
        });
  }

  _getUsers() async {
    QuerySnapshot snapshot = await db.collection("users").get();
    setState(() {
      users = snapshot.docs.where((doc) => (doc.data() as Map<String, dynamic>)["token"] != FirebaseAuth.instance.currentUser!.uid).toList();
      print(users);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Home",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            color: Colors.black,
            onPressed: () {
              signOutGoogle().whenComplete((){
                Navigator.of(context).push(MaterialPageRoute(builder: (context){
                  return _signinButton();
                }));
              });
            },
          )
        ],
      ),
      body: Container(
        child: users != null
            ? ListView.builder(
            itemCount: users.length,
            itemBuilder: (ctx, index) {
              return Container(
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text((users[index].data() as Map<String, dynamic>)["email"].toString().substring(0, 1)),
                  ),
                  title: Text((users[index].data() as Map<String, dynamic>)["email"]),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            MessageScreen(
                              doc: users[index],
                            ),
                      ),
                    );
                  },
                ),
              );
            })
            : CircularProgressIndicator(),
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
            child: Text("Volver a entrar",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,

                )),)
        ],
      ),
    );
  }
}