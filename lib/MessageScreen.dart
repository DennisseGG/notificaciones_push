import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MessageScreen extends StatefulWidget {
  final DocumentSnapshot doc;

  const MessageScreen({
    required this.doc,
  });

  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;
  User? user;
  TextEditingController controller = TextEditingController();

  _getUser() async {
    User? u = auth.currentUser;
    setState(() {
      user = u;
    });
  }

  @override
  void initState() {
    _getUser();
    super.initState();
  }

  _messagehandler(String entrada) {
    print(entrada);
    db
        .collection("users")
        .doc(widget.doc.id)
        .collection("notifications")
        .add({
      "message": entrada,
      "title": user?.email,
      "date": FieldValue.serverTimestamp()
    }).then((document) {
      controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.doc.get("email"),
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Row(
            children: <Widget>[
              Flexible(
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: "¿Cuál es el mensaje?",
                  ),
                ),
              ),
              FloatingActionButton(
                onPressed: () {
                  if (controller.text.isNotEmpty) {
                    _messagehandler(controller.text);
                  }
                },
                child: Icon(Icons.send),
              )
            ],
          ),
        ),
      ),
    );
  }
}
